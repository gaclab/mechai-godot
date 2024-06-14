extends Path2D
var moving = false
@export var target_yang_dipindahkan : Node2D
@export var kecepatan = 1.0
signal move_finished(last_pos : Node2D)
var tween : Tween

func initpath():
	$Jejak.progress_ratio = 1
	var maxPath = $Jejak.progress
	$Jejak.progress_ratio = 0
	tween = create_tween()
	tween.connect("finished",Callable(self,"done"))
	tween.tween_property($Jejak,"progress_ratio",1,maxPath/kecepatan)
	tween.play()

func repath(path_trails : PackedVector2Array):
	if target_yang_dipindahkan != null:
		curve.clear_points()
		for k in path_trails:
			curve.add_point(k)
		$Pathline.points = path_trails

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tween != null:
		if tween.is_running():
			target_yang_dipindahkan.position = $Jejak.position
			target_yang_dipindahkan.get_node('robot_sprite').rotation_degrees = $Jejak.rotation_degrees + 90

func done():
	curve.clear_points()
	$Pathline.clear_points()
	move_finished.emit(target_yang_dipindahkan)
	target_yang_dipindahkan.position = $Jejak.position
	target_yang_dipindahkan.get_node('robot_sprite').rotation_degrees = $Jejak.rotation_degrees + 90
	target_yang_dipindahkan = null
	$Jejak.progress = 0

func get_posisi_indikator():
	return $Indikator.position

func posisikan_indikator(posisi:Vector2):
	$Indikator.position = posisi
