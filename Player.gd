extends Area2D

### Signals

# Emitted when player collides with an enemy
signal hit

### Member variables

# How fast the player will move
export var speed = 400

# Size of the game window
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Player's movement vector
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	# Prevent the player from leaving the screen ("clamping" means restricting
	# to a certain range).
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	# Update the animation
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	# Hide body when hit
	hide()
	
	emit_signal("hit")
	
	# Disabling player's collision to avoid emitting duplicate signals
	# set_deferred is used to defer changing the setting until it is safe to
	# do so
	$CollisionShape2D.set_deferred("disabled", true)

# Function to reset player when starting a new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
