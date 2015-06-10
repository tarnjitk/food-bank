* imports agency file;
proc import datafile='/folders/myfolders/D4G/Agency List with Lat and Lon v6.txt'
     out=d4g.agency_v6
     dbms=dlm
     replace;
     delimiter='09'x;
     datarow=2;
     getnames=YES;
     guessingrows=MAX;
run;




