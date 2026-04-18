extends Area2D

@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float
@export var damage: float
@export var lifetime: float
@export var bullet_count: int
@export var bullet_spread: float


func _ready() -> void:
	timer.start()
	
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_timer_timeout() -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
