* compare mean cases delivered by month;
libname d4g '/folders/myfolders/D4G/food-bank/data';

* macro prep;
%macro filter_purchased_only(category);
  where category in ("&category") and
  		(year(invoice_datepart) ge 2013 or
  		(year(invoice_datepart) eq 2012 and month(invoice_datepart) ge 6));			     
%mend;
%macro filter_purchased_exclude_harvest;
  where category not in ("E,F") and
  		(year(invoice_datepart) ge 2013 or
  		(year(invoice_datepart) eq 2012 and month(invoice_datepart) ge 6));			     
%mend;



* data prep (this is the food bank dataset);
data data1;
  set d4g.ofbdata;
  *invoice_year = put(invoice_date,DTyear4.); 
  invoice_datepart = datepart(invoice_date);
  invoice_year = year(invoice_datepart); 
  invoice_month = month(invoice_datepart); 
  
  * drop negative DeliveredQTY obs;
  if id = 1197056 then delete;
  
  * keep only years I have holidays for;
  *if invoice_year in ("2012","2013","2014");
run;


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