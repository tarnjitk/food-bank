#### *Peter Rabinovitch* {.author}

#### *March 22, 2015* {.date}

Intro
=====

The purpose of this document is to detail some initial explorations of
the OFB dataset, and the decisions made in preparuing the extract that
was made available to all team members.

The original file is available, but large (650 MB), and so will not be
generally distributed.

Data
====

Data provided by Gary (OFB) to Trent (D4G) early March, 2015. Data
consisted of two zip files, each being an extract of the sql database.
Here we work with the file DataExport.txt

~~~~ {.r}
opts_chunk$set(echo=TRUE, warning=FALSE, message=FALSE,fig.width=8, fig.height=5)
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
~~~~

We load the data, look at the fields, and the first few rows….

~~~~ {.r}
data <- read.csv("./Data/DataExport.txt", stringsAsFactors=FALSE)
names(data)
~~~~

    ##  [1] "Category"                "CategoryLabel"          
    ##  [3] "ProductCategoryOrItem"   "DeliveredQTY"           
    ##  [5] "Q_Ordered"               "Q_Donated"              
    ##  [7] "Q_Purchased"             "Q_FulfillmentPercent"   
    ##  [9] "AMT"                     "id"                     
    ## [11] "sales.order"             "Invoice"                
    ## [13] "Invoice.Date"            "Customer.Code"          
    ## [15] "Customer.Address1"       "CustomerNameCurrent"    
    ## [17] "CustomerClass"           "Purchase.Order"         
    ## [19] "WebVentureConfirmation"  "Product.Code"           
    ## [21] "Product.Description"     "OrderType"              
    ## [23] "CLASS"                   "Class.Description"      
    ## [25] "SubCategory1"            "SubCategory2"           
    ## [27] "prodtype"                "DayOfMonthInvoiced"     
    ## [29] "MonthInvoiced"           "MonthNameInvoiced"      
    ## [31] "MonthNumberNameInvoiced" "YearInvoiced"           
    ## [33] "WeekOfYearInvoiced"      "DayOfWeekInvoiced"      
    ## [35] "FiscalYearInvoiced"      "BookedOrderType"        
    ## [37] "DeliveredValuePerLB"     "DeliveredValue"

~~~~ {.r}
head(data)
~~~~

    ##   Category       CategoryLabel ProductCategoryOrItem DeliveredQTY
    ## 1        A Purchased / Donated                 Beans            1
    ## 2        A Purchased / Donated                 Beans            1
    ## 3        A Purchased / Donated                 Beans            1
    ## 4        A Purchased / Donated                 Beans            1
    ## 5        A Purchased / Donated                 Beans            1
    ## 6        A Purchased / Donated                 Beans            1
    ##   Q_Ordered Q_Donated Q_Purchased Q_FulfillmentPercent AMT id sales.order
    ## 1         1         1           0                  1.0   0  1       61067
    ## 2         1         1           0                  1.0   0  2       61065
    ## 3         2         1           0                  0.5   0  3       61074
    ## 4         2         1           0                  0.5   0  4       61051
    ## 5         1         1           0                  1.0   0  5       61058
    ## 6         2         1           0                  0.5   0  6       61059
    ##   Invoice        Invoice.Date Customer.Code         Customer.Address1
    ## 1   61067 2011-09-22 00:00:00         A0186          166 Frank Street
    ## 2   61065 2011-09-22 00:00:00         A0000        211 Bronson Avenue
    ## 3   61074 2011-09-26 00:00:00         A0063           RR #1 Riceville
    ## 4   61051 2011-09-21 00:00:00         A0183 85 University Pvt., RM 07
    ## 5   61058 2011-09-28 00:00:00         A0089   604 Laurier Avenue West
    ## 6   61059 2011-10-05 00:00:00         A0089   604 Laurier Avenue West
    ##                           CustomerNameCurrent  CustomerClass
    ## 1            Youth Services Bureau - Besserer  Food Cupboard
    ## 2                                   A.P.P.L.E  Food Cupboard
    ## 3                       Riceville Food Centre Community Food
    ## 4                              SFUO-Food Bank  Food Cupboard
    ## 5 Tungasuvvingat Inuit Family Resource Centre  Food Cupboard
    ## 6 Tungasuvvingat Inuit Family Resource Centre  Food Cupboard
    ##   Purchase.Order WebVentureConfirmation Product.Code Product.Description
    ## 1     O000061067                     NA        Beans               Beans
    ## 2     O000061065                     NA        Beans               Beans
    ## 3     O000061074                     NA        Beans               Beans
    ## 4     O000061051                     NA        Beans               Beans
    ## 5     O000061058                     NA        Beans               Beans
    ## 6     O000061059                     NA        Beans               Beans
    ##   OrderType CLASS Class.Description SubCategory1
    ## 1         1   Inv         Inventory        Beans
    ## 2         1   Inv         Inventory        Beans
    ## 3         1   Inv         Inventory        Beans
    ## 4         1   Inv         Inventory        Beans
    ## 5         1   Inv         Inventory        Beans
    ## 6         1   Inv         Inventory        Beans
    ##                   SubCategory2 prodtype DayOfMonthInvoiced MonthInvoiced
    ## 1 .(No SubCategory2 Specified)        R                 22             9
    ## 2 .(No SubCategory2 Specified)        R                 22             9
    ## 3 .(No SubCategory2 Specified)        R                 26             9
    ## 4 .(No SubCategory2 Specified)        R                 21             9
    ## 5 .(No SubCategory2 Specified)        R                 28             9
    ## 6 .(No SubCategory2 Specified)        R                  5            10
    ##   MonthNameInvoiced MonthNumberNameInvoiced YearInvoiced
    ## 1         September          09 - September         2011
    ## 2         September          09 - September         2011
    ## 3         September          09 - September         2011
    ## 4         September          09 - September         2011
    ## 5         September          09 - September         2011
    ## 6           October            10 - October         2011
    ##   WeekOfYearInvoiced DayOfWeekInvoiced FiscalYearInvoiced BookedOrderType
    ## 1                 39          Thursday               2011               2
    ## 2                 39          Thursday               2011               2
    ## 3                 40            Monday               2011               2
    ## 4                 39         Wednesday               2011               2
    ## 5                 40         Wednesday               2011               2
    ## 6                 41         Wednesday               2012               2
    ##   DeliveredValuePerLB DeliveredValue
    ## 1                  27           67.5
    ## 2                  27           67.5
    ## 3                  27           67.5
    ## 4                  27           67.5
    ## 5                  27           67.5
    ## 6                  27           67.5

It seems the fields can be split into a few categories for preliminary
analysis: products, customers, numerical data, and dates. We, at this
point, are simply trying to understand the data, and identify obvious
errors/questions/etc before continuing to a more fulsome analysis.

Products Analysis
=================

For each field, we display the possible values along with the count of
how many rows had that value.

~~~~ {.r}
data %>%
  select(Category) %>%
  group_by(Category) %>%
  tally()
~~~~

    ## Source: local data frame [7 x 2]
    ## 
    ##   Category      n
    ## 1        A 614755
    ## 2        B 130131
    ## 3        C 657881
    ## 4        D  60110
    ## 5        E   4873
    ## 6        F   3987
    ## 7        G    541

~~~~ {.r}
data %>%
  select(CategoryLabel) %>%
  group_by(CategoryLabel) %>%
  tally()
~~~~

    ## Source: local data frame [7 x 2]
    ## 
    ##         CategoryLabel      n
    ## 1                        541
    ## 2       Baby Cupboard 130131
    ## 3        City Harvest   4873
    ## 4             Donated 657881
    ## 5       Fresh Harvest   3987
    ## 6 Purchased / Donated 614755
    ## 7      School Program  60110

So Category and CategoryLabel are synonyms:\
A = Purchased / Donated\
B = Baby Cupboard\
C = Donated\
D = School Program\
E = City Harvest\
F = Fresh Harvest\
G = ’’

-   Category A - Items that Food Bank guarantees to Agencies. Will go
    out and buy if none on hand. However, max quantity that is provided
    is determined by the designation/quota given to the specific
    Agency.\
-   Category B - Baby Cupboard\
-   Category C - Donated items: If the Food Bank has it, they will give
    it to the Agency. These items will not be specifically bought to
    match a request.\
-   Category D - School Program (27 schools, Tues/Thurs)\
-   Category E - City Harvest\
-   Category F - Fresh Harvest Website\
-   Category G - Christmas Cheer

~~~~ {.r}
data %>%
  select(ProductCategoryOrItem) %>%
  group_by(ProductCategoryOrItem) %>%
  tally()
~~~~

    ## Source: local data frame [85 x 2]
    ## 
    ##    ProductCategoryOrItem     n
    ## 1      Apple Cereal Bars  5897
    ## 2            Baby Cereal 28344
    ## 3              Baby Food 28603
    ## 4                 Bagels  3375
    ## 5                 Bakery  2748
    ## 6                  Beans 32106
    ## 7                  Bread 38875
    ## 8                 Butter  2802
    ## 9               Can Tuna   392
    ## 10          Canned Fruit 35285
    ## ..                   ...   ...

~~~~ {.r}
data %>%
  select(Product.Code) %>%
  group_by(Product.Code) %>%
  tally()
~~~~

    ## Source: local data frame [100 x 2]
    ## 
    ##    Product.Code     n
    ## 1    BabyCereal 28344
    ## 2      BabyFood 28603
    ## 3         Beans 32106
    ## 4         Bread 35962
    ## 5        Bread1  1836
    ## 6  CC_HalalMeat   116
    ## 7        CC_Ham   201
    ## 8     CC_Turkey   224
    ## 9      CH_Bread  1008
    ## 10  CH_Desserts   855
    ## ..          ...   ...

~~~~ {.r}
data %>%
  select(Product.Description) %>%
  group_by(Product.Description) %>%
  tally()
~~~~

    ## Source: local data frame [95 x 2]
    ## 
    ##    Product.Description     n
    ## 1    Apple Cereal Bars  5897
    ## 2          Baby Cereal 28344
    ## 3            Baby Food 28603
    ## 4               Bagels  3375
    ## 5               Bakery  2748
    ## 6                Beans 32106
    ## 7                Bread 38867
    ## 8    Bread - Kickstart     8
    ## 9               Butter  2802
    ## 10            Can Tuna   392
    ## ..                 ...   ...

~~~~ {.r}
data %>%
  select(SubCategory1) %>%
  group_by(SubCategory1) %>%
  tally()
~~~~

    ## Source: local data frame [31 x 2]
    ## 
    ##                    SubCategory1      n
    ## 1  .(No SubCategory1 Specified) 730278
    ## 2                         Beans  32106
    ## 3                         Bread  43258
    ## 4                        Cereal  37179
    ## 5                      Crackers  38540
    ## 6                      Desserts    855
    ## 7                       Diapers  42225
    ## 8                      DryPasta  34521
    ## 9                       Formula  30959
    ## 10                   Fresh Eggs  37706
    ## ..                          ...    ...

~~~~ {.r}
data %>%
  select(SubCategory2) %>%
  group_by(SubCategory2) %>%
  tally()
~~~~

    ## Source: local data frame [1 x 2]
    ## 
    ##                   SubCategory2       n
    ## 1 .(No SubCategory2 Specified) 1472278

There seems to be no obvious connection between ProductCategoryOrItem,
Product.Code, Product.Description and SubCategory1. A next step will be
to find out what the purpose of each, and/or aggregate into a single
string that describes the food item. Note that there are only

~~~~ {.r}
length(unique(paste(data$ProductCategoryOrItem, data$Product.Code, data$Product.Description, data$SubCategory1),sep='|'))
~~~~

    ## [1] 114

unique combinations, so we will hand tune these into meaningful strings.
See end of doc for specific questions, as there seem to be many
‘duplicates’. If this is the case, we can reduce the items to about 70
distinct ones, and then about 20 categories. This will help when
plotting, etc.

SubCategory2 is not informative.

~~~~ {.r}
data %>%
  select(OrderType) %>%
  group_by(OrderType) %>%
  tally()
~~~~

    ## Source: local data frame [3 x 2]
    ## 
    ##   OrderType       n
    ## 1         1 1136819
    ## 2         2   29443
    ## 3   REGULAR  306016

Do not know what OrderType means yet.

~~~~ {.r}
data %>%
  select(CLASS) %>%
  group_by(CLASS) %>%
  tally()
~~~~

    ## Source: local data frame [3 x 2]
    ## 
    ##   CLASS       n
    ## 1    CH    4873
    ## 2    FH    3987
    ## 3   Inv 1463418

~~~~ {.r}
data %>%
  select(Class.Description) %>%
  group_by(Class.Description) %>%
  tally()
~~~~

    ## Source: local data frame [3 x 2]
    ## 
    ##   Class.Description       n
    ## 1      City Harvest    4873
    ## 2     Fresh Harvest    3987
    ## 3         Inventory 1463418

Clearly CH is City Harvest, FH is Fresh Harvest, and Inv is Inventory.
Need to find out what they mean, if they matter to our project.

~~~~ {.r}
data %>%
  select(prodtype) %>%
  group_by(prodtype) %>%
  tally()
~~~~

    ## Source: local data frame [2 x 2]
    ## 
    ##   prodtype       n
    ## 1        N    8860
    ## 2        R 1463418

Do not yet know what prodtype means. BookedOrderType is not informative.

~~~~ {.r}
data %>%
  select(BookedOrderType) %>%
  group_by(BookedOrderType) %>%
  tally()
~~~~

    ## Source: local data frame [1 x 2]
    ## 
    ##   BookedOrderType       n
    ## 1               2 1472278

Customers
=========

Customer.Code should join to the agencies file that already has the lat
& lon in it. All the Customer.Code in this file have a match in the
agencies file. Note however that here are agencies that have no records
in this file. For reference, the ones that do not are: A0016, A0019,
A0022, A0026, A0036, A0038, A0060, A0086, A0090, A0091, A0093, A0122,
A0170, A0224, T0004, T0008, T0011, T0014, T0018, T0020, X0008, X0009.
The corresponding CustomerNames match too.

~~~~ {.r}
data %>%
  select(Customer.Code) %>%
  group_by(Customer.Code) %>%
  tally()
~~~~

    ## Source: local data frame [201 x 2]
    ## 
    ##    Customer.Code     n
    ## 1          A0000 13220
    ## 2          A0001  5153
    ## 3          A0002 10395
    ## 4          A0003  8461
    ## 5          A0004 13791
    ## 6          A0005 16634
    ## 7          A0006 19402
    ## 8          A0007 10474
    ## 9          A0008  4289
    ## 10         A0009 18770
    ## ..           ...   ...

~~~~ {.r}
data %>%
  select(CustomerClass) %>%
  group_by(CustomerClass) %>%
  tally()
~~~~

    ## Source: local data frame [34 x 2]
    ## 
    ##      CustomerClass      n
    ## 1                   13048
    ## 2  Assistance to H   5764
    ## 3   Commun ty Food  18770
    ## 4   Community Food 463356
    ## 5    Crisis Centre   4801
    ## 6          Drop In  12282
    ## 7    Food Cupboard 184965
    ## 8              HUB    985
    ## 9           Hamper  97465
    ## 10  Hamper Program    593
    ## ..             ...    ...

CustomerClass may make an interesting grouping variable for the
analysis.

Numerical Data
==============

For the numerical variables, we extract the min, max and mean for each.
Deciphering the names of the columns is best achieved by looking at the
code.

~~~~ {.r}
data %>%
  group_by(CategoryLabel) %>%
  summarize(
  minDe=min(DeliveredQTY),
  maxDe=max(DeliveredQTY),
  meanDe=mean(DeliveredQTY),
  minO=min(Q_Ordered),
  maxO=max(Q_Ordered),
  meanO=mean(Q_Ordered),  
  minDo=min(Q_Donated),
  maxDo=max(Q_Donated),
  meanDo=mean(Q_Donated),  
  minPu=min(Q_Purchased),
  maxPu=max(Q_Purchased),
  meanPu=mean(Q_Purchased)
  ) %>% kable(digits=0)
~~~~

    ## 
    ## 
    ## |CategoryLabel       | minDe| maxDe|  meanDe| minO| maxO|  meanO| minDo| maxDo| meanDo| minPu| maxPu|    meanPu|
    ## |:-------------------|-----:|-----:|-------:|----:|----:|------:|-----:|-----:|------:|-----:|-----:|---------:|
    ## |                    |   0.0|   100| 14.9538|    0|   75| 0.3013|     0|    42| 0.4307|     0|   100| 14.523105|
    ## |Baby Cupboard       |   0.0|    84|  0.5996|    0|  456| 0.8880|     0|    84| 0.5073|     0|     5|  0.092345|
    ## |City Harvest        |   0.0|   394|  5.7667|    0|    0| 0.0000|     0|     0| 0.0000|     0|     0|  0.000000|
    ## |Donated             |   0.0|   810|  1.9110|    0|  456| 2.4683|     0|   810| 1.9083|     0|    12|  0.002621|
    ## |Fresh Harvest       |   0.5|   214| 16.8306|    0|    0| 0.0000|     0|     0| 0.0000|     0|     0|  0.000000|
    ## |Purchased / Donated | -50.0|   171|  1.6323|    0|  999| 1.9964|     0|   171| 1.4570|   -50|    50|  0.175206|
    ## |School Program      |   0.0|    22|  1.5660|    0|  320| 2.1156|     0|    11| 0.7386|     0|    22|  0.827433|

We’ll need to find out why there is a negative value for
Purchased/Donated. Again we’ll need to determine the units here
(cases?).

One would *assume* that Q\_Purchased + Q\_Donated = DeliveredQTY.
Plotting the data shows that it is frequently the case, but not always.
This will need clarification. I suspect that the points not on the 45
degree line are those where there was some donation of food that was not
requested, and so it was delivered even if not ordered while the supply
lasted….except for the negative value!

The following is the fulfillment percent, i.e. what percentage of the
order was filled. Note that , for example, 66% would be shown as 0.66,
so it needs to be investigated why the maximum is 165. That would be,
assuming all calculations are done in the same way, that 16500% of what
was requested was delivered!

~~~~ {.r}
data %>%
  group_by(CategoryLabel) %>%
  summarize(
    minFpe=min(Q_FulfillmentPercent),
    maxFp=max(Q_FulfillmentPercent),
    meanFp=mean(Q_FulfillmentPercent)
  ) %>% kable(digits=3)
~~~~

    ## 
    ## 
    ## |CategoryLabel       | minFpe| maxFp|  meanFp|
    ## |:-------------------|------:|-----:|-------:|
    ## |                    |      0|     1| 0.01109|
    ## |Baby Cupboard       |      0|    21| 0.29164|
    ## |City Harvest        |      0|     0| 0.00000|
    ## |Donated             |      0|   165| 0.65765|
    ## |Fresh Harvest       |      0|     0| 0.00000|
    ## |Purchased / Donated |      0|    67| 0.64243|
    ## |School Program      |      0|    11| 0.84726|

If we plot the Q\_FulfillmentPercent against the
DeliveredQTY/Q\_Ordered, we should see a straight line, and in fact we
do, except for a few weird points. So, I suspect we can delete this
column, and should the need ever arise just calculate it.

Do not know what AMT means, I suspect it is the difference between what
was ordered and delivered?

~~~~ {.r}
data %>%
  group_by(CategoryLabel) %>%
  summarize(
    minAMT=min(AMT),
    maxAMT=max(AMT),
    meanAMT=mean(AMT)
  ) %>% kable(digits=0)
~~~~

    ## 
    ## 
    ## |CategoryLabel       | minAMT| maxAMT| meanAMT|
    ## |:-------------------|------:|------:|-------:|
    ## |                    |      0|      0|   0.000|
    ## |Baby Cupboard       |      0|      0|   0.000|
    ## |City Harvest        |      0|      0|   0.000|
    ## |Donated             |      0|      0|   0.000|
    ## |Fresh Harvest       |      0|      0|   0.000|
    ## |Purchased / Donated |  -1540|   1872|   0.191|
    ## |School Program      |      0|      0|   0.000|

Finally, we have the DeliveredValue section, with DeliveredValuePerLB
(really? pounds in 2015?) and the DeliveredValue. One would assume that
these are in dollar values. This needs to be confirmed, as well as how
the value is determined. And if they are in inflation adjusted dollars
(expect not, so \$1 in 1996 = (say) \$0.73 in 2015).

~~~~ {.r}
data %>%
  group_by(CategoryLabel) %>%
  summarize(
    minVP=min(DeliveredValuePerLB),
    maxVP=max(DeliveredValuePerLB),
    meanVP=mean(DeliveredValuePerLB),
    minV=min(DeliveredValue),
    maxV=max(DeliveredValue),
    meanV=mean(DeliveredValue)
  ) %>% kable(digits=2)
~~~~

    ## 
    ## 
    ## |CategoryLabel       | minVP| maxVP| meanVP|    minV|  maxV|   meanV|
    ## |:-------------------|-----:|-----:|------:|-------:|-----:|-------:|
    ## |                    |     0|  2700| 403.75|     0.0|  6750| 1009.38|
    ## |Baby Cupboard       |     0|  2268|  16.19|     0.0|  5670|   40.47|
    ## |City Harvest        |     0| 10638| 176.90|     0.0| 26595|  442.26|
    ## |Donated             |     0| 21870|  51.60|     0.0| 54675|  128.99|
    ## |Fresh Harvest       |    27|  5778| 459.85|    67.5| 14445| 1149.63|
    ## |Purchased / Donated | -1350|  4617|  44.07| -3375.0| 11542|  110.18|
    ## |School Program      |     0|   594|  42.28|     0.0|  1485|  105.70|

Dates
=====

Here we look at the invoice date.

~~~~ {.r}
c(min(data$Invoice.Date),max(data$Invoice.Date))
~~~~

    ## [1] "1969-12-31 00:00:00" "2015-03-12 00:00:00"

We see perhaps testing data in 1969. I suspect we should exclude those
rows. And perhaps exclude 2004 and 2015 too as they seem incomplete.

~~~~ {.r}
data %>%
  group_by(year(Invoice.Date),CategoryLabel) %>%
  tally()
~~~~

    ## Source: local data frame [58 x 3]
    ## Groups: year(Invoice.Date)
    ## 
    ##    year(Invoice.Date)       CategoryLabel     n
    ## 1                1969       Baby Cupboard    30
    ## 2                1969             Donated   560
    ## 3                1969 Purchased / Donated   416
    ## 4                1969      School Program    42
    ## 5                2004       Baby Cupboard   456
    ## 6                2004             Donated  2160
    ## 7                2004 Purchased / Donated  2052
    ## 8                2005       Baby Cupboard 13933
    ## 9                2005             Donated 67229
    ## 10               2005 Purchased / Donated 63862
    ## ..                ...                 ...   ...

Here we plot the total ‘Q\_Ordered’ for each year, by CategoryLabel,
clearly seeing the incomplete years.

~~~~ {.r}
data %>%
  group_by(yr=year(Invoice.Date),CategoryLabel) %>%  
  summarise(
      total = sum(Q_Ordered)
  ) %>%
  ggplot(aes(x=yr,y=total,fill=CategoryLabel))+
  geom_bar(stat='identity') +
  xlab('Year') +
  ylab('Q-Ordered') +
  scale_x_continuous(labels=abbreviate,limits=c(2003,2016))
~~~~

![plot of chunk
unnamed-chunk-17](data:image/png;base64,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 "plot of chunk unnamed-chunk-17")

Food Items and Categories
=========================

Here we reduce the number of food items,a nd then group them.

~~~~ {.r}
data$Food<-NA
data$Group<-NA

items<-c(
"Apple Cereal Bars:KS_AppleCerealBars:Apple Cereal Bars:Snacks",
"Baby Cereal:BabyCereal:Baby Cereal:.(No SubCategory1 Specified)",
"Baby Food:BabyFood:Baby Food:.(No SubCategory1 Specified)",
"Bagels:KS_Bagels:Bagels:Bread",
"Bakery:FH_Bakery:Bakery:.(No SubCategory1 Specified)",
"Beans:Beans:Beans:Beans",
"Bread:Bread:Bread:Bread",
"Bread:Bread1:Bread:Bread",
"Bread:KS_Bread:Bread:Bread",
"Bakery:CH_Bread:Bakery:Bread",
"Bread:KS_Bread:Bread - Kickstart:Bread",
"Butter:KS_Butter:Butter:Margarine",
"Canned Fruit:CannedFruit:Canned Fruit:.(No SubCategory1 Specified)",
"Meat / Tuna:KS_MeatTuna:Meat / Tuna:Meat/Tuna, Canned",
"Meat/Tuna, Canned(1 case=2):MeatTunaCanned:Meat/Tuna, Canned:Meat/Tuna, Canned",
"Meat/Tuna, Canned(1 case=2):MeatTunaCanned:Meat/Tuna, Canned(1 case=2):Meat/Tuna, Canned",
"Can Tuna:CanTuna:Can Tuna:Meat/Tuna, Canned",
"Vegetables Can:Vegetables:Vegetables Can:.(No SubCategory1 Specified)",
"Fresh Vegetables (Carrots):KS_FreshVegetablesCarrots:Fresh Vegetables (Carrots):Fresh Vegetables (Carrots)",
"Cereal:Cereal:Cereal:Cereal",
"Cereal:KS_Cereal:Cereal:Cereal",
"Cheese and Crackers:CheeseandCrackers:Cheese and Crackers:Crackers",
"Cheese (Brick):KS_CheeseBrick:Cheese (Brick):Yogurt",
"Cheese Slices:KS_CheeseSlices:Cheese Slices:Yogurt",
"Coffee/Tea:CoffeeTea:Coffee/Tea:.(No SubCategory1 Specified)",
"Condiments:Condiments:Condiments:.(No SubCategory1 Specified)",
"Cookies:Cookies:Cookies:.(No SubCategory1 Specified)",
"Crackers:Crackers:Crackers:Crackers",
"Crackers:Crackers:Cheese and Crackers:Crackers",
"Cream Cheese:KS_CreamCheese:Cream Cheese:Yogurt",
"Desserts:Desserts:Desserts:.(No SubCategory1 Specified)",
"Desserts:CH_Desserts:Desserts:Desserts",
"Diapers (Specify size):Diapers:Diapers (Specify size):Diapers",
"Diapers: Adult:Diapers-Adult:Diapers: Adult:Diapers",
"Diapers for Newborns:Diapers-0-Newborn:Diapers for Newborns:Diapers",
"Diapers Pull-Ups:Diapers-PullUp:Diapers Pull-Ups:Diapers",
"Diapers Size 1:Diapers-1:Diapers Size 1:Diapers",
"Diapers Size 2:Diapers-2:Diapers Size 2:Diapers",
"Diapers Size 3:Diapers-3:Diapers Size 3:Diapers",
"Diapers Size 4:Diapers-4:Diapers Size 4:Diapers",
"Diapers Size 5:Diapers-5:Diapers Size 5:Diapers",
"Diapers Size 6:Diapers-6:Diapers Size 6:Diapers",
"Dry Pasta:DryPasta:Dry Pasta:DryPasta",
"Eggs:Eggs:Eggs:Fresh Eggs",
"FRESH EGGS:FRESHEGGS:FRESH EGGS:Fresh Eggs",
"FRESH EGGS:FreshEggs:FRESH EGGS:Fresh Eggs",
"Eggs:KS_Eggs:Eggs:Fresh Eggs",
"FRESH EGGS:FreshEggs:Eggs:Fresh Eggs",
"Flour:Flour:Flour:.(No SubCategory1 Specified)",
"Formula: GoodStart 1 (0-12):Formula-GoodStart-1:Formula: GoodStart 1 (0-12):Formula",
"Formula(GoodStart 0-12 & 6-24):Formula:Formula(GoodStart 0-12 & 6-24):Formula",
"Formula: GoodStart 2 (6-24):Formula-GoodStart-2:Formula: GoodStart 2 (6-24):Formula",
"Fresh Fruit:CH_FreshFruit:Fresh Fruit:Fresh Fruit",
"Fresh Fruit:FH_Fruit:Fresh Fruit:Fresh Fruit",
"Fresh Fruit (Oranges, Apples):KS_FreshFruitOrangesApple:Fresh Fruit (Oranges, Apples):Fresh Fruits (Oranges, Apples)",
"FRESH FRUITS:FRESHFRUITS:FRESH FRUITS:Fresh Fruits",
"FRESH VEGETABLES:FRESHVEGETABLES:FRESH VEGETABLES:Fresh Vegetables",
"Fresh Vegetables:FH_Vegetables:Fresh Vegetables:Fresh Vegetables",
"Fresh Vegetables:CH_Vegetables:Fresh Vegetables:Fresh Vegetables",
"Meat:FH_Meat:Meat:Frozen Meat",
"Meat:CH_Meat:Meat:Frozen Meat",
"FROZEN MEATS:FROZENMEATS:FROZEN MEATS:FrozenMeats",
"Frozen Misc:CH_FrozenMisc:Frozen Misc:Frozen Misc",
"FROZEN MISCELLANEOUS:FROZENMISCELLANEOUS:FROZEN MISCELLANEOUS:.(No SubCategory1 Specified)",
"Fruit Cups (Lite Syrup):KS_FruitCupsLiteSyrup:Fruit Cups (Lite Syrup):Snacks",
"Halal Meat:CC_HalalMeat:Halal Meat:FrozenMeats",
"Ham:CC_Ham:Ham:FrozenMeats",
"Hotdogs:CH_Hotdogs:Hotdogs:Frozen Meat",
"Household:Household:Household:.(No SubCategory1 Specified)",
"Juice:Juice:Juice:Juice",
"Juice Boxes (100% Fruit):KS_JuiceBoxes100%Fruit:Juice Boxes (100% Fruit):Juice Boxes",
"Legumes (lentils/soup mix):Legumes:Legumes (lentils/soup mix):.(No SubCategory1 Specified)",
"LIQUID MILK:LIQUIDMILK:LIQUID MILK:Liquid Milk",
"Milk:CH_Milk:Milk:Liquid Milk",
"LIQUID MILK:LiquidMilk:LIQUID MILK:Liquid Milk",
"Macaroni and Cheese:MacaroniandCheese:Macaroni and Cheese:.(No SubCategory1 Specified)",
"MARGARINE:MARGARINE:MARGARINE:Margarine",
"Milk 2% (Bags):KS_Milk2%Bags:Milk 2% (Bags):Milk 2% (Bags)",
"LIQUID MILK:LIQUIDMILK:Milk 2% (Bags):Liquid Milk",
"Misc:FH_Misc:Misc:MiscReclaimation",
"Misc:CH_Misc:Misc:MiscReclaimation",
"Misc. Perishables:MiscPerishables:Misc. Perishables:MiscPerishables",
"Misc./Reclaimation:MiscReclaimation:Misc./Reclaimation:MiscReclaimation",
"Other Milk:OtherMilk:Other Milk:Other Milk",
"Peanut Butter:PeanutButter:Peanut Butter:.(No SubCategory1 Specified)",
"Popcorn:CH_Popcorn:Popcorn:Snacks",
"Potatoes:Potatoes:Potatoes:.(No SubCategory1 Specified)",
"POWDERED MILK ($34.00):PowderedMilk:POWDERED MILK ($52.00):.(No SubCategory1 Specified)",
"POWDERED MILK ($34.00):PowderedMilk:POWDERED MILK ($35.00):.(No SubCategory1 Specified)",
"POWDERED MILK ($34.00):PowderedMilk:POWDERED MILK ($40.00):.(No SubCategory1 Specified)",
"POWDERED MILK ($34.00):PowderedMilk:POWDERED MILK ($45.00):.(No SubCategory1 Specified)",
"POWDERED MILK ($34.00):PowderedMilk:POWDERED MILK ($44.00):.(No SubCategory1 Specified)",
"POWDERED MILK ($34.00):PowderedMilk:POWDERED MILK ($45):.(No SubCategory1 Specified)",
"POWDERED MILK ($34.00):PowderedMilk:POWDERED MILK ($34.00):.(No SubCategory1 Specified)",
"POWDERED MILK ($34.00):PowderedMilk:POWDERED MILK:.(No SubCategory1 Specified)",
"Prepared Hot Meals:CH_PreparedHotMeals:Prepared Hot Meals:Frozen Meat",
"Prepared Pasta:PreparedPasta:Prepared Pasta:.(No SubCategory1 Specified)",
"Rice:Rice:Rice:.(No SubCategory1 Specified)",
"Sandwiches:CH_Sandwiches:Sandwiches:MiscReclaimation",
"Snacks:Snacks:Snacks:.(No SubCategory1 Specified)",
"Soft Drinks:SoftDrinks:Soft Drinks:.(No SubCategory1 Specified)",
"Soup:Soup:Soup:Soup",
"Soup:CH_Soup:Soup:Soup",
"Stew (1 case=2):Stew:Stew:.(No SubCategory1 Specified)",
"Stew (1 case=2):Stew:Stew (1 case=2):.(No SubCategory1 Specified)",
"Sugar:Sugar:Sugar:MiscReclaimation",
"Tomato Sauce:TomatoSauce:Tomato Sauce:.(No SubCategory1 Specified)",
"Turkey:CC_Turkey:Turkey:FrozenMeats",
"Crackers:Crackers:Crackers (Unsalted):Crackers",
"Crackers (Unsalted):KS_Crackers:Crackers (Unsalted):Crackers",
"Yogurt:Yogurt:Yogurt:Yogurt",
"Yogurt:KS_Yogurt:Yogurt:Yogurt",
"YOGURT/DAIRY:YOGURTDAIRY:YOGURT/DAIRY:Yogurt/Dairy",
"YOGURT/DAIRY:YogurtDairy:Yogurt:Yogurt/Dairy")


foods<-c(
'Apple_Cereal_Bars',
'Baby_Cereal',
'Baby_Food',                     
'Bagels',
'Bakery',
'Beans',                                                                                          
'Bread',
'Bread',
'Bread',
'Bread',
'Bread',
'Butter',                                                                                
'Canned_Fruit',
'Canned_Meat_Tuna',
'Canned_Meat_Tuna',
'Canned_Meat_Tuna',
'Canned_Meat_Tuna',
'Canned_Vegetables',
'Carrots',
'Cereal',
'Cereal',
'Cheese_and_Crackers',
'Cheese_Brick',
'Cheese_Slices',
'Coffee_Tea',
'Condiments',
'Cookies',
'Crackers',
'Crackers',
'Cream_Cheese',
'Desserts',
'Desserts',
'Diapers',
'Diapers_Adult',
'Diapers_Newborn',
'Diapers_PullUps',
'Diapers_Size_1',
'Diapers_Size_2',
'Diapers_Size_3',
'Diapers_Size_4',
'Diapers_Size_5',
'Diapers_Size_6',
'Dry_Pasta',
'Eggs',
'Eggs',
'Eggs',
'Eggs',
'Eggs',
'Flour',
'Formula_GoodStart_0_12',
'Formula_GoodStart_0_12_6_24',
'Formula_GoodStart_6_24', 
'Fresh_Fruit',
'Fresh_Fruit',
'Fresh_Fruit_Oranges_Apples',
'Fresh_Fruit',
'Fresh_Vegetables',
'Fresh_Vegetables',
'Fresh_Vegetables',
'Frozen_Meat',
'Frozen_Meat',
'Frozen_Meat',
'Frozen_Misc',
'Frozen_Misc',
'Fruit_Cups_Lite_Syrup',
'Halal_Meat',
'Ham',
'Hot_Dogs',
'Household',
'Juice',
'Juice_Boxes',
'Legumes_Lentils_Soup_Mix',
'Liquid_Milk',
'Liquid_Milk',
'Liquid_Milk',
'Macaroni_and_Cheese',
'Margarine',
'Milk_2%_Bags',
'Milk_2%_Bags',
'Misc',
'Misc',
'Misc_Perishables',
'Misc',
'Other_Milk',
'Peanut_Butter',
'Popcorn',
'Potatoes',
'Powdered_Milk_$34',
'Powdered_Milk_$34',
'Powdered_Milk_$34',
'Powdered_Milk_$34',
'Powdered_Milk_$34',
'Powdered_Milk_$34',
'Powdered_Milk_$34',                            
'Powdered_Milk_$34',
'Prepared_Hot_Meals',
'Prepared_Pasta',
'Rice',
'Sandwiches',
'Snacks',
'Soft_Drinks',
'Soup',
'Soup',
'Stew',
'Stew',
'Sugar',
'Tomato_Sauce',
'Turkey',
'Unsalted_Crackers',
'Unsalted_Crackers',                                                      
'Yogurt',
'Yogurt',
'Yogurt',
'Yogurt'
)

itemString<-paste(data$ProductCategoryOrItem, data$Product.Code, data$Product.Description, data$SubCategory1,sep=":")
  
for (i in 1:length(items)) {
  ind<-which(itemString==items[i])
  data$Food[ind]<-foods[i]
  }

groups<-c(
'Snack',
'Baby',
'Baby',
'Bread',
'Dessert',
'Legumes',
'Bread',
'Bread',
'Bread',
'Bread',
'Bread',
'Butter',
'Can',
'Can',
'Can',
'Can',
'Can',
'Can',
'Veg',
'Cereal',
'Cereal',
'Snack',
'Dairy',
'Dairy',
'Beverage',
'Misc',
'Dessert',
'Snack',
'Snack',
'Dairy',
'Dessert',
'Dessert',
'Baby',
'Misc',
'Baby',
'Baby',
'Baby',
'Baby',
'Baby',
'Baby',
'Baby',
'Baby',
'Grain',
'Eggs',
'Eggs',
'Eggs',
'Eggs',
'Eggs',
'Grain',
'Baby',
'Baby',
'Baby',
'Fruit',
'Fruit',
'Fruit',
'Fruit',
'Veg',
'Veg',
'Veg',
'Meat',
'Meat',
'Meat',
'Misc',
'Misc',
'Snack',
'Meat',
'Meat',
'Meat',
'Misc',
'Beverage',
'Beverage',
'Legumes',
'Milk',
'Milk',
'Milk',
'Grain',
'Butter',
'Milk',
'Milk',
'Misc',
'Misc',
'Misc',
'Misc',
'Milk',
'Legumes',
'Snack',
'Veg',
'Milk',
'Milk',
'Milk',
'Milk',
'Milk',
'Milk',
'Milk',
'Milk',
'Misc',
'Grain',
'Grain',
'Misc',
'Snack',
'Beverage',
'Can',
'Can',
'Can',
'Can',
'Sugar',
'Can',
'Meat',
'Snack',
'Snack',
'Dairy',
'Dairy',
'Dairy',
'Dairy')


for (i in 1:length(foods)) {
  ind<-which(data$Food==foods[i])
  data$Group[ind]<-groups[i]
  }
~~~~

Column Munging and Export Preparation
=====================================

Here we describe which columns we keep, which we delete, etc.

-   keep Category
-   keep CategoryLabel
-   kill SubCategory2
-   rationalize ProductCategoryOrItem, Product.Code,
    Product.Description, SubCategory1
-   decicde on OrderType
-   merge CLASS + Class.Description
-   decide in prodtype
-   kill BookedOrderType
-   keep Customer.Code
-   keep CustomerClass
-   keep DeliveredQTY
-   keep Q\_Ordered
-   keep Q\_Donated
-   keep Q\_Purchased
-   kill Q\_FulfillmentPercent, as it is derived
-   decide what AMT is and if needed
-   decide what DeliveredValuePerLB and DeliveredValue are
-   keep Invoice.Date
-   keep id as a way to go back to src doc
-   kill sales.order
-   kill Invoice
-   kill Customer.Address1
-   kill CustomerNameCurrent
-   kill Purchase.Order
-   kill WebVentureConfirmation
-   kill DayOfMonthInvoiced
-   kill MonthInvoiced
-   kill MonthNameInvoiced
-   kill MonthNumberNameInvoiced
-   kill YearInvoiced
-   kill WeekOfYearInvoiced
-   kill DayOfWeekInvoiced
-   kill FiscalYearInvoiced

Next, we do the script to do the column munging, making sure we first
did the ‘food item rationalization’ above.

~~~~ {.r}
data2<-data %>%
  select(Category, CategoryLabel, Food, Group, OrderType, CLASS, Class.Description,
  prodtype, Customer.Code, CustomerClass,
  DeliveredQTY, Q_Ordered, Q_Donated, Q_Purchased,
  AMT, DeliveredValuePerLB, DeliveredValue,
  Invoice.Date, id) %>%
  filter(Invoice.Date>="2005-01-01 00:00:00", Invoice.Date<"2015-01-01 00:00:00")
~~~~

Note we include data only from 2005-2014 as data outside this range is
incomplete.

We then export this file to a .csv for distribution.

~~~~ {.r}
write.csv(data2, file = "./Data/OFBData.csv", quote=FALSE, row.names = FALSE)
~~~~

Food Item Questions
===================

Theer are several groupings of items that seem to be the same. Are they,
and if not what is the difference?

“Bread:Bread:Bread:Bread” “Bread:Bread1:Bread:Bread”
“Bread:KS\_Bread:Bread:Bread” “Bakery:CH\_Bread:Bakery:Bread”

“Meat / Tuna:KS\_MeatTuna:Meat / Tuna:Meat/Tuna, Canned” “Meat/Tuna,
Canned(1 case=2):MeatTunaCanned:Meat/Tuna, Canned:Meat/Tuna, Canned”
“Meat/Tuna, Canned(1 case=2):MeatTunaCanned:Meat/Tuna, Canned(1
case=2):Meat/Tuna, Canned” “Can Tuna:CanTuna:Can Tuna:Meat/Tuna, Canned”

“Cereal:Cereal:Cereal:Cereal” “Cereal:KS\_Cereal:Cereal:Cereal”

“Crackers:Crackers:Crackers:Crackers” “Crackers:Crackers:Cheese and
Crackers:Crackers”

“Desserts:Desserts:Desserts:.(No SubCategory1 Specified)”
“Desserts:CH\_Desserts:Desserts:Desserts”

“Eggs:Eggs:Eggs:Fresh Eggs” “FRESH EGGS:FRESHEGGS:FRESH EGGS:Fresh Eggs”
“FRESH EGGS:FreshEggs:FRESH EGGS:Fresh Eggs” “Eggs:KS\_Eggs:Eggs:Fresh
Eggs” “FRESH EGGS:FreshEggs:Eggs:Fresh Eggs”

“Fresh Fruit:CH\_FreshFruit:Fresh Fruit:Fresh Fruit” “Fresh
Fruit:FH\_Fruit:Fresh Fruit:Fresh Fruit”

“FRESH VEGETABLES:FRESHVEGETABLES:FRESH VEGETABLES:Fresh Vegetables”
“Fresh Vegetables:FH\_Vegetables:Fresh Vegetables:Fresh Vegetables”
“Fresh Vegetables:CH\_Vegetables:Fresh Vegetables:Fresh Vegetables”

“Meat:FH\_Meat:Meat:Frozen Meat” “Meat:CH\_Meat:Meat:Frozen Meat”
“FROZEN MEATS:FROZENMEATS:FROZEN MEATS:FrozenMeats”

“Frozen Misc:CH\_FrozenMisc:Frozen Misc:Frozen Misc” “FROZEN
MISCELLANEOUS:FROZENMISCELLANEOUS:FROZEN MISCELLANEOUS:.(No SubCategory1
Specified)”

“LIQUID MILK:LIQUIDMILK:LIQUID MILK:Liquid Milk”
“Milk:CH\_Milk:Milk:Liquid Milk” “LIQUID MILK:LiquidMilk:LIQUID
MILK:Liquid Milk”

“Milk 2% (Bags):KS\_Milk2%Bags:Milk 2% (Bags):Milk 2% (Bags)” “LIQUID
MILK:LIQUIDMILK:Milk 2% (Bags):Liquid Milk”

“Misc:FH\_Misc:Misc:MiscReclaimation”
“Misc:CH\_Misc:Misc:MiscReclaimation”
“Misc./Reclaimation:MiscReclaimation:Misc./Reclaimation:MiscReclaimation”

“POWDERED MILK (\$34.00):PowderedMilk:POWDERED MILK (\$52.00):.(No
SubCategory1 Specified)” “POWDERED MILK (\$34.00):PowderedMilk:POWDERED
MILK (\$35.00):.(No SubCategory1 Specified)” “POWDERED MILK
(\$34.00):PowderedMilk:POWDERED MILK (\$40.00):.(No SubCategory1
Specified)” “POWDERED MILK (\$34.00):PowderedMilk:POWDERED MILK
(\$45.00):.(No SubCategory1 Specified)” “POWDERED MILK
(\$34.00):PowderedMilk:POWDERED MILK (\$44.00):.(No SubCategory1
Specified)” “POWDERED MILK (\$34.00):PowderedMilk:POWDERED MILK
(\$45):.(No SubCategory1 Specified)” “POWDERED MILK
(\$34.00):PowderedMilk:POWDERED MILK (\$34.00):.(No SubCategory1
Specified)” “POWDERED MILK (\$34.00):PowderedMilk:POWDERED MILK:.(No
SubCategory1 Specified)”

“Soup:Soup:Soup:Soup” “Soup:CH\_Soup:Soup:Soup”

“Stew (1 case=2):Stew:Stew:.(No SubCategory1 Specified)” “Stew (1
case=2):Stew:Stew (1 case=2):.(No SubCategory1 Specified)”

“Crackers:Crackers:Crackers (Unsalted):Crackers” “Crackers
(Unsalted):KS\_Crackers:Crackers (Unsalted):Crackers”

“Yogurt:Yogurt:Yogurt:Yogurt” “Yogurt:KS\_Yogurt:Yogurt:Yogurt”

“YOGURT/DAIRY:YOGURTDAIRY:YOGURT/DAIRY:Yogurt/Dairy”
“YOGURT/DAIRY:YogurtDairy:Yogurt:Yogurt/Dairy”

Also, what does “(1 case=2)” mean?
