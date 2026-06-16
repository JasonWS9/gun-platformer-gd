extends Node

enum grade {
	SSS = 6,
	S = 5,
	A = 4,
	B = 3,
	C = 2,
	D = 1,
}

@export var level_list: Array[LevelResource] = []
var current_level: LevelResource

var pass_time: bool = false

#region Current Run
var elapsed_time: float = 0
var current_score: int = 0
var current_hits: int = 0
#endregion


func _process(delta: float) -> void:
	if (pass_time):
		elapsed_time+= delta

func add_score(score: int):
	current_score += score
	
func add_hit():
	current_hits += 1

func reset_score():
	pass_time = false
	elapsed_time = 0
	current_score = 0
	current_hits = 0
func swap_level_data(index: int):
	current_level = level_list[index]
	reset_score()

#region Getting Grades	
func get_time_grade():
	if elapsed_time <= current_level.s_rank_time:
		return grade.S
	elif elapsed_time <= current_level.a_rank_time:
		return grade.A
	elif elapsed_time <= current_level.b_rank_time:
		return grade.B
	elif elapsed_time <= current_level.c_rank_time:
		return grade.C
	else:
		return grade.D
		
func get_score_grade():
	if current_score >= current_level.s_rank_score:
		return grade.S
	elif current_score >= current_level.a_rank_score:
		return grade.A
	elif current_score >= current_level.b_rank_score:
		return grade.B
	elif current_score >= current_level.c_rank_score:
		return grade.C
	else:
		return grade.D

func get_hits_grade():
	if current_hits <= current_level.s_rank_hits:
		return grade.S
	elif current_hits <= current_level.a_rank_hits:
		return grade.A
	elif current_hits <= current_level.b_rank_hits:
		return grade.B
	elif current_hits <= current_level.c_rank_hits:
		return grade.C
	else:
		return grade.D
		
func get_final_grade():
	var total = 0
	total += get_hits_grade()
	total += get_score_grade()
	total += get_time_grade()
	
	if total == 15:
		return grade.SSS
	elif total >= 13:
		return grade.S
	elif total >= 10:
		return grade.A
	elif total >= 8:
		return grade.B
	elif total >= 5:
		return grade.C
	else:
		return grade.D
		
	
	pass
#endregion
