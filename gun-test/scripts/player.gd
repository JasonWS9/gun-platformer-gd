extends CharacterBody2D

var gun_force: float
@export var gravity: float
@export var air_resist: float
@export var max_speed: float
@onready var gunpivot: Marker2D = $gunpivot
@onready var firepoint: Marker2D = $gunpivot/gun_sprite/firepoint


@export var inventory: Array[GunResource] = []
var current_gun: GunResource
var current_index: int = 0

@onready var gun_sprite: AnimatedSprite2D = $gunpivot/gun_sprite
@onready var shoottimer: Timer = $shoottimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	swap_gun(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
		animated_sprite_2d.play("glide")
	elif abs(velocity.x) < 0.3 and abs(velocity.y) < 0.3:
			animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("walk")

	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	
	var mousePosition = get_global_mouse_position()
	var lookdirection = mousePosition - global_position
	gunpivot.rotation = lookdirection.angle()
	if abs(gunpivot.rotation_degrees) > 90 and abs(gunpivot.rotation_degrees) < 270:
		gun_sprite.flip_v = true
		print_debug("flip gun")
	else:
		gun_sprite.flip_v = false
	
	if current_gun.is_holdable:		
		if Input.is_action_pressed("shoot"):
			if shoottimer.is_stopped():
				fire_gun(lookdirection.normalized())
	else: 
		if Input.is_action_just_pressed("shoot"):
			if shoottimer.is_stopped():
				fire_gun(lookdirection.normalized())
	velocity.x *= air_resist
	
	if Input.is_action_just_pressed("next_weapon"):
		swap_gun((current_index + 1) % inventory.size())

	if Input.is_action_just_pressed("prev_weapon"):
		swap_gun((current_index - 1 + inventory.size()) % inventory.size())

	move_and_slide()
	
func fire_gun(direction: Vector2):
	
	velocity = -direction * gun_force
	shoottimer.start()
	print_debug("firing: " + current_gun.name)
	
	if is_on_floor():
		animated_sprite_2d.play("launch")
		
	gun_sprite.play("shoot")

	var bullet = current_gun.bullet_scene.instantiate()
	get_parent().add_child(bullet)
	
	bullet.rotation = direction.angle()
	bullet.global_position = firepoint.global_position
	
func swap_gun(index: int):
	#print_debug("swapping to: " + current_gun.name)
	current_index = index
	current_gun = inventory[index]
	gun_sprite.sprite_frames = current_gun.sprite_frames
	gun_sprite.play("reload")
	gun_force = current_gun.force
	shoottimer.wait_time = current_gun.cooldown
