//--------------------------------------------------------------------
// test_d.p.-2.mq4
// 2016/11/23 15:11:49
// 
// <Usage>
// - 
// 
//--------------------------------------------------------------------
//+------------------------------------------------------------------+
//| Includes                                                                 |
//+------------------------------------------------------------------+
#include <utils.mqh>

//+------------------------------------------------------------------+
//| vars                                                                 |
//+------------------------------------------------------------------+
extern int Period_MA = 21;            // Calculated MA period

bool Fact_Up = true;                  // Fact of report that price..
bool Fact_Dn = true;                  //..is above or below MA

int HOURS_PER_DAY = 24;

int HIT_INDICES[];   // indices of matched bars

// counter
int NUMOF_HIT_INDICES = 0;

int FILE_HANDLE;

//+------------------------------------------------------------------+
//| infra vars                                                                 |
//+------------------------------------------------------------------+
string SUBFOLDER = "Research\\38_2";      // subfolder name

int NUMOF_BARS_PER_HOUR　= 1;        // default: 1 bar per hour

int NUMOF_TARGET_BARS = 0;

//+------------------------------------------------------------------+
//| input vars                                                                 |
//+------------------------------------------------------------------+
input string   SYMBOL_STR = "USDJPY";

//input int      NUMOF_DAYS = 30;
input int      NUMOF_DAYS = 3;

// default: PERIOD_H1
input int      TIME_FRAME = 60;

// default: half the starting bar
input double   DOWN_X_PERCENT = 0.5;

// default: if more than this value, then
//          a trend is being formed
input int      NUMOF_BARS_IN_TREND = 10;

input int      MA_PERIOD = 25;

//--------------------------------------------------------------------
int start()                           // Special function start()
  {

   //test
   if(Fact_Up == true)           // initially, Fact_Up is set to be true
     {
     
         //+------------------------------------------------------------------+
         //| setup
         //+------------------------------------------------------------------+
         setup();

         //+------------------------------------------------------------------+
         //| operation
         //+------------------------------------------------------------------+
         detect_Bottom();

         //write_file__Trend_Up();
         
         //debug
         //Alert("[",__LINE__,"] file written; Fact_Up --> false");
         
         Fact_Up = false;        // no more executions
         
         //+------------------------------------------------------------------+
         //| closing
         //+------------------------------------------------------------------+
         //closing();

     }



//--------------------------------------------------------------------
   return 0;                            // Exit start()
   
}//int start()
//--------------------------------------------------------------------

void setup() {

   //+------------------------------------------------------------------+
   //| set: symbol
   //+------------------------------------------------------------------+
   
   ChartSetSymbolPeriod(0, SYMBOL_STR, 0);  // set symbol
   
   Alert("[",__LINE__,"] symbol set to => ",SYMBOL_STR,"");

   //+------------------------------------------------------------------+
   //| set: time frame
   //+------------------------------------------------------------------+
   switch(TIME_FRAME)
     {
      case  60:
        
            NUMOF_TARGET_BARS = NUMOF_DAYS * 24;
        
        break;

      case  1: // 1 minute: "NUMOF_DAYS" value is now interpreted as
               //             "NUMOF_HOURS"
        
            NUMOF_TARGET_BARS = NUMOF_DAYS * 60;
        
        break;

      default:
      
            NUMOF_TARGET_BARS = NUMOF_DAYS * 24;
            
        break;
     }

   //+------------------------------------------------------------------+
   //| Array
   //+------------------------------------------------------------------+
   ArrayResize(HIT_INDICES, NUMOF_TARGET_BARS);
   

}//setup

void detect_Bottom() {
//xx
   Alert("[",__LINE__,"] detect_Bottom()");
   
   double b_0, b_1, b_2, b_n1, b_n2;
   
   int   offset_0 = 0;
   int   offset_1 = 1;
   int   offset_2 = 2;
   int   offset_n1 = -1;
   int   offset_n2 = -2;
   
   for(int i = (NUMOF_TARGET_BARS - 1 - 2); i >= 2; i--)
     {
      
         //b_0 = Close[i] - Open[i];
         b_0 = Close[i + offset_0] - Open[i + offset_0];
         
         if(b_0 >= 0)
           {
           
               NUMOF_HIT_INDICES += 1;
            
           }
         else //if(body >= 0)
           {
            
           }//if(body >= 0)
      
     }//for(int i = (NUMOF_TARGET_BARS - 1); i >= 0; i--)



   //+------------------------------------------------------------------+
   //| report
   //+------------------------------------------------------------------+
   Alert("NUMOF_TARGET_BARS => ",NUMOF_TARGET_BARS,""
   
      + " / "
      + "NUMOF_HIT_INDICES => ",NUMOF_HIT_INDICES,""
      
      + "(",NormalizeDouble(NUMOF_HIT_INDICES * 1.0 / NUMOF_TARGET_BARS, 4),")"
   
   );

}//detect_Bottom()

