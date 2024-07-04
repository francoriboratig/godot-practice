extends CharacterBody3D

# Emmited when a player jumps on the mob
signal squashed

# Minimum speed of the mob in meters per second.
@export var min_speed = 10

# Maximum speed of the mob in meters per second.
@export var max_speed = 18

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	move_and_slide()

# This function will be called from the main scene
func initialize(start_position, player_position):
	# We position the mob by placing it in start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position,player_position,Vector3.UP)
	# Rotate this mob randomly within range of -45 and +45 degrees,
	# so that it doesn't move directly towards the player.
	rotate_y(randf_range(- PI / 4,PI / 4))
	
	# We calculate a random speed (integer)
	var random_speed = randi_range(min_speed, max_speed)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	$AnimationPlayer.speed_scale = random_speed/min_speed

func squash():
	squashed.emit()
	queue_free()

func _on_visible_on_screen_enabler_3d_screen_exited():
	# Despawn this mob instance
	queue_free()
