//--------------------------------------------------------------------
// test_d.p.-2.v2.mq4
//    2016/11/23 20:49:32
//    2016/11/25 15:46:43
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
string   SUBFOLDER = "Research\\41_1";      // subfolder name

int      NUMOF_BARS_PER_HOUR　= 1;        // default: 1 bar per hour

int      NUMOF_TARGET_BARS = 0;

string   FNAME;

string   STRING_TIME;

datetime T;

//+------------------------------------------------------------------+
//| input vars                                                                 |
//+------------------------------------------------------------------+
input string   SYMBOL_STR = "USDJPY";
//input string   SYMBOL_STR = "EURUSD";

input int      NUMOF_DAYS = 30;
//input int      NUMOF_DAYS = 3;

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

         //+------------------------------------------------------------------+
         //| file: write
         //+------------------------------------------------------------------+
         write_file();
         
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
   
   //ChartSetSymbolPeriod(0, SYMBOL_STR, 0);  // set symbol
   ChartSetSymbolPeriod(0, SYMBOL_STR, PERIOD_H1);  // set symbol
   
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

//+------------------------------------------------------------------+
//| write_file
//    @return
//       -1    can't open file
//+------------------------------------------------------------------+
int write_file() {
//yy

   //+------------------------------------------------------------------+
   //| set: file name
   //+------------------------------------------------------------------+
   //datetime t = TimeLocal();
   T = TimeLocal();
   
   //STRING_TIME = conv_DateTime_2_SerialTimeLabel((int)t);
   
   FNAME = "d.p.-2.detect-bottom" 

            + "." + SYMBOL_STR
            + "." + (string) NUMOF_DAYS + "-days"
            //+ "." + conv_DateTime_2_SerialTimeLabel((int)t) 
            + "." + conv_DateTime_2_SerialTimeLabel((int)T) 
            //+ "." + STRING_TIME
            + ".csv";

   //+------------------------------------------------------------------+
   //| file: open
   //+------------------------------------------------------------------+
   int result = _file_open();
   
   if(result == -1)
     {
      
         return -1;
         
     }

   //+------------------------------------------------------------------+
   //| file: write: metadata
   //+------------------------------------------------------------------+
   _file_write__metadata();

   //+------------------------------------------------------------------+
   //| file: write: header
   //+------------------------------------------------------------------+
   _file_write__header();

   //+------------------------------------------------------------------+
   //| file: write: data
   //+------------------------------------------------------------------+
   _file_write__data();

   //+------------------------------------------------------------------+
   //| file: write: footer
   //+------------------------------------------------------------------+
   _file_write__footer();

   //+------------------------------------------------------------------+
   //| file: close
   //+------------------------------------------------------------------+
   _file_close();


   // return
   return 1;

}//write_file()

int _file_write__data() {

   double a, b;
   
   for(int i = 0; i < NUMOF_HIT_INDICES; i++)
     {
     
         a = Close[HIT_INDICES[i]];
         b = Open[HIT_INDICES[i]];

         FileWrite(FILE_HANDLE,
         
            (i + 1), 
            
            HIT_INDICES[i],
            
            TimeToStr(iTime(Symbol(), Period(), HIT_INDICES[i])),
            
            a, b

         );
      
     }//for(i = 0; i < NUMOF_HIT_INDICES; i++)

   
   // metadata
//   FileWrite(FILE_HANDLE,
   
//      "total = " + NUMOF_HIT_INDICES
   
//   );
   
   // return
   return 1;

}//_file_write__data()

int _file_write__footer() {

   FileWrite(FILE_HANDLE,
         
      "done"
      
   );    // header

   //debug
   Alert("[",__LINE__,"] footer => written");

   // return
   return 1;


}//_file_write__footer()

int _file_write__header() {

   FileWrite(FILE_HANDLE,
         
      "no.", "index", "time", "close", "open"
      
   );    // header

   //debug
   Alert("[",__LINE__,"] header => written");

   // return
   return 1;

}//_file_write__header()

int _file_write__metadata() {

   //+------------------------------------------------------------------+
   //| prep: strings
   //+------------------------------------------------------------------+
   string title = "Detect: bottom" 
               ;

   //+------------------------------------------------------------------+
   //| File: write: metadata
   //+------------------------------------------------------------------+
   FileWrite(FILE_HANDLE, 
            //"file created = " + TimeToStr(t, TIME_DATE|TIME_SECONDS), 
            "file created = " + TimeToStr(T, TIME_DATE|TIME_SECONDS), 
            "symbol = " + SYMBOL_STR,
            //PERIOD_CURRENT
            //ref https://www.mql5.com/en/forum/133159
            "time frame = " + (string)Period()
            
            );

   FileWrite(FILE_HANDLE, 
         title
            
   );
   
   FileWrite(FILE_HANDLE, 
   
         "NUMOF_TARGET_BARS = " + (string)NUMOF_TARGET_BARS
         
   );
   
   FileWrite(FILE_HANDLE,

      "start = " + TimeToStr(iTime(Symbol(), Period(), (NUMOF_TARGET_BARS - 1))),
      
      "end = " + TimeToStr(iTime(Symbol(), Period(), 0)),
      
      "days = " + (string)NUMOF_DAYS
      
      ,"total = " + NUMOF_HIT_INDICES
   
   );

   //+------------------------------------------------------------------+
   //| return
   //+------------------------------------------------------------------+
   return 1;

}//_file_write__metadata()


//+------------------------------------------------------------------+
//| _file_open()
//    @return
//       1  file opened
//       0  can't open file
//+------------------------------------------------------------------+
int _file_open() {

   FILE_HANDLE = FileOpen(SUBFOLDER + "\\" + FNAME, FILE_WRITE|FILE_CSV);
      
   //if(FILE_HANDLE!=INVALID_HANDLE) {
   if(FILE_HANDLE == INVALID_HANDLE) {
      
      Alert("[",__LINE__,"] can't open file: ",FNAME,"");
      
      // return
      return -1;

   }//if(FILE_HANDLE == INVALID_HANDLE)

   //+------------------------------------------------------------------+
   //| File: seek
   //+------------------------------------------------------------------+
   //ref https://www.mql5.com/en/forum/3239
   FileSeek(FILE_HANDLE,0,SEEK_END);


   // return
   return 1;
   
}//_file_open()

void _file_close() {

   FileClose(FILE_HANDLE);
   
   Alert("[",__LINE__,"] file => closed");

}//_file_close()

void detect_Bottom() {
//xx
   Alert("[",__LINE__,"] detect_Bottom()");
   
   double   b_0;     // center bar
   double   b_1;     // 1 bar older than the center
   double   b_2;     // 2 bars older than the center
   double   b_n1;    // 1 bar newer than the center
   double   b_n2;    // 2 bars newer than the center
   
   int   offset_0 = 0;
   int   offset_1 = 1;
   int   offset_2 = 2;
   int   offset_n1 = -1;
   int   offset_n2 = -2;
   
   int   flag_up_down = 1;    // the bar is up --> 1; down --> 0
   
   
   
   for(int i = (NUMOF_TARGET_BARS - 1 - 2); i >= 2; i--)
     {
      
         //b_0 = Close[i] - Open[i];
         b_0 = Close[i + offset_0] - Open[i + offset_0];
         
         //+------------------------------------------------------------------+
         //| judge: bar 0
         //+------------------------------------------------------------------+
         if(b_0 >= 0)
           {
               flag_up_down = 1;
           }
         else
           {
               flag_up_down = 0;
           }
         
         //+------------------------------------------------------------------+
         //| judge: bar -1 --> index is +1
         //+------------------------------------------------------------------+
         b_1 = Close[i + offset_1] - Open[i + offset_1];
         
         if(flag_up_down == 1)   // bar 0 --> up
           {
            
               if(b_1 >= 0)     // bar -1 --> up
                 {
                  
                     //
                     continue;
                  
                 }
               else     // bar -1 --> down
                 {

                     if(Close[i + offset_1] >= Open[i + offset_0])
                       {
                           
                           /*
                           HIT_INDICES[NUMOF_HIT_INDICES] = i;
                                 
                           NUMOF_HIT_INDICES += 1;
                           
                           continue;
                           */
                       }
                     else //if(Close[i + offset_1] >= Open[i + offset_0])
                       {
                       
                           continue;
                        
                       }//if(Close[i + offset_1] >= Open[i + offset_0])
                  
                 }//if(b_1 >= 0)
            
           }//if(flag_up_down == 1)
         else // bar 0 --> down
           {
            
               if(b_1 >= 0)     // bar 0 --> down; bar -1 --> up
                 {
                     if(Open[i + offset_1] >= Close[i + offset_0])
                       {
                       
                       /*
                           HIT_INDICES[NUMOF_HIT_INDICES] = i;
                                 
                           NUMOF_HIT_INDICES += 1;
                           
                           continue;
                        */
                       }//if(Open[i + offset_1] >= Close[i + offset_0])
                     else
                       {
                       
                           // next index
                           continue;
                        
                       }//if(Open[i + offset_1] >= Close[i + offset_0])
                  
                 }//if(b_1 >= 0)
               else     // bar 0 --> down; bar -1 --> down
                 {
                  
                     if(Close[i + offset_1] >= Close[i + offset_0])
                       {
                           /*
                           HIT_INDICES[NUMOF_HIT_INDICES] = i;
                                 
                           NUMOF_HIT_INDICES += 1;
                           
                           continue;
                        */
                        
                       }//if(Open[i + offset_1] >= Close[i + offset_0])
                     else
                       {
                       
                           // next index
                           continue;
                        
                       }//if(Open[i + offset_1] >= Close[i + offset_0])
                 }//if(b_1 >= 0)
            
               // no op for now
               //continue;
            
           }//if(flag_up_down == 1)

         //judge: bar -1 --> index is +1 ===============================]]
         
         //+------------------------------------------------------------------+
         //| judge: bar +1 (one bar newer than the center bar) --> index is -1
         //+------------------------------------------------------------------+
         // previous bar   ---> bar 0
         b_0 = Close[i + offset_0] - Open[i + offset_0];
         
         // target bar     --> bar 1 (index is -1)
         b_n1 = Close[i + offset_n1] - Open[i + offset_n1];
         
         // judge
         if(b_0 >= 0)   // bar 0 --> up
           {

               //+------------------------------------------------------------------+
               //| bar 0 --> up / bar 1 --> up
               //+------------------------------------------------------------------+
               if(b_n1 >= 0)     // bar 0 --> up, bar 1 --> up
                 {
                     
                     if(Open[i + offset_n1] >= Open[i + offset_0])// bar 1 higher than bar 0
                       {
                       /*
                           HIT_INDICES[NUMOF_HIT_INDICES] = i;
                                 
                           NUMOF_HIT_INDICES += 1;
                           
                           continue;
                           
                           */

                       }
                     else// bar 1 lower than bar 0
                       {
                        
                           continue;
                        
                       }
                     
                     
                 }//if(b_n1 >= 0)
               else           // bar 0 --> up, bar 1 --> down
                 {

                     if(Close[i + offset_n1] >= Open[i + offset_0])// bar 1 higher than bar 0
                       {
                       /*
                           HIT_INDICES[NUMOF_HIT_INDICES] = i;
                                 
                           NUMOF_HIT_INDICES += 1;
                           
                           continue;
                           
                           */

                       }
                     else// bar 1 lower than bar 0
                       {
                        
                           continue;
                        
                       }
                  
                 }//if(b_n1 >= 0)

           }
         else  //if(b_0 >= 0)   // bar 0 --> down
           {

               if(b_n1 >= 0)     // bar 0 --> down, bar 1 --> up
                 {
                     
                     if(Open[i + offset_n1] >= Close[i + offset_0])// bar 1 higher than bar 0
                       {
                       /*
                           HIT_INDICES[NUMOF_HIT_INDICES] = i;
                                 
                           NUMOF_HIT_INDICES += 1;
                           
                           continue;
                           
                           */

                       }
                     else// bar 1 lower than bar 0
                       {
                        
                           continue;
                        
                       }
                     
                     
                 }//if(b_n1 >= 0)
               else           // bar 0 --> down, bar 1 --> down
                 {

                     if(Close[i + offset_n1] >= Close[i + offset_0])// bar 1 higher than bar 0
                       {
                       /*
                           HIT_INDICES[NUMOF_HIT_INDICES] = i;
                                 
                           NUMOF_HIT_INDICES += 1;
                           
                           continue;
                           
                           */

                       }
                     else// bar 1 lower than bar 0
                       {
                        
                           continue;
                        
                       }
                  
                 }//if(b_n1 >= 0)
         
         
         
            
           }//if(b_0 >= 0)   // bar 0 --> up


         //judge: bar +1 --> index is -1 ===============================]]
         
         //+------------------------------------------------------------------+
         //| judge: bar -2 (two bar older than the center bar) --> index is +2
         //+------------------------------------------------------------------+
         // previous bar   ---> bar -1 (index is +1)
         b_1 = Close[i + offset_1] - Open[i + offset_1];

         // target bar     --> bar -2 (index is -1)
         b_2 = Close[i + offset_2] - Open[i + offset_2];


         // judge
         if(b_1 >= 0)   // bar -1 --> up
           {

               //+------------------------------------------------------------------+
               //| bar -1 --> up / bar -2 --> up
               //+------------------------------------------------------------------+
               if(b_2 >= 0)     // bar 1 --> up, bar 2 --> up
                 {
                     
                     if(Open[i + offset_2] >= Open[i + offset_1])// bar 1 higher than bar 0
                       {
                       /*
                           HIT_INDICES[NUMOF_HIT_INDICES] = i;
                                 
                           NUMOF_HIT_INDICES += 1;
                           
                           continue;
                           */

                       }
                     else// bar 1 lower than bar 0
                       {
                        
                           continue;
                        
                       }
                     
                     
                 }//if(b_2 >= 0)
               else           // bar -1 --> up, bar -2 --> down
                 {

                     if(Close[i + offset_2] >= Open[i + offset_1])// bar 1 higher than bar 0
                       {
                       /*
                           HIT_INDICES[NUMOF_HIT_INDICES] = i;
                                 
                           NUMOF_HIT_INDICES += 1;
                           
                           continue;
                           */

                       }
                     else// bar 1 lower than bar 0
                       {
                        
                           continue;
                        
                       }
                  
                 }//if(b_n1 >= 0)

           }
         else  //if(b_1 >= 0)   // bar -1 --> down
           {

               if(b_2 >= 0)     // bar -1 --> down, bar -2 --> up
                 {
                     
                     if(Open[i + offset_2] >= Close[i + offset_1])// bar -2 higher than bar -1
                       {
                       /*
                           HIT_INDICES[NUMOF_HIT_INDICES] = i;
                                 
                           NUMOF_HIT_INDICES += 1;
                           
                           continue;
                           */

                       }
                     else// bar -2 lower than bar -1
                       {
                        
                           continue;
                        
                       }
                     
                     
                 }//if(b_n1 >= 0)
               else           // bar -1 --> down, bar -2 --> down
                 {

                     if(Close[i + offset_2] >= Close[i + offset_1])// bar -2 higher than bar -1
                       {
                       /*
                           HIT_INDICES[NUMOF_HIT_INDICES] = i;
                                 
                           NUMOF_HIT_INDICES += 1;
                           
                           continue;
                           */

                       }
                     else// bar -2 lower than bar -1
                       {
                        
                           continue;
                        
                       }
                  
                 }//if(b_n1 >= 0)
         
         
         
            
           }//if(b_0 >= 0)   // bar 0 --> up

         //+------------------------------------------------------------------+
         //| judge: bar +2 (two bar newer than the center bar) --> index is -2
         //+------------------------------------------------------------------+
         // previous bar   ---> bar +1 (index is -1)
         b_n1 = Close[i + offset_n1] - Open[i + offset_n1];

         // target bar     --> bar +2 (index is -2)
         b_n2 = Close[i + offset_n2] - Open[i + offset_n2];

         // judge
         if(b_n1 >= 0)   // bar +1 --> up
           {

               //+------------------------------------------------------------------+
               //| bar +1 --> up / bar +2 --> up
               //+------------------------------------------------------------------+
               if(b_2 >= 0)     // bar +1 --> up, bar +2 --> up
                 {
                     
                     if(Open[i + offset_n2] >= Open[i + offset_n1])// bar 1 higher than bar 0
                       {
                       
                           HIT_INDICES[NUMOF_HIT_INDICES] = i;
                                 
                           NUMOF_HIT_INDICES += 1;
                           
                           continue;

                       }
                     else// bar 1 lower than bar 0
                       {
                        
                           continue;
                        
                       }
                     
                     
                 }//if(b_2 >= 0)
               else           // bar +1 --> up, bar +2 --> down
                 {

                     if(Close[i + offset_n2] >= Open[i + offset_n1])// bar +2 higher than bar +1
                       {
                       
                           HIT_INDICES[NUMOF_HIT_INDICES] = i;
                                 
                           NUMOF_HIT_INDICES += 1;
                           
                           continue;

                       }
                     else// bar 1 lower than bar 0
                       {
                        
                           continue;
                        
                       }
                  
                 }//if(b_n1 >= 0)

           }
         else  //if(b_1 >= 0)   // bar +1 --> down
           {

               if(b_2 >= 0)     // bar +1 --> down, bar +2 --> up
                 {
                     
                     if(Open[i + offset_n2] >= Close[i + offset_n1])// bar +2 higher than bar +1
                       {
                       
                           HIT_INDICES[NUMOF_HIT_INDICES] = i;
                                 
                           NUMOF_HIT_INDICES += 1;
                           
                           continue;

                       }
                     else// bar 1 lower than bar 0
                       {
                        
                           continue;
                        
                       }
                     
                     
                 }//if(b_n1 >= 0)
               else           // bar +1 --> down, bar +2 --> down
                 {

                     if(Close[i + offset_2] >= Close[i + offset_1])// bar +2 higher than bar +1
                       {
                       
                           HIT_INDICES[NUMOF_HIT_INDICES] = i;
                                 
                           NUMOF_HIT_INDICES += 1;
                           
                           continue;

                       }
                     else// bar 1 lower than bar 0
                       {
                        
                           continue;
                        
                       }
                  
                 }//if(b_n1 >= 0)
         
         
         
            
           }//if(b_0 >= 0)   // bar 0 --> up
      
   }//for(int i = (NUMOF_TARGET_BARS - 1 - 2); i >= 2; i--)

   //+------------------------------------------------------------------+
   //| report
   //+------------------------------------------------------------------+
   Alert("NUMOF_TARGET_BARS => ",NUMOF_TARGET_BARS,""
   
      + " / "
      + "NUMOF_HIT_INDICES => ",NUMOF_HIT_INDICES,""
      
      + "(",NormalizeDouble(NUMOF_HIT_INDICES * 1.0 / NUMOF_TARGET_BARS, 4),")"
   
   );

}//detect_Bottom()

