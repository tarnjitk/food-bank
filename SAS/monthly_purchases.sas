/* PURPOSE: summarizes data by month to analyze purchasing trends */
/* run setup.sas first */

*libname d4g "/folders/myfolders/D4G/food-bank/data";

* data prep (this is the food bank dataset);
data OFB_data_1;
  set d4g.ofbdata;
  invoice_datepart = datepart(invoice_date);
  * drop negative DeliveredQTY obs;
  if id = 1197056 then delete;
run;

* limits data to when purchases began;
data OFB_data_2;
  set OFB_data_1;
  where /*month_delivery ne 0 and*/
		category in ("A") and
  		year(invoice_datepart) ge 2013;
  		* year(invoice_datepart) eq 2012 and month(invoice_datepart) ge 6;			     
run;

/* ************************* */
* summarize by month;
proc means data = OFB_data_2 noprint nway;
  var DeliveredQTY Q_Purchased;
  class invoice_datepart Category;
  output out=OFB_data_by_month sum(DeliveredQTY Q_Purchased)=delivered_cases purchased_cases;
  
  format invoice_datepart monyy7.;
run;
data OFB_data_by_month;
  set OFB_data_by_month;
  invoice_year = year(invoice_datepart); 
  invoice_month = month(invoice_datepart); 
    
run;


ods graphics / attrpriority=none;
title "Total purchased cases in guaranteed inventory";
proc sgplot data=OFB_data_by_month;
  scatter x=invoice_datepart y=purchased_cases /
      group=invoice_year
  	  markerattrs=(size=15);
   
  styleattrs 
    datacontrastcolors=(orange lightblue gray)
    datasymbols=(CircleFilled);
  xaxis type=discrete;
  yaxis min=0;
  
  keylegend / position=top;
 
  format category $category.
  		 invoice_datepart monname3.;
run;


/* ************************* */
* summarize by group;
proc means data = OFB_data_2 noprint nway;
  var DeliveredQTY Q_Purchased;
  class invoice_datepart Category group;
  output out=OFB_data_by_group sum(DeliveredQTY Q_Purchased)=delivered_cases purchased_cases;
  
  format invoice_datepart monyy7.;
run;
data OFB_data_by_group;
  set OFB_data_by_group;
  invoice_year = year(invoice_datepart); 
run;


ods graphics / attrpriority=none;
title "Total purchased cases in guaranteed inventory, by group";
proc sgpanel data=OFB_data_by_group;
  panelby group;
  scatter x=invoice_datepart y=purchased_cases /
      group=invoice_year
  	  markerattrs=(size=15);
   
  styleattrs 
    datacontrastcolors=(orange lightblue gray)
    datasymbols=(CircleFilled);

  colaxis type=discrete;

  keylegend / position=top;
 
  format category $category.
  		 invoice_datepart monname3.;
run;


/* ************************* */
* then by food (in can group);
proc means data = OFB_data_2 noprint nway;
  var DeliveredQTY Q_Purchased;
  class invoice_datepart Category group food;
  output out=OFB_data_by_food sum(DeliveredQTY Q_Purchased)=delivered_cases purchased_cases;
  
  format invoice_datepart monyy7.;
run;
data OFB_data_by_food;
  set OFB_data_by_food;
  invoice_year = year(invoice_datepart); 
run;


ods graphics / attrpriority=none;
title "Total purchased cases in guaranteed inventory, by food item in group = can";
proc sgpanel data=OFB_data_by_food;
  where group = "Can";
  panelby food;
  scatter x=invoice_datepart y=purchased_cases /
      group=invoice_year
  	  markerattrs=(size=15);
   
  styleattrs 
    datacontrastcolors=(orange lightblue gray)
    datasymbols=(CircleFilled);
    
  colaxis type=discrete;

  
  keylegend / position=top;
  inset group;
  format category $category.
  		 invoice_datepart monname3.;
run;


