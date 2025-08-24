extends Control

var rng = RandomNumberGenerator.new()
var bet_n = 1
var bet_dice = 1
var max_roll = 4
var format_string = "%s x %s"
var player_bet : Array[int] = [0,0]
var opponent_bet : Array[int] = [0,0]
var player_roll :  Array[int] = [0,0,0,0,0,0]
var opponent_roll :  Array[int] = [0,0,0,0,0,0]
var player_dice = 6
var opponent_dice = 6
var max_dice = 6

# TODO:
# nicht weniger wetten als die letzte wette erlauben
# Enemy verhalten verbessern:  callen wenn zu viel angesagt wurde
# Menu neues Spiel ende optionen

func back_to_menu():
	get_tree().change_scene_to_file("res://main_menu.tscn")


func opponent_turn():
	if bet_dice < max_roll:
		bet_dice += 1
	else:
		bet_dice = 1
		bet_n += 1
	opponent_bet = [bet_n, bet_dice]
	$HBoxContainer3/HBoxContainer2/CurrentBet.text = format_string % [str(bet_n), str(bet_dice)]

#Fix this same as player
func opponent_call():
	var count = 0
	for roll in player_roll:
		if roll == player_bet[1]:
			count += 1
	for roll in opponent_roll:
		if roll == player_bet[1]:
			count += 1
	if count >= player_bet[0]:
		print("Player Win")
	else:
		print("Player loose")
		
		
func player_call():
	$OpponentDice.visible = true
	var count = 0
	for roll in player_roll:
		if roll == opponent_bet[1]:
			count += 1
	for roll in opponent_roll:
		if roll == opponent_bet[1]:
			count += 1
	if count >= opponent_bet[0]:
		print("You loose")
		player_dice -= 1
	else:
		opponent_dice -= 1
		print("You Win")
	if player_dice == 0:
		print("You lose the game")
		back_to_menu()
	if opponent_dice == 0:
		print("You win the game")
		back_to_menu()
	$Timer.start()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_roll_button_button_down()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_less_button_down() -> void:
	if bet_dice > 1:
		bet_dice -= 1
	elif bet_n > 1:
		bet_dice = max_roll
		bet_n -= 1
	$Bets/Label.text = format_string % [str(bet_n), str(bet_dice)]


func _on_more_button_down() -> void:
	if bet_dice < max_roll:
		bet_dice += 1
	else:
		bet_dice = 1
		bet_n += 1
	$Bets/Label.text = format_string % [str(bet_n), str(bet_dice)]


func _on_place_bet_button_down() -> void:
	$HBoxContainer3/HBoxContainer/CurrentBet.text = $Bets/Label.text
	player_bet = [bet_n,bet_dice]
	opponent_turn()


func _on_roll_button_button_down() -> void:
	$OpponentDice.visible = false
	
	for idx in range(max_dice):
		if idx < player_dice:
			player_roll[idx] = rng.randi_range(1,max_roll)
			$PlayerDice.get_children(true)[idx].visible = true
			$PlayerDice.get_children(true)[idx].text = str(player_roll[idx])
		else:
			player_roll[idx] =  0
			$PlayerDice.get_children(true)[idx].text = str(player_roll[idx])
			$PlayerDice.get_children(true)[idx].visible = false

	for idx in range(max_dice):
		if idx < opponent_dice:
			opponent_roll[idx] = rng.randi_range(1,max_roll)
			$OpponentDice.get_children(true)[idx].visible = true
			$OpponentDice.get_children(true)[idx].text = str(opponent_roll[idx])
		else:
			opponent_roll[idx] =  0
			$OpponentDice.get_children(true)[idx].text = str(opponent_roll[idx])
			$OpponentDice.get_children(true)[idx].visible = false

func _on_call_button_button_down() -> void:
	player_call()

func _on_timer_timeout() -> void:
	_on_roll_button_button_down()
