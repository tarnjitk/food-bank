# Using the Extract

**Peter Rabinovitch**

**March 22, 2015**

Intro
=====

The purpose of this document is to detail some initial explorations of
the OFB dataset.

Data
====

Data provided by Gary (OFB) to Trent (D4G) early March, 2015. Data
consisted of two zip files, each being an extract of the sql database.
Here we work with an extract of the file DataExport.txt. For details
about what was done and why, see the report ‘Preparing the OFB Data
Extract - 1’ and the output file

~~~~ {.r}
opts_chunk$set(echo=TRUE, warning=FALSE, message=FALSE,fig.width=8, fig.height=5)
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
~~~~

We load the data, look at the fields, and the first few rows….

~~~~ {.r}
data <- read.csv("./Data/OFBData.csv", stringsAsFactors=FALSE)
glimpse(data)
~~~~

    ## Observations: 1443772
    ## Variables:
    ## $ Category            (chr) "A", "A", "A", "A", "A", "A", "A", "A", "A...
    ## $ CategoryLabel       (chr) "Purchased / Donated", "Purchased / Donate...
    ## $ Food                (chr) "Beans", "Beans", "Beans", "Beans", "Beans...
    ## $ Group               (chr) "Legumes", "Legumes", "Legumes", "Legumes"...
    ## $ OrderType           (chr) "1", "1", "1", "1", "1", "1", "1", "1", "1...
    ## $ CLASS               (chr) "Inv", "Inv", "Inv", "Inv", "Inv", "Inv", ...
    ## $ Class.Description   (chr) "Inventory", "Inventory", "Inventory", "In...
    ## $ prodtype            (chr) "R", "R", "R", "R", "R", "R", "R", "R", "R...
    ## $ Customer.Code       (chr) "A0186", "A0000", "A0063", "A0183", "A0089...
    ## $ CustomerClass       (chr) "Food Cupboard", "Food Cupboard", "Communi...
    ## $ DeliveredQTY        (dbl) 1, 1, 1, 1, 1, 1, 1, 1, 2, 0, 0, 0, 4, 4, ...
    ## $ Q_Ordered           (int) 1, 1, 2, 2, 1, 2, 2, 2, 3, 0, 0, 0, 4, 4, ...
    ## $ Q_Donated           (int) 1, 1, 1, 1, 1, 1, 1, 1, 2, 0, 0, 0, 4, 4, ...
    ## $ Q_Purchased         (int) 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
    ## $ AMT                 (dbl) 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
    ## $ DeliveredValuePerLB (int) 27, 27, 27, 27, 27, 27, 27, 27, 54, 0, 0, ...
    ## $ DeliveredValue      (dbl) 67.5, 67.5, 67.5, 67.5, 67.5, 67.5, 67.5, ...
    ## $ Invoice.Date        (chr) "2011-09-22 00:00:00", "2011-09-22 00:00:0...
    ## $ id                  (int) 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,...

Fields
======

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
    ## 1        A 603776
    ## 2        B 128172
    ## 3        C 645730
    ## 4        D  57084
    ## 5        E   4672
    ## 6        F   3797
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
    ## 2       Baby Cupboard 128172
    ## 3        City Harvest   4672
    ## 4             Donated 645730
    ## 5       Fresh Harvest   3797
    ## 6 Purchased / Donated 603776
    ## 7      School Program  57084

Note Category and CategoryLabel are synonyms:\
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
  select(Food) %>%
  group_by(Food) %>%
  tally()
~~~~

    ## Source: local data frame [75 x 2]
    ## 
    ##                 Food     n
    ## 1  Apple_Cereal_Bars  5584
    ## 2        Baby_Cereal 28078
    ## 3          Baby_Food 28356
    ## 4             Bagels  3239
    ## 5             Bakery  1639
    ## 6              Beans 31644
    ## 7              Bread 39031
    ## 8             Butter  2649
    ## 9       Canned_Fruit 34626
    ## 10  Canned_Meat_Tuna 34953
    ## ..               ...   ...

~~~~ {.r}
data %>%
  select(Group) %>%
  group_by(Group) %>%
  tally()
~~~~

    ## Source: local data frame [18 x 2]
    ## 
    ##       Group      n
    ## 1      Baby 127346
    ## 2  Beverage 108311
    ## 3     Bread  42270
    ## 4    Butter  37109
    ## 5       Can 205826
    ## 6    Cereal  36372
    ## 7     Dairy  47580
    ## 8   Dessert  71161
    ## 9      Eggs  36917
    ## 10    Fruit  40852
    ## 11    Grain 161037
    ## 12  Legumes  95884
    ## 13     Meat  37160
    ## 14     Milk  69256
    ## 15     Misc 136982
    ## 16    Snack  83335
    ## 17    Sugar  33312
    ## 18      Veg  73062

Food is the specific item of food ordered or delivered. These have been
condensed from several fields in the original data extract, as many were
eauivalent to eachother.

Group is a grouping of food items. For example ‘Fruit’, ‘fresh Fruit’,
‘Oranges and Apples’, etc all get aggregated into ‘Fruit’

~~~~ {.r}
data %>%
  select(OrderType) %>%
  group_by(OrderType) %>%
  tally()
~~~~

    ## Source: local data frame [3 x 2]
    ## 
    ##   OrderType       n
    ## 1         1 1131148
    ## 2         2   29398
    ## 3   REGULAR  283226

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
    ## 1    CH    4672
    ## 2    FH    3797
    ## 3   Inv 1435303

~~~~ {.r}
data %>%
  select(Class.Description) %>%
  group_by(Class.Description) %>%
  tally()
~~~~

    ## Source: local data frame [3 x 2]
    ## 
    ##   Class.Description       n
    ## 1      City Harvest    4672
    ## 2     Fresh Harvest    3797
    ## 3         Inventory 1435303

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
    ## 1        N    8469
    ## 2        R 1435303

Do not yet know what prodtype means.

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

    ## Source: local data frame [200 x 2]
    ## 
    ##    Customer.Code     n
    ## 1          A0000 12747
    ## 2          A0001  4973
    ## 3          A0002 10178
    ## 4          A0003  8461
    ## 5          A0004 13750
    ## 6          A0005 16304
    ## 7          A0006 19014
    ## 8          A0007 10336
    ## 9          A0008  4248
    ## 10         A0009 18359
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
    ## 1                   12810
    ## 2  Assistance to H   5764
    ## 3   Commun ty Food  18359
    ## 4   Community Food 453256
    ## 5    Crisis Centre   4719
    ## 6          Drop In  12159
    ## 7    Food Cupboard 180276
    ## 8              HUB    985
    ## 9           Hamper  96936
    ## 10  Hamper Program    588
    ## ..             ...    ...

CustomerClass may make an interesting grouping variable for the
analysis.

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
  ) %>% kable()
~~~~

|CategoryLabel       | minDe| maxDe|  meanDe| minO| maxO|  meanO| minDo| maxDo| meanDo| minPu| maxPu|    meanPu|
|:-------------------|-----:|-----:|-------:|----:|----:|------:|-----:|-----:|------:|-----:|-----:|---------:|
|                    |   0.0|   100| 14.9538|    0|   75| 0.3013|     0|    42| 0.4307|     0|   100| 14.523105|
|Baby Cupboard       |   0.0|    84|  0.5951|    0|  456| 0.8826|     0|    84| 0.5084|     0|     5|  0.086782|
|City Harvest        |   0.0|   394|  5.7669|    0|    0| 0.0000|     0|     0| 0.0000|     0|     0|  0.000000|
|Donated             |   0.0|   810|  1.9070|    0|  456| 2.4626|     0|   810| 1.9043|     0|    12|  0.002659|
|Fresh Harvest       |   0.5|   214| 16.7619|    0|    0| 0.0000|     0|     0| 0.0000|     0|     0|  0.000000|
|Purchased / Donated | -50.0|   171|  1.6229|    0|  999| 1.9905|     0|   171| 1.4568|   -50|    50|  0.166042|
|School Program      |   0.0|    22|  1.5587|    0|  320| 2.1308|     0|    11| 0.7758|     0|    22|  0.782864|

We’ll need to find out why there is a negative value for
Purchased/Donated. Again we’ll need to determine the units here
(cases?).

One would *assume* that Q\_Purchased + Q\_Donated = DeliveredQTY. The
following plot will have a 45 degree line if it is in fact the case

~~~~ {.r}
data %>%
  ggplot(aes(DeliveredQTY,Q_Purchased+Q_Donated)) +
  geom_point(size=3.2) 
~~~~

![plot2][https://raw.githubusercontent.com/DenisCarriere/food-bank/master/docs/images/plot2.png]

and we see that it is frequently the case, but not always. This will
need clarification. I suspect that the points not on the 45 degree line
are those where there was some donation of food that was not requested,
and so it was delivered even if not ordered while the supply
lasted….except for the negative value!

Do not know what AMT means, I suspect it is the difference between what
was ordered and delivered?

~~~~ {.r}
data %>%
  group_by(CategoryLabel) %>%
  summarize(
    minAMT=min(AMT),
    maxAMT=max(AMT),
    meanAMT=mean(AMT)
  ) %>% kable()
~~~~

|CategoryLabel       | minAMT| maxAMT| meanAMT|
|:-------------------|------:|------:|-------:|
|                    |      0|      0|  0.0000|
|Baby Cupboard       |      0|      0|  0.0000|
|City Harvest        |      0|      0|  0.0000|
|Donated             |      0|      0|  0.0000|
|Fresh Harvest       |      0|      0|  0.0000|
|Purchased / Donated |  -1540|   1872|  0.1834|
|School Program      |      0|      0|  0.0000|

Next, we have the DeliveredValue section, with DeliveredValuePerLB
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
  ) %>% kable()
~~~~

|CategoryLabel       | minVP| maxVP| meanVP|    minV|  maxV|   meanV|
|:-------------------|-----:|-----:|------:|-------:|-----:|-------:|
|                    |     0|  2700| 403.75|     0.0|  6750| 1009.38|
|Baby Cupboard       |     0|  2268|  16.07|     0.0|  5670|   40.17|
|City Harvest        |     0| 10638| 177.30|     0.0| 26595|  443.26|
|Donated             |     0| 21870|  51.49|     0.0| 54675|  128.72|
|Fresh Harvest       |    27|  5778| 458.05|    67.5| 14445| 1145.14|
|Purchased / Donated | -1350|  4617|  43.82| -3375.0| 11542|  109.55|
|School Program      |     0|   594|  42.08|     0.0|  1485|  105.21|

The invoice date is next

~~~~ {.r}
c(min(data$Invoice.Date),max(data$Invoice.Date))
~~~~

    ## [1] "2005-01-04 00:00:00" "2014-12-31 00:00:00"

~~~~ {.r}
data %>%
  group_by(year(Invoice.Date),CategoryLabel) %>%
  tally()
~~~~

> Source: local data frame [45 x 3]
> Groups: year(Invoice.Date)

|year(Invoice.Date)|     |  CategoryLabel     |n    |
|:-----------------|:----|-------------------:|----:|
|1                 |2005 |      Baby Cupboard |13933|
|2                 |2005 |            Donated |67229|
|3                 |2005 |Purchased / Donated |63862|
|4                 |2006 |      Baby Cupboard |14258|
|5                 |2006 |            Donated |69583|
|6                 |2006 |Purchased / Donated |65716|
|7                 |2007 |      Baby Cupboard |15931|
|8                 |2007 |            Donated |77585|
|9                 |2007 |Purchased / Donated |73143|
|10                |2008 |      Baby Cupboard |15704|
|..                | ... |                ... |  ...|

Finally, we have left in the original id variable form the source data
to allow backtracking if needed.

Some Preliminary Plots
======================

In tis section we present several plots for illustrative/educational
purposes. Interpretation is up to the reader.

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

![plot3][https://raw.githubusercontent.com/DenisCarriere/food-bank/master/docs/images/plot1.png]

~~~~ {.r}
library(GGally)

data %>% 
  select(DeliveredQTY, Q_Ordered,Q_Donated,Q_Purchased,AMT) %>%
  sample_frac(0.1, replace=T) %>%
  ggpairs(axisLabels="none") 
~~~~

![plot4][https://raw.githubusercontent.com/DenisCarriere/food-bank/master/docs/images/plot1.png]

~~~~ {.r}
data %>%
  filter(Customer.Code=='A0055', Food=="Peanut_Butter") %>%
  group_by(year(Invoice.Date),month(Invoice.Date)) %>%
  summarize(
  yr=first(year(Invoice.Date)),
  mo=first(month(Invoice.Date)),
  demand=sum(Q_Ordered)
  ) %>%
  ggplot(aes(x=(yr-2005)*12+mo-1,y=demand))+
  geom_point()  +
  xlab('Month') +
  ylab('Cases Ordered')+
  ggtitle('Agency A0055 Peanut Butter Orders')
~~~~

![plot5][https://raw.githubusercontent.com/DenisCarriere/food-bank/master/docs/images/plot1.png]

~~~~ {.r}
data %>%
  filter(Q_Ordered>0, DeliveredQTY>0) %>%
  ggplot(aes(x=Q_Ordered, y=DeliveredQTY))+
  geom_point()   
~~~~

![plot6][https://raw.githubusercontent.com/DenisCarriere/food-bank/master/docs/images/plot1.png]

~~~~ {.r}
data %>%
  filter(DeliveredQTY>0, Q_Ordered>0) %>%
  ggplot(aes(x=DeliveredQTY,y=Q_Ordered))+
  geom_bin2d(binwidth=c(1,1)) +
  xlim(0,50) +
  ylim(0,50)
~~~~

![plot7][https://raw.githubusercontent.com/DenisCarriere/food-bank/master/docs/images/plot1.png]