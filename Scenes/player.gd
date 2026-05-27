extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Track player living status
var is_dead: bool = false

func jump():
	if not is_dead: # Prevent jumping if dead
		velocity.y = JUMP_VELOCITY

func jump_slide(x):
	velocity.y = JUMP_VELOCITY
	velocity.x = x


# Call this function when the player loses all health
func die():
	if is_dead: return # Prevent triggering death multiple times
	is_dead = true
	velocity = Vector2.ZERO # Stop movement instantly
	animated_sprite.play("Death")
	
	# Optional: Disable collision so enemies ignore the dead player
	# set_collision_layer_value(1, false) 

func _physics_process(delta: float) -> void:
	# 1. If dead, just apply gravity and skip input handling
	if is_dead:
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return # Exits the function early so animations/movement don't get overridden

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move left", "move right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
