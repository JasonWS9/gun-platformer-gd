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
	velocity.x *= air_resist
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	print_debug(velocity)

	if not is_on_floor():
		velocity.y += gravity * delta
		animated_sprite_2d.play("glide")
	elif abs(velocity.x) < 0.5 and abs(velocity.y) < 0.5:
			animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("walk")

	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false

#region Gun Stuff	
	var mousePosition = get_global_mouse_position()
	var lookdirection = mousePosition - global_position
	gunpivot.rotation = lookdirection.angle()
	if abs(gunpivot.rotation_degrees) > 90 and abs(gunpivot.rotation_degrees) < 270:
		gun_sprite.flip_v = true
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
	
	if Input.is_action_just_pressed("next_weapon"):
		swap_gun((current_index + 1) % inventory.size())

	if Input.is_action_just_pressed("prev_weapon"):
		swap_gun((current_index - 1 + inventory.size()) % inventory.size())
#endregion

	move_and_slide()
			
func fire_gun(direction: Vector2):
#region Calculating Force
	# Measures current speed in the direction we are shooting
	# Used to calculate how much "stopping power" is needed to cancel momentum.
	var speed_in_dir = velocity.dot(direction)	
	#print_debug("Speed in Dir: " + str(speed_in_dir))
	var brake_force = max(0, speed_in_dir * 0.8)
	
	# Measures alignment of move direction and firing direction, ignoring speed (-1.0 to 1.0)
	# 1.0 = Shooting with movement (Braking), -1.0 = Shooting opposite (Boosting).
	var dot = velocity.normalized().dot(direction)

	var force_multiplier: float
	if dot > 0.5:
		force_multiplier = 1.5
	elif dot < -0.5:
		force_multiplier = 0.75
	else:
		force_multiplier = 1
		
	var final_force: Vector2 = -direction * (gun_force + brake_force)
	print_debug("Braking Force: " + str(brake_force))
	#print_debug("Force Mult: " + str(force_multiplier))
#endregion
#region Firing Weapon
	velocity += final_force
	shoottimer.start()
	print_debug("firing: " + current_gun.name)
	
	if is_on_floor():
		animated_sprite_2d.play("launch")
		
	gun_sprite.play("shoot")

	var bullet = current_gun.bullet_scene.instantiate()
	get_parent().add_child(bullet)
	
	bullet.rotation = direction.angle()
	bullet.global_position = firepoint.global_position		
#endregion
func swap_gun(index: int):
	#print_debug("swapping to: " + current_gun.name)
	current_index = index
	current_gun = inventory[index]
	gun_sprite.sprite_frames = current_gun.sprite_frames
	gun_sprite.play("reload")
	gun_force = current_gun.force
	shoottimer.wait_time = current_gun.cooldown
