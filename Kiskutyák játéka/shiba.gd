extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Shiba Inu/AnimationPlayer".play("AnimalArmature|Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$"Shiba Inu/AnimationPlayer".play("AnimalArmature|Idle")
