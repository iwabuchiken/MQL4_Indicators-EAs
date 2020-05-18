//+------------------------------------------------------------------+
//| C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Include\libfx\
//    libfx_dp_1.mqh
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//extern string dpath_Log;

//+------------------------------------------------------------------+
//|                                              |
//+------------------------------------------------------------------+


/*---------------------
   vars
---------------------*/


/*---------------------

   bool judge_1()
   
   at : 2019/12/19 12:53:46

---------------------*/
bool dp_Trend_Down_1() {
//_20191219_130232:caller
//_20191219_130237:head
//_20191219_130242:wl

   /*******************
      step : 1
         prep : vars
   *******************/

   /*******************
      step : 2
         detect
   *******************/
   //_20191219_130738:next
   /*******************
      step : 2 : 1
         get : prev 4 bars
   *******************/
   // price : close
   //ref https://docs.mql4.com/predefined/close
   //double   close_M0 = Close[0];
   double   close_M1 = Close[1];
   double   close_M2 = Close[2];
   double   close_M3 = Close[3];
   double   close_M4 = Close[4];
   
   // price : open
   double   open_M1 = Open[1];
   double   open_M2 = Open[2];
   double   open_M3 = Open[3];
   double   open_M4 = Open[4];
   
   // price : diff
   //double   diff_M0 = close_M0 - open_M0;
   double   diff_M1 = close_M1 - open_M1;
   double   diff_M2 = close_M2 - open_M2;
   double   diff_M3 = close_M3 - open_M3;
   double   diff_M4 = close_M4 - open_M4;

   // price : lower
   //double   lower_M0 = 0.0;
   double   lower_M1 = 0.0;
   double   lower_M2 = 0.0;
   double   lower_M3 = 0.0;
   double   lower_M4 = 0.0;
   
   // price : lower ==> set
   //if(diff_M0 < 0) lower_M0 = close_M0; // down bar
   //else lower_M0 = open_M0;   // up bar
   
   if(diff_M1 < 0) lower_M1 = close_M1; // down bar
   else lower_M1 = open_M1;   // up bar

   if(diff_M2 < 0) lower_M2 = close_M2; // down bar
   else lower_M2 = open_M2;   // up bar

   if(diff_M3 < 0) lower_M3 = close_M3; // down bar
   else lower_M3 = open_M3;   // up bar

   if(diff_M4 < 0) lower_M4 = close_M4; // down bar
   else lower_M4 = open_M4;   // up bar

   //debug
   txt = "(step : 2 : 1) get : prev 4 bars";
   txt += "\n";
   
//   txt += "lower_M0 = "
//         + (string) NormalizeDouble(lower_M0, 3)
//         + " / "
     txt += "lower_M1 = "
         + (string) NormalizeDouble(lower_M1, 3)
         + " / "
         + "lower_M2 = "
         + (string) NormalizeDouble(lower_M2, 3)
         + " / "
         + "lower_M3 = "
         + (string) NormalizeDouble(lower_M3, 3)
         + " / "
         + "lower_M4 = "
         + (string) NormalizeDouble(lower_M4, 3)
         ;
   txt += "\n";   

   write_Log(dpath_Log, fname_Log_For_Session
         , __FILE__, __LINE__, txt);

   /*******************
      step : 2 : 2
         judge
   *******************/
   //_20191223_173007:next

   /*******************
      step : X
         return
   *******************/
   return true;

}//bool dp_Trend_Down_1() {

/*---------------------
   bool dp_2__All_True()
   
   at : 2020/04/10 16:00:50
---------------------*/
bool dp_2__All_True() {

   /*******************
      step : 0
         vars
   *******************/

   /*******************
      step : X
         return
   *******************/
   return true;


}//bool dp_2__All_True() {

/*---------------------
   bool dp_5_1_PrevBar_BB_egt_2()
   
   at : 2020/05/15 12:16:19
---------------------*/
bool dp_5_1_PrevBar_BB_egt_2(
         string _dpath_Log
         , string _fname_Log_For_Session
         ) {
//_20200515_123854:caller
//_20200515_123857:head
//_20200515_123900:wl

   /*******************
      step : 0
         prep : vars
   *******************/
   bool valOf_Ret = false;

   /*******************
      step : 0.1
         log
   *******************/
   string txt_Tmp = "dp_5_1_PrevBar_BB_egt_2 => starting...";
   
   write_Log(_dpath_Log , _fname_Log_For_Session
               , __FILE__ , __LINE__ , txt_Tmp);

   /*******************
      step : 1
         judge
   *******************/
   //_20200515_124341:tmp
   /*******************
      step : 1 : 1
         get : prev bar : closing price
   *******************/
   int index = 1;
   
   double priceOf_Close_Prev_Bar = Close[index];

   /*******************
      step : 1 : 2
         price : BB 2S
   *******************/
   int deviation = 1; int   period_BB = 20;
   int bb_Mode = MODE_UPPER; int price_Applied = PRICE_CLOSE;
   
   double BB_Price_1S = (float) iBands(Symbol(), Period(), period_BB
               , deviation    //deviation ref https:docs.mql4.com/constants/indicatorconstants/lines
               , 0, price_Applied, bb_Mode    //mode
               , index);   

   /*******************
      step : 1 : 3
         conditions
   *******************/
   bool cond_1 = (priceOf_Close_Prev_Bar >= BB_Price_1S);
   
   /*******************
      step : 1 : 4
         execute
   *******************/
   if(cond_1 == true)//(priceOf_Close_Prev_Bar >= BB_Price_1S)
     {
         /*******************
            step : 1 : 4 : Y
               true
         *******************/
         /*******************
            step : 1 : 4 : Y : 1
               log
         *******************/
         txt_Tmp = "dp_5_1_PrevBar_BB_egt_2 : (step : 1 : 4 : Y : 1)";
                  
                  //+ StringFormat(
         txt_Tmp += StringFormat(
                  
                        "index = %d / close = %.03f / BB_Price_1S = %.03f"
                        , index, priceOf_Close_Prev_Bar, BB_Price_1S
                     )
                  ;
         
         write_Log(_dpath_Log , _fname_Log_For_Session
                     , __FILE__ , __LINE__ , txt_Tmp);
                     
         /*******************
            step : 1 : 4 : Y : 2
               set : val
         *******************/
         // set
         valOf_Ret = true;
         
         txt_Tmp = "dp_5_1_PrevBar_BB_egt_2 : (step : 1 : 4 : Y : 2)";
         
         txt_Tmp += StringFormat(
                  
                        "\nsetting val : valOf_Ret => %s"
                        , valOf_Ret
                     )
                  ;
         
         write_Log(_dpath_Log , _fname_Log_For_Session
                     , __FILE__ , __LINE__ , txt_Tmp);
         
      
     }
   else//if(cond_1 == true)//(priceOf_Close_Prev_Bar >= BB_Price_1S)
     {
         /*******************
            step : 1 : 4 : N
               true
         *******************/
         /*******************
            step : 1 : 4 : N : 1
               log
         *******************/
         txt_Tmp = "dp_5_1_PrevBar_BB_egt_2 : (step : 1 : 4 : N : 1)";
         
         write_Log(_dpath_Log , _fname_Log_For_Session
                     , __FILE__ , __LINE__ , txt_Tmp);
                              
      
     }//if(cond_1 == true)//(priceOf_Close_Prev_Bar >= BB_Price_1S)
   
   /*******************
      step : X
         return
   *******************/
   return valOf_Ret;

}//bool dp_5_1_PrevBar_BB_egt_2(


/*---------------------
   bool dp_2__All_True()
   
   at : 2020/05/15 12:16:19
---------------------*/
bool dp_Dispatch(
         int idOf_DP
         , string _dpath_Log
         , string _fname_Log_For_Session
         ) {
//_20200515_121626:caller
//_20200515_121631:head
//_20200515_121634:wl

   /*******************
      step : 0
         prep : vars
   *******************/
   bool valOf_Ret = false;

   // id of DPs
   int   id_dp_5_1 = 1; // dp_5.1

   /*******************
      step : X
         dispatch
   *******************/
   if(idOf_DP == id_dp_5_1)
     {
         /*******************
            step : X : 1
               dp : 5.1
         *******************/
         /*******************
            step : X : 1.1
               log
         *******************/
         string txt_Tmp = "id_dp_5_1 => " + (string) id_dp_5_1;
         
         write_Log(_dpath_Log , _fname_Log_For_Session
                     , __FILE__ , __LINE__ , txt_Tmp);


         /*******************
            step : X : 1.2
               detect pattern
         *******************/
         //_20200515_123508:tmp
         //_20200515_123854:caller
         valOf_Ret = dp_5_1_PrevBar_BB_egt_2(_dpath_Log, _fname_Log_For_Session);
         
         /*******************
            step : X : 1.X
               set : return val
         *******************/
         //valOf_Ret = true;
         
     }
   else
     {
         /*******************
            step : X : X
               dp : unknown
         *******************/
         /*******************
            step : X : 1.1
               log
         *******************/
         string txt_Tmp = "id_dp_5_1 => " + "unknown";
         
         write_Log(_dpath_Log , _fname_Log_For_Session
                     , __FILE__ , __LINE__ , txt_Tmp);

         /*******************
            step : X : 1.2
               set : return val
         *******************/
         valOf_Ret = false;
      
     }


   /*******************
      step : X
         return
   *******************/
   return valOf_Ret;
   
   

}//bool dp_Dispatch(int idOf_DP) {

/*
2020/05/15 12:12:55
func-list.(libfx_dp_1.mqh).20200515_121255.txt
==========================================
<funcs>

1	bool dp_2__All_True() {
2	bool dp_Trend_Down_1() {

==========================================
==========================================
<vars>


==========================================
==========================================
<externs, inputs>


==========================================
*/
