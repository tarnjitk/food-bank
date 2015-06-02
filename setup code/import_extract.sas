 data d4g.OFBDATA    ;
 %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
 infile '/folders/myfolders/D4G/OFBData.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
    informat Category $1. ;
    informat CategoryLabel $19. ;
    informat Food $28. ;
    informat Group $10. ;
    informat OrderType $7. ;
    informat CLASS $3. ;
    informat Class_Description $15. ;
    informat prodtype $1. ;
    informat Customer_Code $5. ;
    informat CustomerClass $15. ;
    informat DeliveredQTY best32. ;
    informat Q_Ordered best32. ;
    informat Q_Donated best32. ;
    informat Q_Purchased best32. ;
    informat AMT best32. ;
    informat DeliveredValuePerLB best32. ;
    informat DeliveredValue best32. ;
    informat Invoice_Date YMDDTTM20. ;
    informat id best32. ;
    format Category $1. ;
    format CategoryLabel $19. ;
    format Food $28. ;
    format Group $10. ;
    format OrderType $7. ;
    format CLASS $3. ;
    format Class_Description $15. ;
    format prodtype $1. ;
    format Customer_Code $5. ;
    format CustomerClass $15. ;
    format DeliveredQTY best12. ;
    format Q_Ordered best12. ;
    format Q_Donated best12. ;
    format Q_Purchased best12. ;
    format AMT best12. ;
    format DeliveredValuePerLB best12. ;
    format DeliveredValue best12. ;
    *format Invoice_Date ;
    format id best12. ;
 input
             Category $
             CategoryLabel $
             Food $
             Group $
             OrderType $
             CLASS $
             Class_Description $
             prodtype $
             Customer_Code $
             CustomerClass $
             DeliveredQTY
             Q_Ordered
             Q_Donated
             Q_Purchased
             AMT
             DeliveredValuePerLB
             DeliveredValue
             Invoice_Date $
             id
 ;

 * a little cleanup;
  if Category = "G" then CategoryLabel = "Christmas Cheer";
  if CustomerClass = "Commun ty Food" then CustomerClass = "Community Food";

 if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
  
 run;
