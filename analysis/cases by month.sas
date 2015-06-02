* setup;
proc contents data = data1; run;
proc print data = data1 (obs=10); run;


* confirms which years are in data;
proc freq data = data1; tables invoice_year; run;

* finds first month of delivery and purchase for each category;
%setup_sum_by_month;
proc sort data = data3; by category invoice_year invoice_month; run;
data first_delivery;
  set data3;
  by category invoice_year;
  
  if last.category;
run;
proc print data = first_delivery; run;
data first_purchase;
  set data3;
  by category invoice_year;
  
  where month_purchased ne 0;
  if first.category;
run;
proc print data = first_purchase; run;


/* ANALYSIS */
* analyzes overall monthly case delivery;
%setup_sum_by_month;
proc sort data = data3; by category; run;
proc means data=data3 printalltypes maxdec=3
	N MEAN STD MIN MAX SKEW KURT;
  var month_delivery;
  class Category invoice_month;
  
  format category $category.;			   
run;
ods graphics on / width=700;
title "Box plots of monthly case delivery overall";
proc sgplot data=data3;
  vbox month_delivery / category=invoice_month;  			   
run;
title "Box plots of monthly case delivery, by program";
proc sgplot data=data3;
  by Category;
  vbox month_delivery / category=invoice_month;  
  
  format category $category.;			   
run;


* PURCHASES: analyzes overall monthly case purchases starting June 2012;
* focus on puchased / donated category (A);
%setup_sum_by_month;
%macro filter_purchased_for_A;
  where category in ("A") and
  		(year(invoice_datepart) ge 2013 or
  		(year(invoice_datepart) eq 2012 and month(invoice_datepart) ge 6));			     
%mend;

proc means data=data3_alt printalltypes maxdec=3
	MEAN STD MIN MAX SKEW KURT q3;
  var month_purchased;
  class category invoice_datepart;
  
  format category $category.
  		 invoice_datepart month.;  
  %filter_purchased_for_A;
run;

ods graphics on / width=700;
title "Box plots of monthly case purchases";
proc sgplot data=data3;
  vbox month_purchased / category=invoice_month;
  
  %filter_purchased_for_A;
run;
proc sort data = data3; by category; run;


data data3_alt_1;
  set data3_alt;
  invoice_month=month(invoice_datepart);
  invoice_year=year(invoice_datepart);
run;

ods graphics on / width=1000;
title "Total purchased cases for Purchased/Donated (guaranteed inventory) category";
proc sgplot data=data3_alt_1;
  scatter x=invoice_month y=month_purchased /group=invoice_year;
  xaxis values=(1 to 12 by 1);
   
  styleattrs 
    datacontrastcolors=(grey orange lightblue)
    datasymbols=(CircleFilled);
 
  format category $category.;
  %filter_purchased_for_A;
run;
proc export data=data3_alt_1
   outfile= '/folders/myfolders/D4G/total_purchased_cases_by_month.txt'
   dbms=tab;
run;




/* finding 1: trend in purchases peaking sept, dec, and possibly april*/
proc sort data = data3; by category; run;
title "There is an upward trend in purchases over the year that restarts in January";
proc sgplot data=data3;
  by Category;
  vbox month_purchased / category=invoice_month
  						 datalabel=invoice_year;
  
  format category $category.;  		
  %filter_purchased_for_A;
run;

title "Does this correspond in any way to deliveries?";
proc sgplot data=data3;
  by Category;
  vbox month_delivery / category=invoice_month;  
  
  format category $category.;	
  %filter_purchased_for_A;
run;

*** better way to show would be a line chart showing purchase activity;
ods graphics on / width=1000;
title "Deliveries vs. Purchases for Donated/Purchased goods category";
proc sgplot data=data3_alt;
  xaxis type=discrete;
  vbar invoice_datepart / response=month_delivery ;
  vline invoice_datepart / response=pct_purchased y2axis
  						   lineattrs=(thickness=3); 
  * Q3 refline is 0.49;
  refline 0.5 / axis=y2;
  %filter_purchased_only(A);  
run;
title;

ods graphics on / width=1000;
title "Deliveries vs. Purchases for all categories (except harvest)";
proc sgplot data=data3_alt_all;
  xaxis type=discrete;
  vbar invoice_datepart / response=month_delivery ;
  vline invoice_datepart / response=pct_purchased y2axis
  						   lineattrs=(thickness=3); 
  						   
  * Q3 refline is 0.28;
  refline 0.3 / axis=y2;
run;
title;




proc means data=data2 printalltypes;
  var month_purchased; 
  class invoice_month group;
  
  where Category="A";
run;


*** critical to remember for these plots that n = 3 for a month;
proc sort data = data2; by invoice_month; run;
proc sgplot data=data2;
  by invoice_month;
  vbox month_purchased / category=group;  
  
  where Category="A";
			   
run;
proc sort data = data2; by group; run;
proc sgplot data=data2;
  by group;
  vbox month_purchased / category=invoice_month;  
  
  where Category="A";
			   
run;



