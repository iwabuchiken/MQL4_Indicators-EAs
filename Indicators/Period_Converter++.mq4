#property copyright "wfy05@talkforex.com"
#property link      "http://www.mql4.com/codebase/indicators/277/"
#property indicator_chart_window
#property show_inputs

#include <WinUser32.mqh>


extern int     PeriodMultiplier = 2;      // new period multiplier factor
extern int     OutputCSVFile = 0;         // also output CSV file?
extern int     UpdateInterval = 0;        // update interval in milliseconds, zero means update real-time.
extern bool    Enabled = true;
extern bool    Debug = false;

int      FileHandle = -1;
int      CSVHandle = -1;
int      NewPeriod = 0;

#define OUTPUT_HST_ONLY    0
#define OUTPUT_CSV_HST     1
#define OUTPUT_CSV_ONLY    2


#define  CHART_CMD_UPDATE_DATA            33324

void DebugMsg(string msg)
{
   if (Debug) Alert(msg);
}

int init()
{
   //safe checking for PeriodMultiplier.
   if (PeriodMultiplier <= 1) {
      //only output CSV file
      PeriodMultiplier = 1;
      OutputCSVFile = 2;
   }
   NewPeriod = Period() * PeriodMultiplier;
   if (OpenHistoryFile() < 0) return (-1);
   WriteHistoryHeader();
   UpdateHistoryFile(Bars-1, true);
   UpdateChartWindow();
   return (0);
}

void deinit()
{
   //Close file handle
   if(FileHandle >=  0) { 
      FileClose(FileHandle); 
      FileHandle = -1; 
   }
   if (CSVHandle >= 0) {
      FileClose(CSVHandle);
      CSVHandle = -1; 
   }
}


int OpenHistoryFile()
{
   string name;
   
   name = Symbol() + NewPeriod;
   if (OutputCSVFile != OUTPUT_CSV_ONLY) {
      FileHandle = FileOpenHistory(name + ".hst", FILE_BIN|FILE_WRITE);
      if (FileHandle < 0) return(-1);
   }
   if (OutputCSVFile != OUTPUT_HST_ONLY) {
      CSVHandle = FileOpen(name + ".csv", FILE_CSV|FILE_WRITE, ',');
      if (CSVHandle < 0) return(-1);
   }
   return (0);
}

int WriteHistoryHeader()
{
   string c_copyright;
   int    i_digits = Digits;
   int    i_unused[13] = {0};
   int    version = 400;   

   if (FileHandle < 0) return (-1);
   c_copyright = "(C)opyright 2003, MetaQuotes Software Corp.";
   FileWriteInteger(FileHandle, version, LONG_VALUE);
   FileWriteString(FileHandle, c_copyright, 64);
   FileWriteString(FileHandle, Symbol(), 12);
   FileWriteInteger(FileHandle, NewPeriod, LONG_VALUE);
   FileWriteInteger(FileHandle, i_digits, LONG_VALUE);
   FileWriteInteger(FileHandle, 0, LONG_VALUE);       //timesign
   FileWriteInteger(FileHandle, 0, LONG_VALUE);       //last_sync
   FileWriteArray(FileHandle, i_unused, 0, ArraySize(i_unused));
   return (0);
}


static double d_open, d_low, d_high, d_close, d_volume;
static int i_time;

void WriteHistoryData()
{
   if (FileHandle >= 0) {
      FileWriteInteger(FileHandle, i_time, LONG_VALUE);
      FileWriteDouble(FileHandle, d_open, DOUBLE_VALUE);
      FileWriteDouble(FileHandle, d_low, DOUBLE_VALUE);
      FileWriteDouble(FileHandle, d_high, DOUBLE_VALUE);
      FileWriteDouble(FileHandle, d_close, DOUBLE_VALUE);
      FileWriteDouble(FileHandle, d_volume, DOUBLE_VALUE);
   }
   if (CSVHandle >= 0) {
      int i_digits = Digits;
      
      FileWrite(CSVHandle,
         TimeToStr(i_time, TIME_DATE),
         TimeToStr(i_time, TIME_MINUTES),
         DoubleToStr(d_open, i_digits), 
         DoubleToStr(d_high, i_digits), 
         DoubleToStr(d_low, i_digits), 
         DoubleToStr(d_close, i_digits), 
         d_volume);
   }
}

int UpdateHistoryFile(int start_pos, bool init = false)
{
   static int last_fpos, csv_fpos;
   int i, ps;
      
//   if (FileHandle < 0) return (-1);
   // normalize open time
   ps = NewPeriod * 60;   
   i_time = Time[start_pos]/ps;
   i_time *=  ps;
   if (init) {
         //first time, init data
         d_open = Open[start_pos];
         d_low = Low[start_pos];
         d_high = High[start_pos];
         d_close = Close[start_pos];
         d_volume = Volume[start_pos];                           
         i = start_pos - 1;
         if (FileHandle >= 0) last_fpos = FileTell(FileHandle);
         if (CSVHandle >= 0) csv_fpos = FileTell(CSVHandle);
   } else {
         i = start_pos;
         if (FileHandle >= 0) FileSeek(FileHandle,last_fpos,SEEK_SET);
         if (CSVHandle >= 0) FileSeek(CSVHandle, csv_fpos, SEEK_SET);
   }
   if (i < 0) return (-1);

   int cnt = 0;
   int LastBarTime;
   //processing bars
   while (i >= 0) {
      LastBarTime = Time[i];

      //a new bar
      if (LastBarTime >=  i_time+ps) {
         //write the bar data
         WriteHistoryData();
         cnt++;
         i_time = LastBarTime/ps;
         i_time *= ps;
         d_open = Open[i];
         d_low = Low[i];
         d_high = High[i];
         d_close = Close[i];
         d_volume = Volume[i];
      } else {
         //no new bar
         d_volume +=  Volume[i];
         if (Low[i]<d_low) d_low = Low[i];
         if (High[i]>d_high) d_high = High[i];
         d_close = Close[i];      
      }
      i--;
   }
   
   //record last_fpos before writing last bar.
   if (FileHandle >= 0) last_fpos = FileTell(FileHandle);
   if (CSVHandle >= 0) csv_fpos = FileTell(CSVHandle);
   
   WriteHistoryData();
   cnt++;
   d_volume -=  Volume[0];
   
   //flush the data writen
   if (FileHandle >= 0) FileFlush(FileHandle);
   if (CSVHandle >= 0) FileFlush(CSVHandle);
   return (cnt);
}

int UpdateChartWindow()
{
   static int hwnd = 0;

   if (FileHandle < 0) {
      //no HST file opened, no need updating.
      return (-1);
   }
   if(hwnd == 0) {
      //trying to detect the chart window for updating
      hwnd = WindowHandle(Symbol(), NewPeriod);
   }
   if(hwnd!= 0) {
      if (IsDllsAllowed() == false) {
         //DLL calls must be allowed
         DebugMsg("Dll calls must be allowed");
         return (-1);
      }
      if (PostMessageA(hwnd,WM_COMMAND,CHART_CMD_UPDATE_DATA,0) == 0) {
         //PostMessage failed, chart window closed
         hwnd = 0;
      } else {
         //PostMessage succeed
         return (0);
      }
   }
   //window not found or PostMessage failed
   return (-1);
}


/*
int PerfCheck(bool Start)
{
   static int StartTime = 0;
   static int Index = 0;
   
   if (Start) {
      StartTime = GetTickCount();
      Index = 0;
      return (StartTime);
   }
   Index++;
   int diff = GetTickCount() - StartTime;
   Alert("Time used [" + Index + "]: " + diff);
   StartTime = GetTickCount();
   return (diff);
}
*/

static int LastStartTime = 0;
static int LastEndTime = 0;
static int LastBarCount = 0;

int reinit()
{
   deinit();
   init();
   LastStartTime = Time[Bars-1];
   LastEndTime = Time[0];
   LastBarCount = Bars;
}

bool IsDataChanged()
{
/*
   static int LastBars = 0, LastTime = 0, LastVolume = 0;
   static double LastOpen = 0, LastClose = 0, LastHigh = 0, LastLow = 0;
   
   if (LastVolume != Volume[0] || LastBars != Bars || LastTime != Time[0]|| 
      LastClose != Close[0] || LastHigh != High[0] || LastLow != Low[0] || 
      LastOpen != Open[0]) {

      LastBars = Bars;
      LastVolume = Volume[0];
      LastTime = Time[0];
      LastClose = Close[0];
      LastHigh = High[0];
      LastLow = Low[0];
      LastOpen = Open[0];
      return (true);
   }
   return (false);
*/
/*
   fast version without float point operation
*/
   static int LastBars = 0, LastTime = 0, LastVolume = 0;
   bool ret;
   
   ret = false;
   if (LastVolume != Volume[0]) {
      LastVolume = Volume[0];
      ret = true;
   }
   if (LastTime != Time[0]) {
      LastTime = Time[0];
      ret = true;
   }
   if (LastBars != Bars) {
      LastBars = Bars;
      ret = true;
   }
   return (ret);
}

int CheckNewData()
{
   static string LastServer = "";
   
   if (Bars < 2) {
      //the data is not loaded yet.
      DebugMsg("Data not loaded, only " +  Bars + " Bars");
      return (-1);
   }

   string serv = ServerAddress();
   if (serv == "") {
      //no server yet
      DebugMsg("No server connected");
      return (-1);
   }

   //server changed? check this and reinit to prevent wrong data while changing server.
   if (LastServer != serv) {
      DebugMsg("Server changed from " + LastServer + " to " + serv);
      LastServer = serv;
      reinit();
      return (-1);
   }

   if (!IsDataChanged()) {
      //return if no data changed to save resource
      //DebugMsg("No data changed");
      return (-1);
   }

   if (Time[Bars-1] != LastStartTime) {
      DebugMsg("Start time changed, new history loaded or server changed");
      reinit();
      return (-1);
   }
      
   int i, cnt;
   
   //try to find LastEndTime bar, which should be Time[0] or Time[1] usually,
   //so the operation is fast
   for (i = 0; i < Bars; i++) {
      if (Time[i] <= LastEndTime) {
         break;
      }
   }
   
   if (i >= Bars || Time[i] != LastEndTime) {
      DebugMsg("End time " + TimeToStr(LastEndTime) + " not found");
      reinit();
      return (-1);
   }
   
   cnt = Bars - i;
   if (cnt != LastBarCount) {
      DebugMsg("Data loaded, cnt is " + cnt + " LastBarCount is " + LastBarCount);
      reinit();
      return (-1);
   }

   //no new data loaded, return with LastEndTime position.
   LastBarCount = Bars;
   LastEndTime = Time[0];
   return (i);
}

//+------------------------------------------------------------------+
//| program start function                                           |
//+------------------------------------------------------------------+
int start()
{
   static int last_time = 0;

   if (!Enabled) return (0);
         
   //always update or update only after certain interval
   if (UpdateInterval !=  0) {
      int cur_time;
      
      cur_time = GetTickCount();
      if (MathAbs(cur_time - last_time) < UpdateInterval) {
         return (0);
      }
      last_time = cur_time;
   }

   //if (Debug) PerfCheck(true);
   int n = CheckNewData();
   //if (Debug) PerfCheck(false);   
   if (n < 0) return (0);

   //update history file with new data
   UpdateHistoryFile(n);
   //refresh chart window
   UpdateChartWindow();
   //if (Debug) PerfCheck(false);
   return(0);
}



