extends Spatial

var moving = false

func _process(_delta):
	$Camera.translation.x = $"%Player".translation.x
	$Camera.translation.z = $"%Player".translation.z + 2
	$Camera.translation.y = $"%Player".translation.y + 0.5
	moving = false
	if Input.is_action_pressed("ui_left"):
		$"%Player".move_towards(Vector3(-1, 0, 0))
		moving = true
		return
	if Input.is_action_pressed("ui_right"):
		$"%Player".move_towards(Vector3(1, 0, 0))
		moving = true
		return
	if Input.is_action_pressed("ui_up"):
		$"%Player".move_towards(Vector3(0, 0, -1))
		moving = true
		return
	if Input.is_action_pressed("ui_down"):
		$"%Player".move_towards(Vector3(0, 0, 1))
		moving = true
		return

