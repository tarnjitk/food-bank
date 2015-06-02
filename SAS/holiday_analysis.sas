* import the holiday dataset;
proc import file='/folders/myfolders/D4G/world religious holidays 2012-2014.csv'
  			out = holiday1
  			dbms=csv
  			replace;
  			
  datarow=2;
  getnames=yes;
  guessingrows=max;
run;

* data prep (this is the food bank dataset);
data data1;
  set d4g.ofbdata;
  invoice_year = put(invoice_date,DTyear4.); 
  invoice_datepart = datepart(invoice_date);
  
  * drop negative DeliveredQTY obs;
  if id = 1197056 then delete;
  
  * keep only years I have holidays for;
  if invoice_year in ("2012","2013","2014");
run;

* descriptives, check for outliers;
proc univariate data = data1;
  id id;
  var DeliveredQTY;
  histogram DeliveredQTY;
run;

* summarize data by day so I can plot it;
proc means data = data1 noprint nway;
  var DeliveredQTY;
  class invoice_year invoice_datepart;
  output out=data2 sum(DeliveredQTY)=day_delivery;
  
run;

* apply holidays as visual indicator on plot for one year;
* some religious holidays may overlap with others so I will try one at a time;
%macro loadReligion(religion);
data holiday2;
  set holiday1;
  
  where religion = "&religion. Holidays";
run;

proc sort data = data2; by invoice_datepart; run;
proc sort data = holiday1; by start_date; run;

data data&religion.;
  merge data2    (in=inData)
  		holiday2 (in=inHoli rename=(start_date=invoice_datepart) drop=day month year);
  by invoice_datepart;
    
  if religion ne " " then is_holiday=1;
  else is_holiday=0;
  
  if is_holiday=1 and day_delivery = . then day_delivery=0;
run;

proc sort data = data&religion.; by is_holiday; run;
title "Amounts delivered by day, &religion. Holidays marked";
proc sgplot data=data&religion.;
  styleattrs 
    datacontrastcolors=(grey orange)
    datasymbols=(CircleFilled);
  scatter x=invoice_datepart y=day_delivery /group=is_holiday;
    
  format invoice_datepart month.;
run;
%mend;

* plot for each religion;
%loadReligion(Buddhist);
%loadReligion(Christian);
%loadReligion(Hindu);
%loadReligion(Jewish);
%loadReligion(Muslim);
%loadReligion(Sikh);

* compare mean daily delivery of holiday, non holiday;
data junk;
  set dataChristian;
  
  if is_holiday and day_delivery=0 then delete;
run;

proc means data = junk;
  var day_delivery;
  class is_holiday;
run;

proc univariate data = junk mu0= 1028;
  by is_holiday;
  var day_delivery;
  histogram day_delivery;
run;


* some links;

* holidays are taken from Huff Post website;
* 2012 http://www.huffingtonpost.com/2012/01/01/religious-holidays-2012_n_1171749.html;
* 2013 http://www.huffingtonpost.com/2013/01/01/religious-holidays-2013_n_2372650.html;
* 2014 http://www.huffingtonpost.com/2014/01/01/religious-holidays-2014_n_4512541.html;

* demographics of relgion in Ottawa http://www12.statcan.gc.ca/nhs-enm/2011/dp-pd/prof/details/page.cfm?Lang=E&Geo1=CSD&Code1=3506008&Data=Count&SearchText=ottawa&SearchType=Begins&SearchPR=01&A1=All&B1=All&Custom=&TABID=1;



/* ********************************** */

* Does Holiday Season / December have more deliveries?
* extract date part of datetime value;
data data1;
  set d4g.ofbdata;
  invoice_date2 = datepart(invoice_date);  
  invoice_month = put(invoice_date2, mmyy.);
run;

* summarize data by month;
proc means data = data1 sum nway;
  var DeliveredQTY;
  class invoice_month;
  output out=data2 sum(DeliveredQTY)=cases_for_month; 
run;

* test monthly data for normality (roughly normal, kurtosis -0.4);
proc univariate data=data2;
  var cases_for_month;
  histogram cases_for_month / normal(mu=est sigma=est);
run;

* see if December increase is statistically significant;
data data3;
  set data2;
  month = substr(invoice_month,1,3);
  
  * add holiday dummy;
  if month eq "12M" then holiday = 1;
  else holiday = 0;
run;
  
title 'Analysis of Holiday (December) Deliveries';
ods select all;
proc univariate data = data3 mu0=20480.61;
  var cases_for_month;
  class holiday;
  
  histogram cases_for_month / nrows=2;
run;
