//+------------------------------------------------------------------+
//| C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Include\libfx\
//    libfx_dp_1.mqh
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//extern string dpath_Log;

//+------------------------------------------------------------------+
//|  : original                                             |
//+------------------------------------------------------------------+
#include <utils.mqh>

/*---------------------
   vars
---------------------*/


//+------------------------------------------------------------------+
//|  : funcs
//+------------------------------------------------------------------+
/*
   is_Order_Pending()

*/
//func
bool  is_Order_Pending(bool _flg_OrderOpened) {
   
   //debug
   Print("[", __FILE__, ":",__LINE__,"] _flg_OrderOpened => ", _flg_OrderOpened);
   
   //_20200403_160446:next
   
   /*************************
      return
   *************************/
   /*************************
      1. set : val
   *************************/
   //test
   bool valOf_Ret = false;
   
   /*************************
      2. return
   *************************/
   return valOf_Ret;
   
}//is_Order_Pending()
