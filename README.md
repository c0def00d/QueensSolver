QueensSolver (2025-02-19)<br>
One step closer to automation. <br>
Solving the Queens puzzle involves the following steps:<br>
1. Open the Queens puzzle page, showing the 'board'.<br>
2. Right click on the webpage and select 'page source'.<br>
3. Copy the content (Ctrl-A Ctrl-C) and paste it to a file.<br>
4. Run the command: awk -f queenssolver.awk pasted_text_file<br>
5. When the screen shows the result, enter the Queens on the board.<br>
The squares marked with a '#' must contain a Queen.<br>
The result will also be written to a 'q###.txt' file.<br>