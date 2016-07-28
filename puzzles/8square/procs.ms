export('8square.x', -2153);
export('8square.y', array(234, 233, 232));
export('8square.z', array(1767, 1766, 1765));
export('8square.world', 'world');

# Returns the nearby cells that share a side with the input cell
proc _adjacent_cells(@cell){
	@x = import('8square.x');
	@row = import('8square.z');
	@col = import('8square.y');
	@world = import('8square.world');
	@validcells = array();
	@maxrows = array_size(@row);
	@maxcols = array_size(@col);
	if (@cell[0] + 1 < @maxrows){
		@validcells[] = array(@cell[0] + 1, @cell[1]);
	}
	if (@cell[0] - 1 >= 0){
		@validcells[] = array(@cell[0] - 1, @cell[1]);
	}
	if (@cell[1] + 1 < @maxcols){
		@validcells[] = array(@cell[0], @cell[1] + 1);
	}
	if (@cell[1] - 1 >= 0){
		@validcells[] = array(@cell[0], @cell[1] - 1);
	}
	return(@validcells);
}

# Returns the value of the specified cell
proc _cell_value(@cell){
	@x = import('8square.x');
	@row = import('8square.z');
	@col = import('8square.y');
	@world = import('8square.world');
	broadcast(array(@x, @col[@cell[0]], @row[@cell[1]], @world));
	return(get_sign_text(array(@x, @col[@cell[0]], @row[@cell[1]], @world)));
}

# Returns the location of the empty cell
proc _blank_cell(){
	@x = import('8square.x');
	@row = import('8square.z');
	@col = import('8square.y');
	@world = import('8square.world');
	for(@i = 0, @i < array_size(@row), @i++){
		for(@j = 0, @j < array_size(@col), @j++){
			msg(@i.','.@j);
			if (get_sign_text(array(@x, @col[@i], @row[@j], @world))[0] == ''){				
				return(array(@i, @j));
			}
		}
	}
}

# Prints the values of all cells
proc _dump_cells(){
	@row = import('8square.z');
	@col = import('8square.y');
	for(@i = 0, @i < array_size(@row), @i++){
		for(@j = 0, @j < array_size(@col), @j++){
			msg(_cell_value(array(@i, @j))[0]);
		}
	}
}

# Returns a 1 dimensional array containing the cells from left to right, top to bottom
# Noteworthy calculations: (if I ever make it more portable) 
# array[@i][@j] = array[@i*array_size(@i) + @j]
# array[@t] = array[floor(@t / array_size(@i))][@t - floor(@t / array_size(@i)) * @array_size(@i)] 
proc _array_collapsed(){
	@row = import('8square.z');
	@col = import('8square.y');
	@1darray = array();
	for(@i = 0, @i < array_size(@row), @i++){
		for(@j = 0, @j < array_size(@col), @j++){
			@1darray[] = array(@i, @j);
		}
	}
	return(@1darray);
}

# Check if the square is solved
proc _is_solved(){
	@cells = _array_collapsed();
	for(@i = 1, @i < array_size(@cells), @i++){
		if (_cell_value(@cells[@i])[0] < _cell_value(@cells[@i - 1])[0]){
			return(false);
		}
	}
	return(false);
}

# Attempt to solve the square, running for maxiter number of iterations
proc _solve(@maxiter){
	for(@c = 0, @c <= @maxiter, @c++){
		
	}
}
