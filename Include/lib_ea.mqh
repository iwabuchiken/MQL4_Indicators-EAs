//+------------------------------------------------------------------+
//|                                                       lib_ea.mqh |
//|                                                     iwabuchi ken |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "iwabuchi ken"
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                              |
//+------------------------------------------------------------------+
#include <stderror.mqh>
#include <stdlib.mqh>
#include <WinUser32.mqh>

//+------------------------------------------------------------------+
//|  : original                                             |
//+------------------------------------------------------------------+
#include <utils.mqh>

//+------------------------------------------------------------------+
//|  funcs
//+------------------------------------------------------------------+
bool detect_DownDown_Buy() {
   
   /****************
      vars
   ****************/
   int   period_BB = 20;
   
   
   /****************
      get : the latest bar
   ****************/
   int index = 1;
   
   double price_Close_Latest = (double) Close[index];
   double price_Open_Latest = (double) Open[index];
   
   /****************
      the latest bar : down ?
   ****************/
   double diff_Latest = price_Close_Latest - price_Open_Latest;
   
   string d = TimeToStr(iTime(Symbol(),Period(), index));
   
   if(diff_Latest >= 0)
     {
      
         string txt = "\ndiff_Latest >= 0 ("
                      + (string) diff_Latest
                      + ") ("
                      + d
                      + ")"
                     ;
                      
         write_Log(
               dpath_Log
               //, fname_Log
               , fname_Log_For_Session
               , __FILE__
               , __LINE__
               , txt);
         
         // return
         return false;
      
     }//if(diff_Latest >= 0)

   /****************
      the latest bar : below BB.-1 ?
   ****************/
   index = 1;
   
   double ibands_1S_Plus = iBands(
               Symbol()
               , Period()
               , period_BB
               , 1.0
               , 0
               , PRICE_CLOSE
               , MODE_LOWER
               , index);
   
   // compare
   if(price_Close_Latest >= ibands_1S_Plus)
     {

         string txt = "\nprice_Close_Latest >= ibands_1S_Plus"
                      + " (close = "
                      + (string) price_Close_Latest
                      + ")"
                      + " (BB.-1 = "
                      + (string) ibands_1S_Plus
                      + ") ("
                      + d
                      + ")"
                     ;
                      
         write_Log(
               dpath_Log, fname_Log_For_Session
               , __FILE__, __LINE__
               , txt);
         
         // return
         return false;
      
     }//if(price_Close_Latest >= ibands_1S_Plus)

   /****************
      the one before the latest : down ?
   ****************/
   double price_Close_SecondLatest = (double) Close[index + 1];
   double price_Open_SecondLatest = (double) Open[index + 1];

   d = TimeToStr(iTime(Symbol(),Period(), index + 1));
   
   /****************
      the latest bar : down ?
   ****************/
   double diff_SecondLatest = price_Close_SecondLatest - price_Open_SecondLatest;

   // compare
   if(diff_SecondLatest >= 0)
     {

         string txt = "\ndiff_SecondLatest >= 0"
                      + " (diff = "
                      + (string) diff_SecondLatest
                      + ")"
                      + "("
                      + d
                      + ")"
                     ;
                      
         write_Log(
               dpath_Log, fname_Log_For_Session
               , __FILE__, __LINE__
               , txt);
         
         // return
         return false;
         
      }//if(diff_SecondLatest >= 0)
   
   /****************
      return
   ****************/
   return true;
      
}//detect_DownDown_Buy()