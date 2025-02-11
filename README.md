# QueensSolver
Solves the LinkedIn Queens puzzle.

The image of the puzzle matrix on LinkedIn must be transferred to a text file first.
For example, converting puzzle 286 to the input file for the solver.
Create a text file queens286.txt from puz286.png:<br>
puzzle 286<br>
0000111<br>
0220001<br>
0000111<br>
3444415<br>
3333555<br>
3363355<br>
3333555<br>

Each square has a color, a group of squares with the same color is called an area.
Area numbers start from '0' and can go up to '9' in this version of the solver.
Then run the solver with AWK: awk -f queenssolver.awk queens286.txt > solved286.txt<br>
(or in Windows/DOS drop queens286.txt on the batch file.<br>

Typical output would be:<br>
20:26:40,03<br>
Solve Queens puzzle 286<br>
Board:<br>
0  0  0  0# 1  1  1<br>
0  2# 2  0  0  0  1<br>
0  0  0  0  1  1  1#<br>
3  4  4  4  4# 1  5<br>
3# 3  3  3  5  5  5<br>
3  3  6# 3  3  5  5<br>
3  3  3  3  5  5# 5<br>
---<br>
20:26:40,79<br>
<br>
The squares marked with a '#' must contain a Queen.
These can be entered in the LinkedIn puzzle.
