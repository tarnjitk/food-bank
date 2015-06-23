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

%macro setup_agency_program_2;
proc freq data = data1 noprint; 
  tables invoice_year*customer_code /out=agency_by_year;
run;
data agency_program_1 (keep=CustomerCode program ProgramAudience ProgramNeed);
  set d4g.agency_v6;
run;

proc sort data = agency_program_1; by customerCode; run;
proc sort data = agency_by_year; by customer_Code; run;

data agency_program_2 (keep=invoice_year Customer_Code program ProgramAudience ProgramNeed)
	 agency_noMatch ofb_noMatch;
  merge agency_by_year	  (in=inOFB)
  	  	agency_program_1  (in=inAcy rename=(customerCode=customer_code));
  by customer_code;
  
  if inOFB and inAcy then output agency_program_2;
  else if inAcy then output agency_noMatch;
  else if inOFB then output ofb_noMatch;
run;
%mend;
