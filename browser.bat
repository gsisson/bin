@echo off

SET A1=%1
SET A2=%2
SET A3=%3
SET A4=%4
SET A5=%5
SET A6=%6
SET A7=%7
SET A8=%8
SET A9=%9
SHIFT
SHIFT
SHIFT
SHIFT
SHIFT
SHIFT
SHIFT
SHIFT
SHIFT
SET B1=%1
SET B2=%2
SET B3=%3
SET B4=%4
SET B5=%5
SET B6=%6
SET B7=%7
SET B8=%8
SET B9=%9

echo  %USERPROFILE%\usr\local\browser%A1%.exe %A2% %A3% %A4% %A5% %A6% %A7% %A8% %A9% %B1% %B2% %B3% %B4% %B5% %B6% %B7% %B8% %B9%
start %USERPROFILE%\usr\local\browser%A1%.exe %A2% %A3% %A4% %A5% %A6% %A7% %A8% %A9% %B1% %B2% %B3% %B4% %B5% %B6% %B7% %B8% %B9%
