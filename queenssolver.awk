# queenssolver.awk
BEGIN {
	size_y = 0
	queens = 0
}

# board, match handlers 
/^puzzle/ {
	print "Solve Queens puzzle " $2
	next
}
/^[0-9]+$/ {
	size_x = length($0)			# x width of the play board
	for (i=0; i<size_x; i++) {
		area = substr($0, i+1, 1)
		areaSize[area] = areaSize[area] area
		board[i,size_y] = area
		queen_x[area] = -1		# place holder for queen
		queen_y[area] = 0
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
function isQueenAt(q,x,y) {
	if (queen_x[q] == x && queen_y[q] == y) {
		return "#"	# queen at x,y
	}
	return " "			# no queen at x,y 
}

function drawBoard() {
	print "Board:"
	for (y=0; y<size_y; y++) {
		s = ""
		for (x=0; x<size_x; x++) {
			s = s board[x,y] isQueenAt(board[x,y],x,y) " "
		}
		print s
	}
	print "---"
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
	drawBoard()
}