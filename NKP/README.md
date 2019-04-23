## NKP

Finetuned Devanagari trainedata using `Durggāpāṭha saṃskṛta ṭīkā` by `Naval Kishore Press`

Created in response to [this post at tesseract-ocr Google forum](https://groups.google.com/d/msgid/tesseract-ocr/3f411945-e3d5-4b70-bce6-b33e2aab7bfc%40googlegroups.com)

Images and corresponding Ground truth text has been taken from [Heidelberg historic literature – digitized Durggāpāṭha saṃskṛta ṭīkā](https://digi.ub.uni-heidelberg.de/diglit/durggapatha1890/0005)

### Evaluation Results

With 12 pages (about 150 lines) used for training for 700 iterations and one page used for eval, the results are as follows:

####  tessdata_best/san

      At iteration 0, stage 0, Eval Char error rate=22.924007, Word error rate=62.127595

       build/NKP-eval-san.txt: 142 words  63 44% common  2 1% inserted  77 54% changed


####  tessdata_best/script/Devanagari

      At iteration 0, stage 0, Eval Char error rate=13.307604, Word error rate=47.984793

       build/NKP-eval-deva.txt: 141 words  85 60% common  0 0% inserted  56 40% changed

####  san_NKP (Finetuned)

      At iteration 0, stage 0, Eval Char error rate=7.8737359, Word error rate=33.76221

      build/NKP-eval.txt: 142 words  108 76% common  0 0% inserted  34 24% changed

####  san_NKP_int (Finetuned Integer)

       At iteration 0, stage 0, Eval Char error rate=7.5598106, Word error rate=32.463509

        build/NKP_int-eval.txt: 142 words  106 75% common  0 0% inserted  36 25% changed