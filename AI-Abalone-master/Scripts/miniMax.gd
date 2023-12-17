extends Node

export var visualizer_path : NodePath
onready var visualizer = get_node(visualizer_path)

var transposition_table = []

var game_finished = false

var state_shown = 0

var circle1 = [0,1,2,3,4,5,10,11,17,18,25,26,34,35,42,43,49,50,55,56,57,58,59,60]
var circle2 = [6,7,8,9,12,16,19,24,27,33,36,41,44,48,51,52,53,54]
var circle3 = [13,14,15,20,23,28,32,37,40,45,46,47]
var circle4 = [21,22,29,31,38,39,30]

var black_count = 0
var white_count = 0

var alpha = -1000
var beta = 1000

var CUTOFF = 10
var max_depth = 2
var best_state = null

var condition = true

var player = BoardManager.BLACK

func _process(_delta):
	
	if not game_finished:
		
		if condition:
			var alphabeta = alphabeta_forwardpruning(BoardManager.current_board, player, max_depth, true, alpha, beta)	
			visualizer.update_board(best_state.board)
			BoardManager.current_board = best_state.board
			transposition_table.append(best_state.board)
			condition = false
			player = BoardManager.WHITE
			alpha = -1000
			beta = 1000

		else:
			var alphabeta = alphabeta_forwardpruning(BoardManager.current_board, player, max_depth, true, alpha, beta)	
			visualizer.update_board(best_state.board)
			BoardManager.current_board = best_state.board
			transposition_table.append(best_state.board)
			condition = true
			player = BoardManager.BLACK
			alpha = -1000
			beta = 1000
	
	if game_finished:
		if Input.is_action_just_pressed("ui_up") and state_shown != 0:
			state_shown = state_shown - 1
			BoardManager.current_board =transposition_table[state_shown]
			visualizer.update_board(BoardManager.current_board)
			
		if Input.is_action_just_pressed("ui_down") and state_shown != len(transposition_table) - 1:
			state_shown = state_shown + 1
			BoardManager.current_board = transposition_table[state_shown]
			visualizer.update_board(BoardManager.current_board)
		
func alphabeta_forwardpruning(current_board, player, depth, max_player, alpha, beta):
	var check_winner_result = check_winner(current_board)
	if check_winner_result[0]:
		if player == BoardManager.BLACK and check_winner_result[1] <= 8:
			return 1000000
		elif player == BoardManager.BLACK and check_winner_result[2] <= 8:
			return -1000000
		elif player == BoardManager.WHITE and check_winner_result[1] <= 8:
			return -1000000
		elif player == BoardManager.WHITE and check_winner_result[2] <= 8:
			return 1000000
	
	if depth == 0:
		return minimax_eval(current_board,player)
	
	if max_player:
		var max_value = -1000
		var test_state = State.new(current_board,0,0)
		var successors = Successor.calculate_successor(test_state, player)
		if player == BoardManager.BLACK:
			player = BoardManager.WHITE
		else:
			player = BoardManager.BLACK
			
		var evals = []
		for successor in successors:
			evals.append(minimax_eval(successor.board, player))
		
		for i in range (0, len(evals) - 1):
			for j in range(0, len(evals) - i - 1):
				if evals[j] > evals[j+1]:
					var temp = evals[j]
					evals[j] = evals[j+1]
					evals[j+1] = temp
					
					var temp1 = successors[j]
					successors[j] = successors[j+1]
					successors[j+1] = temp1
		
		for unit in range(0, CUTOFF):
			var temp = true
			for i in range (len(transposition_table)):
				if transposition_table[i] == successors[unit].board:
					temp = false
			
			if temp: 
				var current_value = alphabeta_forwardpruning(successors[unit].board, player, depth - 1, false, alpha, beta)
				if current_value > max_value:
					max_value = current_value
					best_state = successors[unit]
					if alpha < max_value:
						alpha = max_value
						
			if beta <= alpha:
				break
		return max_value
	else:
		var min_value = 1000
		var test_state = State.new(current_board,0,0)
		var successors = Successor.calculate_successor(test_state, player)
		if player == BoardManager.BLACK:
			player = BoardManager.WHITE
		else:
			player = BoardManager.BLACK
			
		var evals = []
		for successor in successors:
			evals.append(minimax_eval(successor.board, player))
		
		
		for i in range (0, len(evals) - 1):
			for j in range(0, len(evals) - i - 1):
				if evals[j] < evals[j+1]:
					var temp = evals[j]
					evals[j] = evals[j+1]
					evals[j+1] = temp
					
					var temp1 = successors[j]
					successors[j] = successors[j+1]
					successors[j+1] = temp1

		for unit in range (0, CUTOFF):
			var temp = true
			for i in range (len(transposition_table)):
				if transposition_table[i] == successors[unit].board:
					temp = false
			
			if temp:
				var current_value = alphabeta_forwardpruning(successors[unit].board, player, depth-1, true, alpha, beta)
				if current_value < min_value:
					min_value = current_value
					if beta > min_value:
						#print("yo ")
						beta = min_value
			if beta <= alpha:
				break
				
		return min_value

func check_winner(board):
	black_count = 0
	white_count = 0
	
	for i in range(61):
		if board[i] == BoardManager.BLACK:
			black_count = black_count + 1
		elif board[i] == BoardManager.WHITE:
			white_count = white_count + 1
			
		if black_count > 8 and white_count > 8:
			return [false, black_count, white_count]
	
	game_finished = true
	state_shown = len(transposition_table) - 1
	return [true, black_count, white_count]
	
func minimax_eval(board, player):
	var heuristic = 0
	var enemy_player

	if player == BoardManager.BLACK:
		enemy_player = BoardManager.WHITE
	else:
		enemy_player = BoardManager.BLACK
	
	for i in range(61):
		if board[i] == player:
			heuristic -= get_player_distance_to_center(i)
		if board[i] == enemy_player:
			heuristic += get_enemy_distance_to_center(i)
	
	var marbel_diffrence = 0
	
	for i in range(61):
		if board[i] == player:
			marbel_diffrence += 1
		elif board[i] == enemy_player:
			marbel_diffrence -= 1

	if marbel_diffrence > 0:
		heuristic += marbel_diffrence * 100
	else: 
		heuristic += marbel_diffrence * 150
	

	
	return heuristic
	
func get_enemy_distance_to_center(i):
	for unit in circle1:
		if unit == i:
			return 25
			
	for unit in circle2:
		if i == unit:
			return 15
			
	for unit in circle3:
		if unit == i:
			return 10
			
	for unit in circle4:
		if unit == i:
			return 6
		
func get_player_distance_to_center(i):
	for unit in circle1:
		if unit == i:
			return 15
			
	for unit in circle2:
		if i == unit:
			return 10
			
	for unit in circle3:
		if unit == i:
			return 6
			
	for unit in circle4:
		if unit == i:
			return 2
