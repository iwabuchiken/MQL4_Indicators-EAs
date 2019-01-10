REM set dpath_Src=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Include

set dpath_Src=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Indicators\lab\obs\49_8

set fname_Src=utils.(copy-2).mqh
REM set fname_Src=obs_49_8.(copy-2).mq4
REM set fname_Src=obs_49_8.(copy).mq4
REM set fname_Src=utils.mqh

set dpath_Dst=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Experts\labs\44_5.3
set command=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\utils\utils.20171123-121700.rb

REM C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\utils\utils.20171123-121700.rb %1 %2 %3

%command% %dpath_Src% %fname_Src% %dpath_Dst%

pause
