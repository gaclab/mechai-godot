extends Path2D
class_name Pathforall


var tween : Tween
var _targeted_object : Robot
#@onready var _path_line : Line2D = $path_line
@onready var _path_follow : PathFollow2D = $path_follow
func initPath(object:Robot,speed:float):
	if curve.point_count > 1 :
		_targeted_object = null
		_path_follow.progress_ratio = 1
		var maxPath = _path_follow.progress
		#print(maxPath)
		_targeted_object = object
		_path_follow.progress_ratio = 0
		tween = create_tween()
		tween.tween_property(_path_follow,"progress_ratio",1,maxPath/speed)
		tween.connect("finished",Callable(self,"done"))
		tween.play()
		

func _process(delta):
	if tween != null:
		if tween.is_running() :
			_targeted_object.position = _path_follow.position
			#_targeted_object.get_node('robot_sprite').rotation_degrees = _path_follow.rotation_degrees + 90

func done():
	if _targeted_object != null :
		curve.clear_points()
		#_path_line.clear_points()
		#_targeted_object.get_node('robot_sprite').rotation_degrees = _path_follow.rotation_degrees + 90
		#_targeted_object = null
		_targeted_object.position = _path_follow.position
		#print(_targeted_object.position)
		_path_follow.progress = 0

func repath(path_trails : PackedVector2Array):
	curve.clear_points()
	for k in path_trails:
		curve.add_point(k)
	#_path_line.points = path_trails

# Called every frame. 'delta' is the elapsed time since the previous frame.
