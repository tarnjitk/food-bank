

* count orders per yer;
proc freq data = data1 noprint;
  tables invoice_year /out=count_orders_1;
run;
title "orders per year, all programs";
proc sgplot data=count_orders_1;
  series x= invoice_year y=count;
  yaxis min=0;
run;
title;
proc export data=count_orders_1
   outfile= '/folders/myfolders/D4G/count_orders_per_year.txt'
   dbms=tab;
run;


/* POTENTIAL ALTERNATIVE TO COUNTING ORDERS */
* calculate delivered cases per year;
proc means data = data1 noprint nway;
  var DeliveredQTY;
  class invoice_year;
  output out=count_cases_delivered_1 sum=;
run;
title "cases per year, all programs";
proc sgplot data=count_cases_delivered_1;
  series x= invoice_year y=DeliveredQTY;
  yaxis min=0;
run;
title;
proc export data=count_cases_delivered_1
   outfile= '/folders/myfolders/D4G/count_cases_delivered_per_year.txt'
   dbms=tab;
run;


* calculate agencies assisted;
proc means data = data1 nway noprint;
  var DeliveredQTY;
  class invoice_year Customer_Code; 
  output out=count_agencies_1 sum(DeliveredQTY)=;
run;
proc freq data=count_agencies_1 noprint;
  tables invoice_year /out=count_agencies_2;
  run;
title "Active agencies per year, all programs";
proc sgplot data=count_agencies_2;
  series x=invoice_year y=count;
  yaxis min=0;
run;
title;
proc export data=count_cases_delivered_1
   outfile= '/folders/myfolders/D4G/count_active_agencies_per_year.txt'
   dbms=tab;
run;


* # of agencies by program;
%setup_agency_program_2;
proc freq data=agency_program_2 noprint;
  tables invoice_year*program/out=count_agencies_by_program_2;
run;
title "Active agencies per year, excluding Animal Shelter";
proc sgplot data=count_agencies_by_program_2;
  series x=invoice_year y=count /group=program lineattrs=(thickness=3);
  yaxis min=0;

  where program ne "Animal Shelter";
run;
title;
proc export data=count_agencies_by_program_2
   outfile= '/folders/myfolders/D4G/count_active_agencies_by_program_per_year.txt'
   dbms=tab;
run;




/* STILL DEVELOPING, NOT USED IN SLIDES YET */
* # of agencies by program need;
proc print data = agency_program_2; run;
proc freq data=agency_program_2 noprint;
  tables invoice_year*programNeed/out=count_agencies_need_2;
run;
title "Active agencies per year, excluding Animal Shelter";
proc sgplot data=count_agencies_need_2;
  series x=invoice_year y=count /group=programNeed lineattrs=(thickness=3);
  yaxis min=0;
run;
title;





