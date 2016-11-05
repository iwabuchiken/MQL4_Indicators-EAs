@ECHO OFF


REM ************************************
REM *
REM *	Set vars
REM *
REM *	WORKS_HOME	COMMANDS_HOME	SAKURA_HOME
REM *	JAVA_HOME	GIT_CMD			ADB_HOME
REM *	MINGW_BIN_HOME	QMAKE_HOME	
REM *	
REM *	
REM ************************************
:set_path
REM ECHO Setting a var: WORKS_HOME=C:\WORKS
REM SET WORKS_HOME=C:\WORKS
REM PATH=%PATH%;%WORKS_HOME%;

ECHO Setting a var: WORKS_HOME=C:\WORKS_2
SET WORKS_HOME=C:\WORKS_2
PATH=%PATH%;%WORKS_HOME%;

REM ECHO Setting a var: SAKURA_HOME=C:\WORKS\Programs\sakura
REM SET SAKURA_HOME=C:\WORKS\Programs\sakura
REM PATH=%PATH%;%SAKURA_HOME%;

ECHO Setting a var: SAKURA_HOME=C:\Program Files (x86)\sakura
SET SAKURA_HOME=C:\Program Files (x86)\sakura
PATH=%PATH%;%SAKURA_HOME%;

ECHO Setting a var: JAVA_HOME=C:\WORKS_2\Programs\Java
SET JAVA_HOME=C:\WORKS_2\Programs\Java
REM PATH=%PATH%;%JAVA_HOME%;
PATH=%JAVA_HOME%;%PATH%;

ECHO Setting a var: JAVA_HOME_BIN=C:\WORKS_2\Programs\Java\jdk1.7.0_79\bin
SET JAVA_HOME_BIN=C:\WORKS_2\Programs\Java\jdk1.7.0_79\bin
REM PATH=%PATH%;%JAVA_HOME_BIN%;
PATH=%JAVA_HOME_BIN%;%PATH%;

ECHO Setting a var: COMMANDS=C:\WORKS_2\Utils\commands
SET COMMANDS=C:\WORKS_2\Utils\commands
PATH=%PATH%;%COMMANDS%;


ECHO Setting a var: GIT_CMD=C:\WORKS_2\Programs\Git\cmd
SET GIT_CMD=C:\WORKS_2\Programs\Git\cmd
PATH=%PATH%;%GIT_CMD%;

ECHO Setting a var: ADB_HOME=C:\WORKS_2\Programs\android_sdk_r24.0.2\platform-tools
SET ADB_HOME=C:\WORKS_2\Programs\android_sdk_r24.0.2\platform-tools
PATH=%PATH%;%ADB_HOME%;


ECHO Setting a var: ANT_BIN_HOME=C:\WORKS_2\Programs\apache-ant-1.8.4\bin
SET ANT_BIN_HOME=C:\WORKS_2\Programs\apache-ant-1.8.4\bin
PATH=%PATH%;%ANT_BIN_HOME%;

REM ECHO Setting a var: JDK_BIN_HOME=C:\WORKS\Programs\jdk1.8.0_11\bin
REM SET JDK_BIN_HOME=C:\WORKS\Programs\jdk1.8.0_11\bin
REM PATH=%PATH%;%JDK_BIN_HOME%;

ECHO Setting a var: SQLITE3_BIN_HOME=C:\WORKS_2\Programs\sqlite-tools-win32-x86-3140200
SET SQLITE3_BIN_HOME=C:\WORKS_2\Programs\sqlite-tools-win32-x86-3140200
PATH=%PATH%;%SQLITE3_BIN_HOME%;


ECHO Setting a var: PHP_BIN_HOME=C:\WORKS_2\Programs\xampp\php
SET PHP_BIN_HOME=C:\WORKS_2\Programs\xampp\php
PATH=%PATH%;%PHP_BIN_HOME%;

REM ECHO Setting a var: RUBY_BIN_HOME=C:\WORKS\Programs\Ruby200-x64\bin
REM SET RUBY_BIN_HOME=C:\WORKS\Programs\Ruby200-x64\bin
REM PATH=%PATH%;%RUBY_BIN_HOME%;
ECHO Setting a var: RUBY_BIN_HOME=C:\WORKS_2\Programs\Ruby23-x64\bin
ECHO yes!
SET RUBY_BIN_HOME=C:\WORKS_2\Programs\Ruby23-x64\bin
PATH=%PATH%;%RUBY_BIN_HOME%;

ECHO Setting a var: MINGW_BIN_HOME=C:\MinGW\mingw32\bin
SET MINGW_BIN_HOME=C:\MinGW\mingw32\bin
PATH=%PATH%;%MINGW_BIN_HOME%;

REM ECHO Setting a var: RUBY_BIN_HOME=C:\WORKS\Programs\Ruby200-x64\bin
REM SET RUBY_BIN_HOME=C:\WORKS\Programs\Ruby200-x64\bin
REM PATH=%PATH%;%RUBY_BIN_HOME%;

REM ECHO Setting a var: ANT_BIN_HOME=C:\WORKS\Programs\apache-ant-1.8.4\bin
REM SET ANT_BIN_HOME=C:\WORKS\Programs\apache-ant-1.8.4\bin
REM PATH=%PATH%;%ANT_BIN_HOME%;

ECHO Setting a var: CLISP_BIN_HOME=C:\WORKS_2\Programs\clisp-2.49
SET CLISP_BIN_HOME=C:\WORKS_2\Programs\clisp-2.49
PATH=%PATH%;%CLISP_BIN_HOME%;

REM ECHO Setting a var: RUBY_BIN_HOME=C:\WORKS_2\Programs\Ruby22-x64\bin
REM SET RUBY_BIN_HOME=C:\WORKS_2\Programs\Ruby22-x64\bin
REM PATH=%PATH%;%RUBY_BIN_HOME%;

ECHO Setting a var: IRFAN_BIN_HOME=C:\WORKS_2\Programs\freeware\IrfanView
SET IRFAN_BIN_HOME=C:\WORKS_2\Programs\freeware\IrfanView
PATH=%PATH%;%IRFAN_BIN_HOME%;


ECHO Setting aliases for git
ECHO 	=^> checkout -^> co, push -^> p, add -^> a, log -^> l,^
			status -^> s, commit -^> c
git config --global alias.co checkout
git config --global alias.p push
git config --global alias.a add
git config --global alias.l log
git config --global alias.s status
git config --global alias.c commit
git config --global alias.b branch
git config --global alias.t tag

git config --global core.editor sakura.exe

git config --global credential.helper wincred

goto :end

REM *********************
REM *
REM *	End
REM *
REM *********************
:end
rem exit 0





