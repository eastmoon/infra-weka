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
docker run -ti --rm --entrypoint /bin/bash weka                 // 進入容器
docker run -ti --rm --entrypoint /bin/bash weka -l -c "ls"      // 檢視工作目錄內容
```
> 容器預設可執行檔為 weka.jar，若要替換則使用 --entrypoint 參數

+ 執行 Weka

```
docker run -ti --rm weka weka.classifiers.functions.SGD
```
> 文獻說明使用 ```java -jar weka.jar``` 會直接啟動 weka 軟體，但其預設會包括 GUI，因此若要執行命令模式，需使用 ```java -cp weka.jar <java class in weka.jar>```；參考文獻 [Weka from Command Line](https://stackoverflow.com/questions/17090510)

### Weka 指令操作

+ 顯示 Weka 類別
    - classifiers 模組，```jar tvf weka.jar | grep weka/classifiers | grep /$```
    - classifiers 中的 functions 類別，```jar tvf weka.jar | grep weka/classifiers/functions | grep \.class$```
    - filters 模組，```jar tvf weka.jar | grep weka/filters | grep /$```
    - filters 中的 supervised 類別，```jar tvf weka.jar | grep weka/filters/supervised | grep \.class$```
    - filters 中的 unsupervised 類別，```jar tvf weka.jar | grep weka/filters/unsupervised | grep \.class$```

+ [套件安裝 ( Package Manager)](https://waikato.github.io/weka-wiki/packages/manager/)
    - 顯示所有套件，```docker run -ti --rm weka weka.core.WekaPackageManager -list-packages all```
    - 安裝指定套件，```docker run -ti --rm weka weka.core.WekaPackageManager -install-package <packageName>```

### 範例

範例依循[The WEKA Workbench - Chapter 5 The Command-Line Interface](https://www.cs.waikato.ac.nz/ml/weka/Witten_et_al_2016_appendix.pdf#page=91)

#### Getting started

Demo code at page 91，execute tree.J48 with weather.arff

```
docker run -ti --rm -v %cd%\data:/data weka weka.classifiers.trees.J48 -t /data/weather.arff
```

#### weka.Run

**weka.Run command line tool allows you to type in shortened versions of scheme names**

weka.Run 可用來簡化前面操作指定對象的方式

```
docker run -ti --rm -v %cd%\data:/data weka weka.Run .J48 -t /data/weather.arff
```

也可只選擇目標演算法顯示可用的操作

```
docker run -ti --rm weka weka.Run .J48
docker run -ti --rm weka weka.Run .SGD
```

這操作適用於所有透過 Java 類別指定的簡化

```
docker run -ti --rm -v %cd%\data:/data weka weka.Run .Stacking -M .Logistic -B .J48 -B ".FilteredClassifier -F \".Remove -R 1\" -W .NaiveBayes" -B .OneR -t /data/iris.arff
```

若不使用簡化，前述的操作會如下所示

```
docker run -ti --rm -v %cd%\data:/data weka weka.classifiers.meta.Stacking -M weka.classifiers.functions.Logistic -B weka.classifiers.trees.J48 -B "weka.classifiers.meta.FilteredClassifier -F \"weka.filters.unsupervised.attribute.Remove -R 1\" -W weka.classifiers.bayes.NaiveBayes" -B weka.classifiers.rules.OneR -t /data/iris.arff
```

#### The structure of WEKA

+ The weka.core package
    - [Package weka.core](https://weka.sourceforge.io/doc.dev/weka/core/package-summary.html)，提供 Weka 所有演算法的核心類別集，其中包括大量類別與介面供演算法引用，並確保其運作時可與其他演算法相容。
+ The weka.classifiers package
    - [Package weka.classifiers](https://weka.sourceforge.io/doc.stable/weka/classifiers/package-summary.html)，是集合了[分類 ( classification ) 與預測 ( prediction )](https://towardsdatascience.com/classification-regression-and-prediction-whats-the-difference-5423d9efe4ec) 演算法的實現類別集。
+ Other packages
    - [Package weka.associations](https://weka.sourceforge.io/doc.dev/weka/associations/package-summary.html)，[關聯規則學習](https://zh.wikipedia.org/wiki/%E5%85%B3%E8%81%94%E8%A7%84%E5%88%99%E5%AD%A6%E4%B9%A0)演算法類別集。
    - [Package weka.clusterers](https://weka.sourceforge.io/doc.dev/weka/clusterers/package-summary.html)，[集群分析](https://zh.wikipedia.org/wiki/%E8%81%9A%E7%B1%BB%E5%88%86%E6%9E%90)演算法類別集。
    - [Package weka.datagenerators](https://weka.sourceforge.io/doc.dev/weka/datagenerators/package-summary.html)，[資料生成](https://towardsdatascience.com/keras-data-generators-and-how-to-use-them-b69129ed779c)演算類別集。
    - [Package weka.estimators](https://weka.sourceforge.io/doc.dev/weka/estimators/package-summary.html)，[估計量](https://zh.wikipedia.org/wiki/%E4%BC%B0%E8%AE%A1%E9%87%8F)演算類別集
    - [Package weka.filters](https://weka.sourceforge.io/doc.dev/weka/filters/package-summary.html)，定義了所有過濾器的類別集，其實踐類別在如 ```weka.filters.unsupervised.attribute``` 中，提供各類演算法的屬性與資料操作。
    - [Package weka.attributeSelection](https://weka.sourceforge.io/doc.dev/weka/attributeSelection/package-summary.html)，定義了屬性選擇方式的類別集。

#### Command-line options

對於一個可執行的演算法，可用 ```-h```、```--help``` 來檢視其可用操作選項

```
docker run -ti --rm weka weka.Run .J48 -h
```

而其選項可分為兩大類

+ Generic options，通用選項，適用所有演算法 ( 下列舉常用選項 )
    - ```-t```，指定學習 ( Training ) 資料檔
    - ```-T```，指定測試 ( Testing ) 資料檔，若使用 cross-validation 則使用學習資料檔產生測試資料
    - ```-c```，指定 class 屬性在資料集的位置 ( index )，預設為最後
    - ```-x```，cross-validation 分割的 flod 數
    - ```-no-cv```，不執行 cross-validation
    - ```-split-percentage```，指定多少百分比的學習資料分為測試資料
    - ```–preserve-order```，保留百分比分隔的順序資訊
    - ```-s```，設定隨機種子，適用 cross-validation 與 split-percentage
    - ```-m```，指定 [Cost Matrix](https://www.openriskmanual.org/wiki/Cost_Matrix) 檔案
    - ```-l```，指定 model 匯入檔案，其檔案應為 ```.xml``` 檔
    - ```-d```，指定 model 匯出檔案，其檔案應為 ```.xml``` 檔
    - ```-v```，輸出學習資料的非統計數據
    - ```-o```，輸出統計數據
    - ```-k```，輸出 information-theoretic 統計數據
    - ```-threshold-file```，指定 threadhold 匯出檔案，其檔案可為 ```.arff``` 或 ```.csv```
+ Scheme-specific options，演算法特定選項，僅適用該演算法

#### Save and Load model

+ [Weka wiki - Saving and loading models](https://waikato.github.io/weka-wiki/saving_and_loading_models/)
+ [How to Save Your Machine Learning Model and Make Predictions in Weka](https://machinelearningmastery.com/save-machine-learning-model-make-predictions-weka/)

依據文獻說明，對演算法的模組操作如以下方式：

+ 匯出模組

```
docker run -ti --rm -v %cd%\data:/data -v %cd%\cache:/model weka weka.Run .J48 -C 0.25 -M 2 -t /data/weather.arff -d /model/j48.xml
```

+ 匯入模組

```
docker run -ti --rm -v %cd%\data:/data -v %cd%\cache:/model weka weka.Run .J48 -t /data/weather.arff -l /model/j48.xml
```


## 文獻

+ [Weka](https://www.cs.waikato.ac.nz/ml/index.html)
  - [Weka wiki](https://waikato.github.io/weka-wiki/)
  - [Weka wiki - Command line](https://waikato.github.io/weka-wiki/making_predictions/)
+ 教學
  - [online appendix on the Weka workbench](https://www.cs.waikato.ac.nz/ml/weka/Witten_et_al_2016_appendix.pdf)
	- [Weka簡介與實作：資料探勘的分群、異常偵測、關聯規則探勘、分類](https://blog.pulipuli.info/2019/10/weka-practice-data-mining-with-weka.html)
	- [Data Mining：Day 4 - Data Mining 工具介紹 - Weka](https://ithelp.ithome.com.tw/articles/10156032)
  - [Weka and Hadoop Part 3](http://markahall.blogspot.com/2013/10/weka-and-hadoop-part-3.html)
+ 議題
  - [module java.base does not "opens java.lang" to unnamed module](https://www.cnblogs.com/stcweb/articles/15114266.html)
