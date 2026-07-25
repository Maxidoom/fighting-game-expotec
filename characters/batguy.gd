extends CharacterBody2D
const SPEED=250
const JUMP_VELOCITY= -450
const CROUCH_FREEZE = 0.05
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_crouching = false

var standing_cshape = preload("res://resources/bg_standing_cshape.tres")
var crouching_cshape = preload("res://resources/bg_crouch_cshape.tres")
func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y +=gravity*delta
		$batGuyAnimation.play("jump")
		$batGuyAnimation.speed_scale = 0
	if Input.is_action_just_pressed("jump") and is_on_floor() and is_crouching==false:
		velocity.y =JUMP_VELOCITY
		
	if Input.is_action_just_pressed("crouch"):
		crouch()
	elif Input.is_action_just_released("crouch"):
		stand()
	if Input.is_action_just_pressed("5_LP") :
		$batGuyAnimation.play("5_LP")
	var direction = Input.get_axis("left","right")
	if direction and is_crouching == false:
		velocity.x = direction * SPEED
		if is_on_floor() and direction > 0:
			$batGuyAnimation.play("walk")
			$batGuyAnimation.speed_scale = 1
		elif  is_on_floor() and direction < 0:
			$batGuyAnimation.play("walk_backwards")
			$batGuyAnimation.speed_scale = 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and is_crouching == false:
			$batGuyAnimation.speed_scale = 1.0
			$batGuyAnimation.play("idle")
		if is_crouching and is_on_floor():
			$batGuyAnimation.play("crouch")
			$batGuyAnimation.speed_scale = 1.0
			if is_crouching and $batGuyAnimation.current_animation_position >= CROUCH_FREEZE:
				$batGuyAnimation.speed_scale = 0
			if Input.is_action_just_released("crouch"):
				$batGuyAnimation.speed_scale = 1
	move_and_slide()
	
func crouch():
	if is_crouching:
		return
	is_crouching = true
	$CollisionShape2D.shape = crouching_cshape
	$CollisionShape2D.position.y = 65
func stand():
	if not is_crouching:
		return
	is_crouching = false
	$CollisionShape2D.shape = standing_cshape
	$CollisionShape2D.position.y = 45
