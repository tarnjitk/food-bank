* Time Regression Analysis;

* summarize by month;
proc means data = d4g.ofbdata sum nway;
  var DeliveredQTY;
  class invoice_date;
  
  format invoice_date DTmonyy7.;
  output out=data1 sum(DeliveredQTY)=cases_delivered;
run;

data data2;
  set data1;
  month_since_jan05 = _n_;
  
  drop _freq_ _type_;
run;

ods graphics on;
proc reg;
  model cases_delivered = month_since_jan05;
run;
ods graphics off;






