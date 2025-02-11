@echo off
rem queens
echo %TIME%
awk -f queenssolver.awk %1
echo %TIME%
pause
