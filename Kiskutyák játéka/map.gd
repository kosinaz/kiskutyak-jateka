extends Spatial

var moving = false

func _process(_delta):
	moving = false
	if Input.is_action_pressed("ui_left"):
		$"%Player".strafe_left()
		moving = true
		return
	if Input.is_action_pressed("ui_right"):
		$"%Player".strafe_right()
		moving = true
		return
	if Input.is_action_pressed("ui_up"):
		$"%Player".move_forward()
		moving = true
		return
	if Input.is_action_pressed("p2_left"):
		$"%Player2".strafe_left()
		moving = true
		return
	if Input.is_action_pressed("p2_right"):
		$"%Player2".strafe_right()
		moving = true
		return
	if Input.is_action_pressed("p2_forward"):
		$"%Player2".move_forward()
		moving = true
		return

