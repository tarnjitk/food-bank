/* PURPOSE: summarizes data by month to analyze purchasing trends */

* format prep;
proc format;
  value $category
  
  "A"="Purchased / Donated"	
  "B"="Baby Cupboard"	
  "C"="Donated"	
  "D"="School Program"	
  "E"="City Harvest"	
  "F"="Fresh Harvest"
  "G"="Christmas Cheer"	  
;
run;

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
  		(year(invoice_datepart) ge 2013 or
  		(year(invoice_datepart) eq 2012 and month(invoice_datepart) ge 6));			     
run;


* summarize, first by group;
proc means data = OFB_data_2 noprint nway;
  var DeliveredQTY Q_Purchased;
  class invoice_datepart Category group;
  output out=OFB_data_by_group sum(DeliveredQTY Q_Purchased)=delivered_cases purchased_cases;
  
  format invoice_datepart monyy7.;
run;
data OFB_data_by_group;
  set OFB_data_by_group;
  invoice_year = year(invoice_datepart); 
  invoice_month = month(invoice_datepart); 
run;


ods graphics / attrpriority=none;
title "Total purchased cases for Purchased/Donated (guaranteed inventory) category";
proc sgpanel data=OFB_data_by_group;
  panelby group;
  scatter x=invoice_month y=purchased_cases /
      group=invoice_year
  	  markerattrs=(size=15);
   
  styleattrs 
    datacontrastcolors=(grey orange lightblue)
    datasymbols=(CircleFilled);

  keylegend / position=top;
 
  format category $category.;
run;

* then by food;
proc means data = OFB_data_2 noprint nway;
  var DeliveredQTY Q_Purchased;
  class invoice_datepart Category group food;
  output out=OFB_data_by_food sum(DeliveredQTY Q_Purchased)=delivered_cases purchased_cases;
  
  format invoice_datepart monyy7.;
run;
data OFB_data_by_food;
  set OFB_data_by_food;
  invoice_year = year(invoice_datepart); 
  invoice_month = month(invoice_datepart); 
run;

ods graphics / attrpriority=none;
title "Total purchased cases for Purchased/Donated (guaranteed inventory) category";
proc sgpanel data=OFB_data_by_food;
  panelby food;
  scatter x=invoice_month y=purchased_cases /
      group=invoice_year
  	  markerattrs=(size=15);
   
  styleattrs 
    datacontrastcolors=(grey orange lightblue)
    datasymbols=(CircleFilled);

  keylegend / position=top;
  inset group;
  format category $category.;
run;


