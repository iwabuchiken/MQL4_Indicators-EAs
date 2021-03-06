//--------------------------------------------------------------------
//    loc   :  C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Indicators\lab\24_4
//    file  :  t_24_4.(1)..mq4
//    time  :  2017/08/25 13:27:13
// 
// <Usage>
// - 
// <steps>
//    1. update
//          *1) comment block: file name, created-at string
//          *2) "SUBFOLDER" value
//          *2-2) "FNAME" value
//          *3) "string title" value
//          4) _file_write__header() --> column names
//          5) _file_write__data() --> edit variables

//--------------------------------------------------------------------
//+------------------------------------------------------------------+
//| Includes                                                                 |
//+------------------------------------------------------------------+
#include <utils.mqh>

//+------------------------------------------------------------------+
//| vars                                                                 |
//+------------------------------------------------------------------+
extern int Period_MA=21;            // Calculated MA period

int HOURS_PER_DAY=24;

int HIT_INDICES[];   // indices of matched bars

                     // counter
int NUMOF_HIT_INDICES=0;

int FILE_HANDLE;

//+------------------------------------------------------------------+
//| infra vars                                                                 |
//+------------------------------------------------------------------+
//string   SUBFOLDER="Research\\46_3";      // subfolder name

int      NUMOF_BARS_PER_HOUR　=1;        // default: 1 bar per hour

int      NUMOF_TARGET_BARS=0;

string   FNAME;

string   session_ID = "24_4";

//string   FNAME_THIS = "t_24_4.(1).mq4";
string   FNAME_THIS = "t_" + session_ID + ".(1).mq4";

string   STRING_TIME;

datetime T;

string DATA[][6];

int      NUMOF_DATA;

//+------------------------------------------------------------------+
//| input vars                                                                 |
//+------------------------------------------------------------------+
input string   SYMBOL_STR="USDJPY";
//input string   SYMBOL_STR = "EURUSD";

//input int      NUMOF_DAYS  = 30;
//input int      NUMOF_DAYS  = 365; // 1 year
input int      NUMOF_DAYS  = 60;    // 2 months
//input int      NUMOF_DAYS = 3;

// default: PERIOD_H1
input int      TIME_FRAME=60;

// BB period
input int      BB_PERIOD = 25;

//input string   SUBFOLDER = "46_3";      // subfolder name
//input string   SUBFOLDER = "24_4";      // subfolder name
input string   SUBFOLDER   = "24_4";      // subfolder name ---> same as sessin_ID

input int      RSI_PERIOD     = 20;

input int      RSI_THRESHOLD  = 75;

input string   SPAN_START     = "2016.04.01 00:00";

input string   SPAN_END     = "2016.10.31 23:00";

input bool     WRITE_DATA_TO_FILE = true;

//--------------------------------------------------------------------
int init() {

   //+------------------------------------------------------------------+
   //| setup
   //+------------------------------------------------------------------+
   setup();   

   //debug
   Alert("[",__LINE__,"] NUMOF_TARGET_BARS => ", NUMOF_TARGET_BARS);
   
   //debug
   Alert("[",__LINE__,"] init() done");

   //ref return value -> https://www.mql5.com/en/forum/55560   
   return 0;
  
}

int exec() {

   //+------------------------------------------------------------------+
   //| setup
   //+------------------------------------------------------------------+
   //+---------------------------------+
   //| setup   : file
   //+---------------------------------+
   T=TimeLocal();
   
   FNAME = SUBFOLDER
         
         + "_"
         
         + "file-io"

         + "." + SYMBOL_STR
         + "." + (string) NUMOF_DAYS+"-days"
         
         +"."
         + conv_DateTime_2_SerialTimeLabel((int)T)
         //+ "." + STRING_TIME
         +".csv";
         
    //debug
    Alert("[",__LINE__,"] FNAME => ", FNAME);
    //PrintFormat("[%d] exec() done", __LINE__);
    //PrintFormat("[] exec() done");
   
   //+------------------------------------------------------------------+
   //| file: open
   //+------------------------------------------------------------------+
      int result=_file_open();
   
      if(result==-1)
        {
   
         return -1;
   
        }

   //+------------------------------------------------------------------+
   //| file: write text
   //+------------------------------------------------------------------+
   _file_write__header();
      
   //+------------------------------------------------------------------+
   //| file: close
   //+------------------------------------------------------------------+
      _file_close();


   return   1;

}//exec()

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void _file_close() 
  {

   FileClose(FILE_HANDLE);

   Alert("[",__LINE__,"] file => closed : ", FNAME);

  }//_file_close()


//+------------------------------------------------------------------+
//| _file_open()
//    @return
//       1  file opened
//       0  can't open file
//+------------------------------------------------------------------+
int _file_open() 
  {

   //FILE_HANDLE=FileOpen(SUBFOLDER+"\\"+FNAME,FILE_WRITE|FILE_CSV);
   FILE_HANDLE=FileOpen("Research\\" + SUBFOLDER + "\\"+FNAME,FILE_WRITE|FILE_CSV);

//if(FILE_HANDLE!=INVALID_HANDLE) {
   if(FILE_HANDLE==INVALID_HANDLE) 
     {

      Alert("[",__LINE__,"] can't open file: ",FNAME,"");

      // return
      return -1;

     }//if(FILE_HANDLE == INVALID_HANDLE)

//+------------------------------------------------------------------+
//| File: seek
//+------------------------------------------------------------------+
//ref https://www.mql5.com/en/forum/3239
   FileSeek(FILE_HANDLE,0,SEEK_END);

   //debug
   Alert("[",__LINE__,"] file opend : ",FNAME,"");

// return
   return 1;

}//_file_open()

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int _file_write__header() 
  {

   FileWrite(FILE_HANDLE,
               
               "no.", "index", "kairi", "datetime", "symbol", "period"
               
             );    // header

//debug
   Alert("[",__LINE__,"] header => written");

// return
   return 1;

  }//_file_write__header()


int start() // Special function start()
  {
  
         //+------------------------------------------------------------------+
         //| setup
         //+------------------------------------------------------------------+
         //setup();
         //Alert("[",__LINE__,"] starting...");
   
   
         //+------------------------------------------------------------------+
         //| operations                                                                 |
         //+------------------------------------------------------------------+
         //exec();
         //+------------------------------------------------------------------+
         //| terminating the loop                                                                 |
         //+------------------------------------------------------------------+

//--------------------------------------------------------------------
   return 0;                            // Exit start()

  }//int start()
//--------------------------------------------------------------------

//ref about "tick" --> https://www.mql5.com/en/forum/109552
void setup() 
  {
  
   //+------------------------------------------------------------------+
   //| opening message
   //+------------------------------------------------------------------+
   //Alert("starting TR-5.mq4");
   Alert("[",__LINE__,"] starting" + " " + FNAME_THIS);


   //+------------------------------------------------------------------+
   //| set: time frame
   //+------------------------------------------------------------------+
   switch(TIME_FRAME)
     {
      case  60:      // 1 hour

         NUMOF_TARGET_BARS=NUMOF_DAYS*24;
         
         ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H1);  // set symbol

         break;

      case  240: // 4 hours

         NUMOF_TARGET_BARS = NUMOF_DAYS * 6;
         
         ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H4);  // set symbol

         break;

      case  480: // 8 hours

         NUMOF_TARGET_BARS = NUMOF_DAYS*3;
         
         ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H8);  // set symbol

         break;

      case  1440: // 1 day

         NUMOF_TARGET_BARS = NUMOF_DAYS;
         
         ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_D1);  // set symbol

         break;

      case  10080: // 1 week

         //ref https://www.mql5.com/en/forum/151559
         //NUMOF_TARGET_BARS = (int) NUMOF_DAYS / 7;
         NUMOF_TARGET_BARS = NUMOF_DAYS;
         
         ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_W1);  // set symbol

         break;

      case  1: // 1 minute: "NUMOF_DAYS" value is now interpreted as
         //             "NUMOF_HOURS"

         NUMOF_TARGET_BARS=NUMOF_DAYS*60;
         
         ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_M1);  // set symbol

         break;

      default:

         NUMOF_TARGET_BARS=NUMOF_DAYS*24;
         
         ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H1);  // set symbol

         break;
     }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   Alert("[",__LINE__,"] symbol = ",SYMBOL_STR,""
   
            + " / RSI threshold = ",RSI_THRESHOLD,""
            + " / PERIOD = ",Period(),""         
            
         );

//+------------------------------------------------------------------+
//| Array
//+------------------------------------------------------------------+
   ArrayResize(HIT_INDICES,NUMOF_TARGET_BARS);

   //+------------------------------------------------------------------+
   //| operations                                                                 |
   //+------------------------------------------------------------------+
   exec();


}//setup

