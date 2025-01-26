extends Spatial

signal moved

var _tween = null

var _degrees = {
	Vector3(-1, 0, 0): 270,
	Vector3(1, 0, 0): 90,
	Vector3(0, 0, -1): 180,
	Vector3(0, 0, 1): 0,
}

func strafe_left():
	var relative_translation = Vector3()
	
	 # Normalize the rotation to the range [0, 360)
	$"%Player".rotation_degrees.y -= 360 if $"%Player".rotation_degrees.y > 360 else 0
	$"%Player".rotation_degrees.y += 360 if $"%Player".rotation_degrees.y < 0 else 0
	var normalized_rotation = int($"%Player".rotation_degrees.y) % 360
	
	# Determine the forward vector based on the rotation
	match normalized_rotation:
		270:
			relative_translation = Vector3(0, 0, 1)  # Forward
		0:
			relative_translation = Vector3(1, 0, 0)   # Right
		90:
			relative_translation = Vector3(0, 0, -1)   # Backward
		180:
			relative_translation = Vector3(-1, 0, 0)  # Left
	
	move_towards(relative_translation)
	
func strafe_right():
	var relative_translation = Vector3()
	
	 # Normalize the rotation to the range [0, 360)
	$"%Player".rotation_degrees.y -= 360 if $"%Player".rotation_degrees.y > 360 else 0
	$"%Player".rotation_degrees.y += 360 if $"%Player".rotation_degrees.y < 0 else 0
	var normalized_rotation = int($"%Player".rotation_degrees.y) % 360
	
	# Determine the forward vector based on the rotation
	match normalized_rotation:
		90:
			relative_translation = Vector3(0, 0, 1)  # Forward
		180:
			relative_translation = Vector3(1, 0, 0)   # Right
		270:
			relative_translation = Vector3(0, 0, -1)   # Backward
		0:
			relative_translation = Vector3(-1, 0, 0)  # Left
	
	move_towards(relative_translation)

func move_forward():
	var relative_translation = Vector3()
	
	 # Normalize the rotation to the range [0, 360)
	$"%Player".rotation_degrees.y -= 360 if $"%Player".rotation_degrees.y > 360 else 0
	$"%Player".rotation_degrees.y += 360 if $"%Player".rotation_degrees.y < 0 else 0
	var normalized_rotation = int($"%Player".rotation_degrees.y) % 360
	
	# Determine the forward vector based on the rotation
	match normalized_rotation:
		0:
			relative_translation = Vector3(0, 0, 1)  # Forward
		90:
			relative_translation = Vector3(1, 0, 0)   # Right
		180:
			relative_translation = Vector3(0, 0, -1)   # Backward
		270:
			relative_translation = Vector3(-1, 0, 0)  # Left
	
	move_towards(relative_translation)

func rotate_left():
	if _tween != null and _tween.is_running():
		return false
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "rotation_degrees", Vector3(0, 90, 0), 0.5).as_relative()

func rotate_right():
	if _tween != null and _tween.is_running():
		return false
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "rotation_degrees", Vector3(0, -90, 0), 0.5).as_relative()

func move_towards(relative_translation):
	if _tween != null and _tween.is_running():
		return false
	if _is_group_member_at("walls", translation + relative_translation):
		return false
	var y_translation = Vector3(0, 0, 0)
	if _is_group_member_at("siege_towers", translation - Vector3(0, 1, 0)):
		var siege_tower = _get_group_member_at("siege_towers", translation - Vector3(0, 1, 0))
		if (
			_degrees[relative_translation] != siege_tower.rotation_degrees.y and 
			_degrees[-relative_translation] != siege_tower.rotation_degrees.y
		):
			return false
		if _degrees[-relative_translation] == siege_tower.rotation_degrees.y:
			y_translation.y -= 1
	elif translation.y == 0.5:
		var stairs = _get_group_member_at("stairs", translation - Vector3(0, 0.5, 0))
		if stairs:
			if _degrees[relative_translation] == stairs.rotation_degrees.y: 
				y_translation.y -= 0.5
			elif _degrees[-relative_translation] == stairs.rotation_degrees.y:
				y_translation.y += 0.5
			else:
				return false
	elif translation.y == 1:
#		if (
#			not _is_group_member_at("walls", translation + relative_translation - Vector3(0, 1, 0)) and 
#			not _is_group_member_at("doors", translation + relative_translation - Vector3(0, 1, 0)) and 
#			not _is_group_member_at("siege_towers", translation + relative_translation - Vector3(0, 1, 0)) and
#			not _is_group_member_at("stairs", translation + relative_translation - Vector3(0, 1, 0))
#		):
#			return false
		var siege_tower = _get_group_member_at("siege_towers", translation + relative_translation - Vector3(0, 1, 0))
		if (
			siege_tower and
			_degrees[relative_translation] != siege_tower.rotation_degrees.y and 
			_degrees[-relative_translation] != siege_tower.rotation_degrees.y
		):
			return false
		var stairs = _get_group_member_at("stairs", translation + relative_translation - Vector3(0, 1, 0))
		if stairs:
			if (
				_degrees[relative_translation] != stairs.rotation_degrees.y and 
				_degrees[-relative_translation] != stairs.rotation_degrees.y
			):
				return false
			y_translation.y -= 0.5
	if _is_group_member_at("doors", translation + relative_translation):
		if not _is_group_member_at("rams", translation):
			return false
		_get_group_member_at("doors", translation + relative_translation).hide()
	if _is_group_member_at("rams", translation + relative_translation):
		var ram = _get_group_member_at("rams", translation + relative_translation)
		var moved = ram.move_towards(relative_translation)
		if not moved:
			return false
	if _is_group_member_at("siege_towers", translation + relative_translation):
		if _is_group_member_at("rams", translation):
			return false
		var siege_tower = _get_group_member_at("siege_towers", translation + relative_translation)
		var moved = siege_tower.move_towards(relative_translation)
		if not moved:
			if (
				not _is_group_member_at("walls", translation + 2 * relative_translation) or
				(_degrees[relative_translation] != siege_tower.rotation_degrees.y and 
				_degrees[-relative_translation] != siege_tower.rotation_degrees.y)
			):
				return false
			y_translation.y += 1
	if _is_group_member_at("stairs", translation + relative_translation):
		var stairs = _get_group_member_at("stairs", translation + relative_translation)
		if stairs:
			if _degrees[-relative_translation] == stairs.rotation_degrees.y:
				y_translation.y += 0.5
			else:
				return false
	if has_node("Husky/AnimationPlayer"):
		$"Husky/AnimationPlayer".play("Walk", -1, 2)
	rotation_degrees.y = _degrees[Vector3(relative_translation.x, 0, relative_translation.z)]
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "translation", relative_translation + y_translation, 0.5).as_relative()
	_tween.tween_callback(self, "_moved")
	return true

func _moved():
	emit_signal("moved")
	if $"%Player".has_node("Husky/AnimationPlayer"):
		$"%Player/Husky/AnimationPlayer".play("Idle")

func _get_group_member_at(group, translation):
	for member in get_tree().get_nodes_in_group(group):
		if member.translation == translation:
			return member if member.visible or group != "doors" else null
	return null

func _is_group_member_at(group, translation):
	return _get_group_member_at(group, translation) != null
