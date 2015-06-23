* sums up data by month;
* classes by category, group, and year;
%macro setup_sum_by_month;
proc means data = data1 noprint nway;
  var Q_Ordered DeliveredQTY Q_Purchased;
  class Category invoice_year invoice_month;
  output out=data2 sum(Q_Ordered DeliveredQTY Q_Purchased)=month_ordered month_delivery month_purchased;
  
run;
* removes no-delivery months (for later starting programs);
data data3;
  set data2;
  where month_delivery ne 0;
run;
%mend;


* ALT sums up data only for Purchased/Donated by month, using SAS datevalue; 
proc means data = data1 noprint nway;
  var DeliveredQTY Q_Purchased;
  class Category invoice_datepart;
  output out=data2_alt sum(DeliveredQTY Q_Purchased)=month_delivery month_purchased;
  
  format invoice_datepart monyy7.;
run;
* removes no-delivery months (for later starting programs);
data data3_alt;
  set data2_alt;
  where month_delivery ne 0;
  
  * this pct suitable for ONE PROGRAM ONLY;
  pct_purchased = month_purchased / month_delivery;
run;
proc print data = data3_alt (obs=10); run;
proc univariate data = data3_alt; 
  var pct_purchased; 
  %filter_purchased_only(A);  
run;


* ALT sums up data by month, using SAS datevalue; 
proc means data = data1 noprint nway;
  var DeliveredQTY Q_Purchased;
  class invoice_datepart;
  output out=data2_alt_all sum(DeliveredQTY Q_Purchased)=month_delivery month_purchased;
  
  format invoice_datepart monyy7.;
 
  %filter_purchased_exclude_harvest;  
run;
* removes no-delivery months (for later starting programs);
data data3_alt_all;
  set data2_alt_all;
  where month_delivery ne 0;
  
  pct_purchased = month_purchased / month_delivery;
run;
proc print data = data3_alt_all; run;
proc univariate data = data3_alt_all; var pct_purchased; run;



* merge program from agency data onto OFB data;


