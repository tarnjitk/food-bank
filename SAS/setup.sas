/* PURPOSE: This program loads the OFB data as downloaded from D4G */
/* and does basic setup for later analysis on it.				   */
 
libname d4g "/folders/myfolders/D4G/food-bank/data";

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