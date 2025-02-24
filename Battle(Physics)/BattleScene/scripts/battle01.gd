class_name Battle01 extends CanvasLayer

var questions = [
	{
		"question": "Choose between the following scenarios best showcases both high accuracy and precision to perfectly kill the mob.",
		"options": ["1", "2", "3", "4"],
		"correct_index": 0
	},
	{
		"question": "Two mobs attack you from the same direction (due north). One applies a force of 400 N, and the other applies a force of 350 N. What is the total force that you must resist?",
		"options": ["400N", "50N", "750N", "350N"],
		"correct_index": 2
	},
	{
		"question": "A mob is pushing you with a force applied 500 N east, trying to out-balance him. How much force must you use on the mob to neutralize it?",
		"options": ["500N north", "500N west", "40N west", "400N south"],
		"correct_index": 1
	}
]

var current_question_index = 0
var player_health = 3

@onready var question_label: RichTextLabel = $Control/PanelContainer/RichTextLabel
@onready var choices_container: Control = $Control/Choices/Control

func _ready():
	for i in range(4):
		var button = choices_container.get_child(i) as Button
		if button:
			button.mouse_filter = Control.MOUSE_FILTER_STOP
			button.pressed.connect(func(): on_answer_selected(i))
	load_question()

func load_question():
	if current_question_index >= questions.size():
		end_quiz()
		return
	
	var current_question = questions[current_question_index]
	if question_label:
		question_label.text = current_question["question"]
	
	var options = current_question["options"]
	for i in range(4):
		var button = choices_container.get_child(i)
		if button:
			button.text = options[i] if i < options.size() else ""
			button.visible = i < options.size()

func on_answer_selected(index: int):
	var current_question = questions[current_question_index]
	if current_question["correct_index"] == index:
		current_question_index += 1
		load_question()
	else:
		player_health -= 1
		if player_health <= 0:
			game_over()

func game_over():
	if question_label:
		question_label.text = "Review more"
	await get_tree().create_timer(2.0).timeout
	queue_free()

func end_quiz():
	if question_label:
		question_label.text = "Majority of the slimes has fed, eliminate the remaining ones, press E to attack"
	await get_tree().create_timer(2.0).timeout
	queue_free()
