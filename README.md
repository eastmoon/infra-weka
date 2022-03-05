# Weka
Tutorial and learning report with infrastructure for open source software "Weka".

## 環境建立

### 下載與安裝

+ [Downloading and installing Weka](https://waikato.github.io/weka-wiki/downloading_weka/)

於 2022.03 當前 Weka 版本分別如下

+ Weka 3.8 為最新穩定版本
+ Weka 3.9 為社群開發版本

可下載的版本區分為

+ 包括 OpenJDK 版本 ( 130MB+ ) ，這包括 Windows、Mac、Linux 版本
+ 不包括 OpenJDK 版本，選用此版本必須優先完成 Java VM 安裝於系統

### Docker

以 OpenJDK 17.0.2 容器為基礎，採用當前穩定版本 3.8 。

+ 執行 Dockerfile 來建立需要的 Weka 容器

```
docker build --rm -t weka .
```

+ 確認安裝結果

```
docker run -ti --rm --entrypoint /bin/bash weka -l -c "ls"
```
> 容器預設可執行檔為 weka.jar，若要替換則使用 --entrypoint 參數

+ 執行 Weka

```
docker run -ti --rm weka weka.classifiers.functions.SGD
```
> 文獻說明使用 ```java -jar weka.jar``` 會直接啟動 weka 軟體，但其預設會包括 GUI，因此若要執行命令模式，需使用 ```java -cp weka.jar <java class in weka.jar>```；參考文獻 [Weka from Command Line](https://stackoverflow.com/questions/17090510)

### Weka 操作

+ 顯示 Weka 類別
    - classifiers 模組，```jar tvf weka.jar | grep weka/classifiers | grep /$```
    - classifiers 中的 functions 類別，```jar tvf weka.jar | grep weka/classifiers/functions | grep \.class$```
    - filters 模組，```jar tvf weka.jar | grep weka/filters | grep /$```
    - filters 中的 supervised 類別，```jar tvf weka.jar | grep weka/filters/supervised | grep \.class$```
    - filters 中的 unsupervised 類別，```jar tvf weka.jar | grep weka/filters/unsupervised | grep \.class$```

## 文獻

+ [Weka](https://www.cs.waikato.ac.nz/ml/index.html)
  - [Weka wiki](https://waikato.github.io/weka-wiki/)
  - [Weka wiki - Command line](https://waikato.github.io/weka-wiki/making_predictions/)
+ 教學
	- [Weka簡介與實作：資料探勘的分群、異常偵測、關聯規則探勘、分類](https://blog.pulipuli.info/2019/10/weka-practice-data-mining-with-weka.html)
	- [Data Mining：Day 4 - Data Mining 工具介紹 - Weka](https://ithelp.ithome.com.tw/articles/10156032)
  - [Weka and Hadoop Part 3](http://markahall.blogspot.com/2013/10/weka-and-hadoop-part-3.html)
