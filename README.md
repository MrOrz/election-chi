# Chi-square feature selection 處理立委政見

從[kiang 把選舉公報結巴斷詞](https://www.facebook.com/groups/g0v.general/permalink/912481898828217/)後的結果，使用 [Chi-square feature selection](http://nlp.stanford.edu/IR-book/pdf/13bayes.pdf) 找出哪些詞與該候選人最相關。

【注意】
以下判斷皆影響處理品質：
 (1) 斷詞品質（目前斷詞會把「臺」「灣」斷開）
 (2) 詞頻前處理品質（目前根本沒做前處理、沒刪stopwords，而公報又很短，詞頻都不高，品質堪慮）
 (3) 程式是否有寫錯（我寫得很頭很昏，有可能寫錯公式）
 (4) Chi-square feature sslection 是否真的能直接拿來判斷「詞」與「分類（候選人）」的關聯（對不起我沒學好 orz）
因此結果只能作為處理詞與分類的參考，**切勿作為價值判斷依據**。

## Installation & Running

0. 下載 [kiang/elections](https://github.com/kiang/elections) 的 [zip 打包擋](https://github.com/kiang/elections/archive/master.zip)
1. 把 chi_square.rb 放在「Console/Command/data/2016_candidates/jieba/」目錄下
2. 執行 `ruby chi_square.rb`
3. 目錄底下會多一個 chi 資料夾，裡面會用同樣的資料夾結構來放每個候選人的 `[用詞, 用詞的 chi-square statistics 分數]`，越高代表越該詞越能把這個候選人從同選區其他候選人的政見中分開。

## License
程式碼與斷詞後資料都 CC0。
