REM set dpath_Src=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Include

REM *************************************
REM 	<Usage> (20190114_112539)
REM 	1. update vars
REM 	2. run this batch file
REM *************************************

REM *************************************
REM 	source : dpath
REM *************************************
REM ------- Indicators\lab\obs\49_8 -------
REM set dpath_Src=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Indicators\lab\obs\49_8

REM ------- include -------
REM set dpath_Src=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Include

REM ------- Experts\labs\44_5.3 -------
set dpath_Src=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Experts\labs\44_5.3

REM *************************************
REM 	source : fname
REM *************************************
REM set fname_Src=ea_44_5.3_2_up-up-buy.mq4
REM set fname_Src=obs_49_8.(copy-2).mq4
REM set fname_Src=obs_49_8.(copy).mq4
REM set fname_Src=utils.mqh
REM set fname_Src=lib_ea.mqh
REM set fname_Src=ea_44_5.3_2_up-up-sell.mq4
REM set fname_Src=ea_44_5.3_2_down-down-buy.mq4
REM set fname_Src=lib_ea.mqh
set fname_Src=ea_Exp_1__TrailingStop.mq4

REM *************************************
REM 	dst : dpath 
REM *************************************
REM ------- Experts\labs\44_5.3 -------
REM ref multi line https://stackoverflow.com/questions/605686/windows-how-to-specify-multiline-command-on-command-prompt
set dpath_Dst=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Experts\labs\44_5.3

REM debug
REM echo dpath_Dst = "%dpath_Dst%"
REM goto end

REM *************************************
REM 	command
REM *************************************
REM set command=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\utils\utils.20171123-121700.rb
set command_Path=C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\utils
set command_Name=utils.20171123-121700.rb
set command_Fullpath=%command_Path%\%command_Name%

REM C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\utils\utils.20171123-121700.rb %1 %2 %3

REM *************************************
REM 	exec
REM *************************************
REM %command% %dpath_Src% %fname_Src% %dpath_Dst%
%command_Fullpath% %dpath_Src% %fname_Src% %dpath_Dst%

:end

pause

