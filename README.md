# QueensSolver
Solves the LinkedIn Queens puzzle.

The image of the puzzle matrix on LinkedIn must be transferred to a text file first.
In this example the Queens #285 puzzle is converted to 'queens285.txt'.
Each square has a color, a group of squares with the same color is called an area.
Area numbers start from '0' and can go up to '9' in this version of the solver.

To run the solver, the AWK program is needed.
awk -f queenssolver.awk queens285.txt

Typical output would be:<br>
Solve Queens puzzle 285<br>
Board:<br>
0  0  1  1# 2  3  3  3  3<br>
0  0  1  2  2  2  4# 4  3<br>
0  0  5  5  2# 5  5  4  3<br>
0  5# 5  5  5  5  5  5  3<br>
0  5  5  5  5  5  5  5  3#<br>
0# 0  5  5  5  5  5  3  3<br>
0  0  6# 5  5  5  3  3  7<br>
0  6  6  6  5  8# 3  3  7<br>
0  0  0  6  8  8  7  7# 7<br>
<br>
The squares marked with a '#' must contain a Queen.
These can be entered in the LinkedIn puzzle.
