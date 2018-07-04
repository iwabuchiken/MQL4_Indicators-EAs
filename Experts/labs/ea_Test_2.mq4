//+------------------------------------------------------------------+
//|                                               Moving Average.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link        "http://www.mql4.com"
#property description "Moving Average sample expert advisor"

#define MAGICMA  20131111
//--- Inputs
input double Lots          =0.1;
input double MaximumRisk   =0.02;
input double DecreaseFactor=3;
input int    MovingPeriod  =12;
input int    MovingShift   =6;

int init() {

      //debug
      Alert("[", __FILE__, ":",__LINE__,"] init... ea_Test_2.mq4");
      
      //debug
      Alert("[", __FILE__, ":",__LINE__,"] Symbol() => '", Symbol(), "'");

      //debug
      Alert("[", __FILE__, ":",__LINE__,"] Period() => '", Period(), "'");

      // return
      return 0;


}//int init()

//+------------------------------------------------------------------+
//| __test_4_1_3__Higher_Than_Prev
//+------------------------------------------------------------------+
void __test_4_1_4__BUSL() {

   if(IsTradeAllowed() == false)
     {
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] IsTradeAllowed ==> false");
     }
   else
     {
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] IsTradeAllowed ==> true");

     }
   
   //debug
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] OrderMagicNumber ==> ", OrderMagicNumber());
   
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] OrdersTotal ==> ", OrdersTotal());
   
   
   
   // compare
   bool cmp = High[0] > High[1];

   
}//__test_4_1_4__BUSL()

//+------------------------------------------------------------------+
//| OnTick function                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
      
      __test_4_1_4__BUSL();
   //debug
   //Alert("[", __FILE__, ":",__LINE__,"] High[0] => ", High[0]);
  
  }
//+------------------------------------------------------------------+

