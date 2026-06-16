extends Resource

class_name LevelResource

@export var level_number: int
@export var level_id: String
@export var level_name: String

@export var level: PackedScene

@export_group("Time Rank Thresholds")
@export var s_rank_time: float
@export var a_rank_time: float
@export var b_rank_time: float
@export var c_rank_time: float

@export_group("Score Rank Thresholds")
@export var s_rank_score: int
@export var a_rank_score: int
@export var b_rank_score: int
@export var c_rank_score: int

@export_group("Hit Rank Thresholds")
@export var s_rank_hits: int
@export var a_rank_hits: int
@export var b_rank_hits: int
@export var c_rank_hits: int
