extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const MAX_JUMP_COUNT = 2
var jump_count = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

@onready var coyote_timer = $CoyoteTimer
var was_on_floor = false

func _physics_process(delta):
	was_on_floor = is_on_floor()
	
	# Add the gravity and start coyote timer
	if not is_on_floor():
		velocity.y += gravity * delta
		coyote_timer.start()

	# Allow jump only if on floor or the coyote timer is running
	# if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
	if Input.is_action_just_pressed("jump") and jump_count < 1:
		if (is_on_floor() or !coyote_timer.is_stopped()):
			velocity.y = JUMP_VELOCITY
			jump_count += 1

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# Play animations reset jump count
	if is_on_floor():
		jump_count = 0
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
