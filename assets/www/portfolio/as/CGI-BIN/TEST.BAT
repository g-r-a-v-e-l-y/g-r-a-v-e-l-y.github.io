@echo off
set QUERY_STRING=Action%%3DRFR_2_Html_Pages
logview.exe > test.htm
%winbootdir%\command\start.exe /max test.htm
