extends Area2D

var speed: float
var damage: float
@onready var timer: Timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D

func setup(data: BulletResource):
	speed = data.speed
	damage = data.damage
	sprite_2d.texture = data.sprite
	timer.wait_time = data.lifetime
	timer.start()
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_timer_timeout() -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
