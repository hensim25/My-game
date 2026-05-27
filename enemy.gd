extends CharacterBody2D

@onready var player: CharacterBody2D 

@export var speed: float = 100.0
@export var walk_time: float = 2.0

var direction: int = -1
var timer: float = 0.0

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	timer += delta
	if timer >= walk_time:
		direction *= -1
		timer = 0.0

	if sprite:
		if direction > 0:
			sprite.flip_h = false 
		else:
			sprite.flip_h = true 

	velocity.x = direction * speed
	move_and_slide()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Calculate the height difference
		var y_delta = position.y - body.position.y
		var x_delta = body.position.x - position.x
		
		if y_delta > 30:
			print("destroy enemy")
			queue_free()
			if body.has_method("jump"):
				body.jump()
		else:
			print("decrease player health")
			var game_manager = get_tree().current_scene.find_child("GameManager", true, false)
			if game_manager and game_manager.has_method("decrease_health"):
				game_manager.decrease_health()
				if (x_delta > 0):
					body.jump_slide(500)
				else:
					body.jump_slide(-500)
					
			
