libname d4g '/folders/myfolders/D4G/';

proc contents data=data1 order=varnum; run;
* look at a small sample of the data;
proc print data=data1 (obs=10);
    format Invoice_date DTyear4.;
run;

* for those steps needing invoice_year, this adds it;
data data1;
  set d4g.ofbdata;
  invoice_year = put(invoice_date,DTyear4.); 
run;

/* ************************************** */
* basic descriptives of character vars;
/* ************************************** */

* the data has several categories;
* they identify different foods, customers, and programs the foods are used for;
proc freq data=data1;
    tables _character_;
run;

* what food items belong in a group?;
proc freq data=data1;
    tables group*food / list;
run;
* what customers belong in a class?;
proc freq data=data1;
    tables CustomerClass*Customer_Code / list;
run;
*Does CustomerClass get assigned to a food or to a Customer (as I would expect)?;
proc freq data = data1;
  tables customer_code * customerclass /list;
run;
*** how would I summarize number of unique customers per class?;

/* ************************************** */
* basic descriptives of numeric vars;
/* ************************************** */

* the data has timestamps, measures of cases ordered/delivered and some cryptic valuations;
proc univariate data=data1;
    var _numeric_;
run;

* how many cases of each food group ordered or purchased by year?;
proc sort data = data1; by group Invoice_year; run;
data data2;
  set data1;
  by group invoice_year;

  retain orderedCases 
  		 purchasedCases
  		 deliveredCases;
  
  if last.invoice_year then do;
    output;
    orderedCases = 0;
    purchasedCases = 0;
    deliveredCases = 0;
  end;
  
  orderedCases + Q_Ordered;
  purchasedCases + Q_Purchased;
  deliveredCases + DeliveredQTY;
  
run;
  
title "Number of cases ordered overall by year";
proc means data = data1 sum;
  class invoice_year category categoryLabel;
  var Q_Ordered Q_Purchased Q_Donated DeliveredQTY;
run;
title;
   
title "Cases of each food group *ordered* by year";
proc sgplot data = data2;
  vbar Invoice_year /response= orderedCases
  					 group = group
  					 groupdisplay=stack;
run;
title;

title "Cases of each food group *purchased* by year";
proc sgplot data = data2;
  vbar Invoice_year /response= purchasedCases
  					 group = group
  					 groupdisplay=stack;
run;
title;

title "Cases of each food group *delivered* by year";
proc sgplot data = data2;
  vbar Invoice_year /response= deliveredCases
  					 group = group
  					 groupdisplay=stack;
run;
title;

/* ************************************** */
* tracing one agency transactions with Ottawa Food Bank;
/* ************************************** */

* intro to new dataset - what is contained in the agency file?;
proc freq data = d4g.agency1; tables Program; run;
proc print data = d4g.agency1; 
  where Program eq "Food Cupboard"; 
run;

* taking one member labelled Food Cupboard and one Community Food Bank;
* how much food was deliverd to them last year?;
data detail1;
  set data1;
  
  ord_date = datepart(invoice_date);
  where customer_code in ("A0037","A0031") and invoice_year = "2014";
run;

proc sgplot data = detail1;
  vbar ord_date /response= DeliveredQTY
  				 group = customer_code
  				 groupdisplay=cluster;
  format ord_date monyy.; 
run;

* how much of that food belonged to each of the programs?;
* does an agency labelled Community Food Bank only receive certain order types?;
proc sort data = detail1; by customer_code; run;
proc sgplot data = detail1;
  by customer_code;
  vbar ord_date /response= DeliveredQTY
  				 group = categoryLabel;
    
  format ord_date monyy.; 
run;
*** could do this for all customer_codes summary;



/* ************************************** */
* merge in agency data to see if category of deliveries changes with program;
/* ************************************** */

proc sort data = data1; by customer_code; run;
proc sort data = d4g.agency1; by customercode; run;

data d4g.join1 noJoin;
  merge data1   (in=ind1)
  		d4g.agency1 (in=ina1 rename=(customerCode = customer_code));
  by customer_code;
  if ind1 and ina1 then output d4g.join1;
  else if ina1 then output noJoin;
run;
proc print data = nojoin; run;

* only certain programs receive harvest programs;
proc freq data = join1;
  tables program*categoryLabel;
run;

* confirm 199 agencies in dataset;
proc freq data = join1 nlevels;
  tables customer_code;
run;






/* ************************************** */
* ANALYSIS OF UNORDERED DELIVERY;
/* ************************************** */

* how much did each category deliver?;
title "All categories have a delivered value...";
proc sgplot data = data1;
  vbar categoryLabel /response = DeliveredQTY;
run;



* how much did each category get ordered?;
proc sgplot data = data1;
  vbar categoryLabel /response = Q_Ordered
  					  missing;
run;
title;




* what goods get delivered that aren't ordered?;
data noOrder;
  set data1;
  if Q_Ordered eq 0 then zero_ordered = 1;
  else zero_ordered = 0;  
run;

proc contents data = data1;  run;

proc means data = noOrder sum;
  var DeliveredQTY;
  class food invoice_year;

  where food in ("Bakery","Cookies");
run;

* by program category;
proc means data = noOrder sum nway noprint;
  var DeliveredQTY;
  class categoryLabel zero_ordered;
  output out = noOrder_categories sum(DeliveredQTY)= sum_delivered;
run;
proc print; run;

ods graphics / reset imagefmt=jpeg;
ods listing gpath =  '/folders/myfolders/D4G/';
title "Some programs deliver without getting ordered.";
proc sgplot data = noOrder_categories;
  vbar categoryLabel / response = sum_delivered
  					   group = zero_ordered
  					   groupdisplay=cluster;			   
  format sum_delivered comma20.;  
run;
title;

* by food group;
proc means data = noOrder sum nway noprint;
  var DeliveredQTY;
  class group zero_ordered;
  output out = noOrder_groups sum(DeliveredQTY)= sum_delivered;
run;

proc sort data = noOrder_groups; by descending zero_ordered descending sum_delivered ; run;
proc sgplot data = noOrder_groups;
  vbar group / response = sum_delivered
  					   group = zero_ordered
  					   groupdisplay=cluster
  					   ;			   
  format sum_delivered comma20.;  
  
  xaxis discreteorder=data;
run;

* by food (removing those with missing zero_ordered);
* also setting threshold of 1000 cases;
proc means data = noOrder sum nway noprint;
  var DeliveredQTY;
  class food zero_ordered;
  output out = noOrder_food1 sum(DeliveredQTY)= sum_delivered;
run;

proc sort data = noOrder_food1; by food descending zero_ordered ; run;
data noOrder_food2;
  set noOrder_food1;
  
  by food;
  retain has_zero;
  if first.food then do;
    has_zero = zero_ordered;
  end;

  where sum_delivered ge 1000;
run;
data noOrder_food3;
  set noOrder_food2;
  
  where has_zero eq 1;
run;

proc sort data = noOrder_food3; by zero_ordered descending sum_delivered ; run;

ods graphics / reset imagefmt=jpeg;
ods listing gpath =  '/folders/myfolders/D4G/';

title "All 'Bakery' items are delivered without having been ordered";
proc sgplot data = noOrder_food3;
  vbar food / response = sum_delivered
  					   group = zero_ordered
  					   groupdisplay=cluster;			   
  format sum_delivered comma20.;  
   
  xaxis discreteorder=data;

run;
title ;




/* ************************************** */
* ANALYSIS OF UNMET DEMAND;
/* ************************************** */

proc contents data = data1; run;

* how many cases are in an order?;
proc sort data = data1; by categoryLabel; run;
ods select SSPlots;
proc univariate data = data1 plots ;
  by categoryLabel;

  var Q_Ordered;
  
  where invoice_year = "2014";
run;
proc freq data = data1;
  tables Q_Ordered;
  
  where invoice_year = "2014";

run;
* outlier?;
proc print data = data1 (firstobs= 686775 obs= 686775);run;
proc univariate data = data1 noprint;
  histogram Q_Ordered;
  class categoryLabel;
  
  where invoice_year = "2014";
run;


* calculate variance between ordered and delivered;
* flag those orders where nothing is delivered;
data var_delivery;
  set data1;
  variance_Delivered = DeliveredQTY - Q_Ordered;  
  
  if variance_Delivered eq Q_Ordered then zero_Del = 1;
  else zero_Del = 0;
  
  where invoice_year = "2014" and category in ("A","B","C","D");

run;

* how many orders were underfilled?;
proc univariate data=var_delivery;
    var variance_Delivered;
run;

proc sgplot data = var_delivery;
  histogram variance_Delivered;
run;

proc print data = data1 (firstobs= 26913 obs=26913);
  where invoice_year = "2014" and category in ("A","B","C","D");

run;
proc sort data = var_delivery; by variance_Delivered; run;
proc print data=var_delivery;
  where customer_code = "A0010";
run;

* how many orders go completely missed?;
proc freq data = var_delivery;
  tables zero_Del;
run;
* which agencies had missed orders?;
proc freq data = var_delivery noprint;
  tables CustomerClass*customer_code /out=agency_zero;
  where zero_Del = 1;
run;

title "Distribution of how many times an agency ordered but got no delivery in 2014";
proc sgplot data = agency_zero;
  by CustomerClass;
  histogram count /scale=count; 
run;
title;
* of those, are they made up in future deliveries?;



* matching up numbers with 2013-14 annual report;
proc contents data = data1; run;
proc freq data = data1; tables food; run;
proc freq data = data1; tables categoryLabel;  where invoice_year = "2014"; run;

proc means data = data1 sum;
  var DeliveredQTY;
  class food invoice_year;
  
  where group = "Baby";
run;


*** can i discern a delivery, or a collection of orders to the same agency same day;


/* ************************************** */
* more questions of unmet demand;
/* ************************************** */

proc contents data = data1; run;
proc freq data = d4g.join1; tables program; run;

proc means data = data1 sum nway noprint;
  var DeliveredQTY Q_Ordered;
  class food;
  
  output out = sum_all1 sum(DeliveredQTY Q_Ordered) = sum_DeliveredQTY sum_Q_Ordered;
  
  *where invoice_year = "2014" and program = "Community Food";
run;
data sum_all2;
  set sum_all1;
  
  pctMet = sum_DeliveredQTY/sum_Q_Ordered;
  if pctMet gt 1 then pctMet = 1;

run;
proc sort data = sum_all2 ; by pctMet; run;

proc sgplot data = sum_all2;
  vbar food /response=pctMet
  			 grouporder=data;
run;

proc means data = d4g.join1 sum noprint nway;
  var Q_Ordered DeliveredQTY;
  class customer_code group;
  
  output out = sum_unmet1 sum(Q_Ordered DeliveredQTY)= sum_Q_Ordered sum_DeliveredQTY;
  where invoice_year = "2014" and program = "Community Food";
run;
data sum_unmet2;
  set sum_unmet1;
  
  type = "sum_Q_Ordered";
  sum = sum_Q_Ordered;
  output;
  
  type = "sum_DeliveredQTY";
  sum = sum_DeliveredQTY;
  output;
  
  drop sum_Q_Ordered sum_DeliveredQTY;
run;

proc sgplot data = sum_unmet2;
  vbar customer_code / response = sum
  					   group = type
  					   groupdisplay=cluster;
run;

data order_pct;
  set data1;
  
  if Q_Ordered eq 0 then dlvr_pct = -1;
  else dlvr_pct = DeliveredQTY / Q_Ordered;
run;

* identify outliers;
proc freq data = order_pct;
  tables dlvr_pct;
run;
proc freq data = order_pct;
  tables invoice_year;
  where dlvr_pct gt 10;
run;
proc print data = order_pct;
  where dlvr_pct gt 50 and invoice_year eq "2014";
run;

* confirms there is a far higher fulfillment of orders in guaranteed category than donated;
ods select histogram;
proc sort data = order_pct; by categoryLabel invoice_year; run;
proc univariate data = order_pct;

  var dlvr_pct;
  class CategoryLabel;
  histogram dlvr_pct;
  
  where 0 le dlvr_pct le 1 and 
  		Category in ("A","C");
run;
ods select all;

data unmet;
  set data1;
  
  unmet_demand = Q_Ordered - DeliveredQTY;
  where Q_Ordered gt 0;
run;
proc means data = unmet sum;
  var unmet_demand Q_Ordered;
  class food;
  
  output out=unmet_stats sum()=
run;
