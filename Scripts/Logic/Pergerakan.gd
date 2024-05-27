extends Path2D
var moving = false
@export var target_yang_dipindahkan : Node2D
@export var kecepatan = 1.0
signal move_finished(last_pos:Vector2i)

func initpath():
	moving = true

func repath(path_trails : PackedVector2Array):
	curve.clear_points()
	for k in path_trails:
		curve.add_point(k)
	$Pathline.points = path_trails

# Called when the node enters the scene tree for the first time.
func stand_still(pos:Vector2i):
	$Jejak.position = pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		if $Jejak.progress_ratio != 1:
			$Jejak.progress += 1*kecepatan
			target_yang_dipindahkan.position = $Jejak.position
			target_yang_dipindahkan.rotation_degrees = $Jejak.rotation_degrees + 90
		else:
			curve.clear_points()
			$Pathline.clear_points()
			move_finished.emit($Jejak.position)
			$Jejak.progress = 0
			moving = false

func posisikan_indikator(posisi:Vector2):
	$Indikator.position = posisi
