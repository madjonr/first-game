extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1
var do_jump = false
var _is_on_floor = false

@export var player_id:int = 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)


func _apply_animations(delta):
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")


func _apply_movement_from_input(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if do_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction = %InputSynchronizer.input_direction
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _physics_process(delta):
	# 这里其实是不信任任何客户端的操作，客户端只是将鼠标键盘的动作同步到服务端，
	# 服务端（验证输入的有效性后）将动作同步回客户端，客户端再来显示所有移动效果。
	# 所以这里就是要判断is_server的原因
	if multiplayer.is_server():
		_apply_movement_from_input(delta)
	_apply_animations(delta)
