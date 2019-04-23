#!/bin/bash
rm -rf build
mkdir build
my_files=$(ls NKP/*.png )
 for my_file in ${my_files}; do
    f=${my_file%.*}
    echo $f 
    time tesseract $f.png        $f -l script/Devanagari --psm 6 --dpi 300 wordstrbox
    mv "$f.box" "$f.wordstrbox" 
    sed -i -e "s/ \#.*/ \#/g"  "$f.wordstrbox"
    sed -e '/^$/d' "$f.gt.txt" > build/tmp.txt
    sed -e  's/$/\n/g' build/tmp.txt > "$f.gt.txt"
    paste --delimiters="\0"  "$f.wordstrbox"  "$f.gt.txt" > "$f.box"
    rm "$f.wordstrbox" build/tmp.txt
    time tesseract "$f.png"        "$f"  -l script/Devanagari  --psm 6 --dpi 300 lstm.train
 done

combine_tessdata -u ~/tessdata_best/script/Devanagari.traineddata ~/tessdata_best/script/Devanagari.

ls -1 NKP/*.lstmf  > build/san.NKP.training_files.txt
sed -i -e '/eval/d' build/san.NKP.training_files.txt
ls -1 NKP/*eval*.lstmf >  build/san.NKP_eval.training_files.txt

rm build/*checkpoint *.traineddata

# review the console output with debug_levl -1 for 100 iterations
# if there are glaring differences in OCR output and groundtruth, review the Wordstr box files

lstmtraining \
  --model_output build/NKP \
  --continue_from  ~/tessdata_best/script/Devanagari.lstm \
  --traineddata ~/tessdata_best/script/Devanagari.traineddata \
  --train_listfile  build/san.NKP.training_files.txt \
  --debug_interval -1 \
  --max_iterations 100

# eval error is minimum at 700 iterations

for num_iterations in {300..1000..100}; do

lstmtraining \
  --model_output build/NKP \
  --continue_from  ~/tessdata_best/script/Devanagari.lstm \
  --traineddata ~/tessdata_best/script/Devanagari.traineddata \
  --train_listfile  build/san.NKP.training_files.txt \
  --debug_interval 0 \
  --max_iterations $num_iterations
  
lstmtraining \
  --stop_training \
  --continue_from build/NKP_checkpoint \
  --traineddata ~/tessdata_best/script/Devanagari.traineddata \
  --model_output san_NKP.traineddata

lstmeval \
  --verbosity -1 \
  --model san_NKP.traineddata \
  --eval_listfile build/san.NKP_eval.training_files.txt 

done

time tesseract NKP/NKP-eval.png build/NKP-eval -l san_NKP --tessdata-dir ./ --psm 6 --dpi 300
wdiff -3 -s  NKP/NKP-eval.gt.txt  build/NKP-eval.txt > build/NKP-diff.txt

echo "Compare with Devanagari"

lstmeval \
  --verbosity -1 \
  --model ~/tessdata_best/script/Devanagari.traineddata \
  --eval_listfile build/san.NKP_eval.training_files.txt 

time tesseract NKP/NKP-eval.png build/NKP-eval-deva -l script/Devanagari  --psm 6  --dpi 300
wdiff -3 -s  NKP/NKP-eval.gt.txt  build/NKP-eval-deva.txt > build/NKP-diff-deva.txt