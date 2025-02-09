# queenssolver.awk
BEGIN {
	size_y = 0
	queens = 0
	searching = 1
}

# board, match handlers 
/^puzzle/ {
	print "Solve Queens puzzle " $2
	next
}
/^[0-9]/ {
	size_x = length($0)			# x width of the play board
	for (i=0; i<size_x; i++) {
		area = substr($0, i+1, 1)
		areaSize[area] = areaSize[area] area
		board[i,size_y] = area
		queen_x[area] = -1		# place holder for queen
	}
	size_y++					# y heigth of the play board
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
					# same row/column
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
					# too close
					return 0
				}
			}
		}
	}
	# valid solution
	return 1
}

function setFirstInArea(area) {
	# find first square of an area
	for (y=0;y<size_y;y++) {
		for (x=0;x<size_x;x++) {
			if (area == board[x,y]) {
				# found first square of area, set queen
				queen_x[area] = x
				queen_first_x[area] = x
				queen_y[area] = y
				queen_first_y[area] = y
				return
			}
		}
	}
}

function setNextInArea(area) {
	# find next x,y square from current
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
		# this queen is back on square 1 of the area
		return 1
	}
	return 0
}

# extra functions
function isQueenAt(x,y) {
	for (j=0; j<queens; j++) {
		if (queen_x[j] == x && queen_y[j] == y) {
			return "#"	# queen at x,y
		}
	}
	return " "			# no queen at x,y 
}

function drawBoard() {
	print "Board:"
	for (y=0; y<size_y; y++) {
		s = ""
		for (x=0; x<size_x; x++) {
			s = s board[x,y] isQueenAt(x,y) " "
		}
		print s
	}
	print "---"
}

function drawQueens() {
	print "Queen locations:"
	for (i=0; i<queens; i++) {
		print "Queen in area " i " at " queen_x[i] "," queen_y[i]
	}
	print "---"
}

function drawAreas() {
	print "Area sizes:"
	for (i=0; i<length(areaSize); i++) {
		print "Area " i " is " areaSize[i]
	}
	print "---"
}

# solver
END {
	# put all queens on the board in their areas
	queens = length(queen_x)
	for (i=0;i<queens;i++) {
		setFirstInArea(i)
	}
	if (dbg==1) {
		print "Initial setup:"
		print "Queens/areas=" queens
		drawAreas()
		print "Board size_x=" size_x " size_y=" size_y
		drawBoard()
	}

	# move queens, odo-meter style (brute force)
	while (searching) {
		if (!checkValid()) {
			# at least one queen is in the wrong place
			for (i=0;i<queens;i++) {
				if (moveQueen(i)==0) {
					# no roll over, done
					break
				}
			}
#			if (dbg==1 && i==queens) {
#				print i 
#			}
		} else {
			drawBoard()
			break
		}
	}
}