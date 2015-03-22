# Preparing the OFB Data Extract - 1

**Peter Rabinovitch**

**March 22, 2015**

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

|CategoryLabel       | minDe| maxDe|  meanDe| minO| maxO|  meanO| minDo| maxDo| meanDo| minPu| maxPu|    meanPu|
|:-------------------|-----:|-----:|-------:|----:|----:|------:|-----:|-----:|------:|-----:|-----:|---------:|
|                    |   0.0|   100| 14.9538|    0|   75| 0.3013|     0|    42| 0.4307|     0|   100| 14.523105|
|Baby Cupboard       |   0.0|    84|  0.5996|    0|  456| 0.8880|     0|    84| 0.5073|     0|     5|  0.092345|
|City Harvest        |   0.0|   394|  5.7667|    0|    0| 0.0000|     0|     0| 0.0000|     0|     0|  0.000000|
|Donated             |   0.0|   810|  1.9110|    0|  456| 2.4683|     0|   810| 1.9083|     0|    12|  0.002621|
|Fresh Harvest       |   0.5|   214| 16.8306|    0|    0| 0.0000|     0|     0| 0.0000|     0|     0|  0.000000|
|Purchased / Donated | -50.0|   171|  1.6323|    0|  999| 1.9964|     0|   171| 1.4570|   -50|    50|  0.175206|
|School Program      |   0.0|    22|  1.5660|    0|  320| 2.1156|     0|    11| 0.7386|     0|    22|  0.827433|

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

|CategoryLabel       | minFpe| maxFp|  meanFp|
|:-------------------|------:|-----:|-------:|
|                    |      0|     1| 0.01109|
|Baby Cupboard       |      0|    21| 0.29164|
|City Harvest        |      0|     0| 0.00000|
|Donated             |      0|   165| 0.65765|
|Fresh Harvest       |      0|     0| 0.00000|
|Purchased / Donated |      0|    67| 0.64243|
|School Program      |      0|    11| 0.84726|

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

|CategoryLabel       | minAMT| maxAMT| meanAMT|
|:-------------------|------:|------:|-------:|
|                    |      0|      0|   0.000|
|Baby Cupboard       |      0|      0|   0.000|
|City Harvest        |      0|      0|   0.000|
|Donated             |      0|      0|   0.000|
|Fresh Harvest       |      0|      0|   0.000|
|Purchased / Donated |  -1540|   1872|   0.191|
|School Program      |      0|      0|   0.000|

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

|CategoryLabel       | minVP| maxVP| meanVP|    minV|  maxV|   meanV|
|:-------------------|-----:|-----:|------:|-------:|-----:|-------:|
|                    |     0|  2700| 403.75|     0.0|  6750| 1009.38|
|Baby Cupboard       |     0|  2268|  16.19|     0.0|  5670|   40.47|
|City Harvest        |     0| 10638| 176.90|     0.0| 26595|  442.26|
|Donated             |     0| 21870|  51.60|     0.0| 54675|  128.99|
|Fresh Harvest       |    27|  5778| 459.85|    67.5| 14445| 1149.63|
|Purchased / Donated | -1350|  4617|  44.07| -3375.0| 11542|  110.18|
|School Program      |     0|   594|  42.28|     0.0|  1485|  105.70|

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

> Source: local data frame [58 x 3]
> Groups: year(Invoice.Date)

|year(Invoice.Date)|     |  CategoryLabel     |n    |
|:-----------------|:----|-------------------:|----:|
|1                 |1969 |      Baby Cupboard |   30|
|2                 |1969 |            Donated |  560|
|3                 |1969 |Purchased / Donated |  416|
|4                 |1969 |     School Program |   42|
|5                 |2004 |      Baby Cupboard |  456|
|6                 |2004 |            Donated | 2160|
|7                 |2004 |Purchased / Donated | 2052|
|8                 |2005 |      Baby Cupboard |13933|
|9                 |2005 |            Donated |67229|
|10                |2005 |Purchased / Donated |63862|
|..                |...  |               ...  | ... |

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

![plot1][plot1]

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


[plot1]: https://raw.githubusercontent.com/DenisCarriere/food-bank/master/docs/images/plot1.png