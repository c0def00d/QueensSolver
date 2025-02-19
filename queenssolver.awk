# queenssolver.awk (2025-02-19)
BEGIN {
	size_y = 0
	queens = 0
	puzzle_id = ""
	start_time = systime()
}

# webscrape, build board
/;puzzleId&quot;:[0-9]+,&quot;/ {
	# match en extract nummer		
	if (match($0, /;puzzleId&quot;:[0-9]+,&quot;/)) {
		if (puzzle_id == "") {
			puzzle_id = substr($0, RSTART+16, 3)
			output = "q" puzzle_id ".txt"
			print "---" > output
			printOut( "Queens puzzle #" puzzle_id )
		}
	}
}

{
	pos = 0
	while (match($0, /&quot;:\[[0-9,]+\],&quot;/)) {
		s = substr($0, RSTART+8, RLENGTH-16)
		size_x = length(s)/2
		x = 0
		for (i=1;i<length(s)+1;i+=2) {
			area = substr(s,i,1)
			board[x,size_y] = area
			queen_x[area] = -1		# place holder for queen
			queen_y[area] = 0
			x++
		}
		size_y++
		$0 = substr($0, RSTART + RLENGTH)
   }
}

# board functions

# return board status: 0=invalid 1=valid
function checkValid() {
	for (a=0;a<queens;a++) {
		# test queen q position against all others
		for (q=0;q<queens;q++) {
			# except for the same queen/area
			if (a!=q) {
				# check row/column
				if ((queen_x[a] == queen_x[q]) ||
				    (queen_y[a] == queen_y[q])) {
					# same row/column, not valid
					return 0
				}
				# check diagonal neighbours
				if (((queen_x[a]-1 == queen_x[q]) &&	# left/up
				     (queen_y[a]-1 == queen_y[q])) ||
				    ((queen_x[a]+1 == queen_x[q]) && 	# right/up
				     (queen_y[a]-1 == queen_y[q])) ||
				    ((queen_x[a]-1 == queen_x[q]) &&	# left/down
				     (queen_y[a]+1 == queen_y[q])) ||
				    ((queen_x[a]+1 == queen_x[q]) &&	# right/down 
				     (queen_y[a]+1 == queen_y[q]))) {
					# too close, not valid
					return 0
				}
			}
		}
	}
	# valid solution
	return 1
}

function setNextInArea(area) {
	# find next square in area from current
	x = queen_x[area] + 1
	y = queen_y[area]
	if (x >= size_x) {
		x = 0
		if (++y >= size_y) {
			y = 0
		}			
	}
	while (area != board[x,y]) {
		if (++x >= size_x) {
			x = 0
			if (++y >= size_y) {
				y = 0
			}			
		}
	}
	# put queen in area
	queen_x[area] = x
	queen_y[area] = y
}

function moveQueen(q) {
	setNextInArea(q)
	if ((queen_x[q] == queen_first_x[q]) &&
		(queen_y[q] == queen_first_y[q])) {
		# used all squares of the area
		return 1
	}
	return 0
}

# extra functions
function printOut(string) {
	print string >> output
	print string
}

function isQueenAt(q,x,y) {
	if (queen_x[q] == x && queen_y[q] == y) {
		return "#"	# queen at x,y
	}
	return " "			# no queen at x,y 
}

function drawBoard(initial) {
	for (y=0; y<size_y; y++) {
		s = ""
		for (x=0; x<size_x; x++) {
			s = s board[x,y] ((initial) ? isQueenAt(board[x,y],x,y) : " ") " "
		}
		printOut( s )
	}
	printOut( "---" )
}

# solver
END {
	# put all queens on the board in their areas
	queens = length(queen_x)
	for (i=0;i<queens;i++) {
		setNextInArea(i)
		queen_first_x[i] = queen_x[i]
		queen_first_y[i] = queen_y[i]
	}

	printOut( "Initial board:" )
	drawBoard(0)

	# brute force solution
	while (!checkValid()) {	
		# move queen(s)
		for (i=0;i<queens;i++) {
			if (moveQueen(i)==0) {
				# same area, done
				break
			}
		}
	}
	printOut( "Solved board:" )
	drawBoard(1)
	printOut( "Solved in " systime() - start_time " seconds." )
}