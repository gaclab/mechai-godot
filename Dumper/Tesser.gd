@tool
extends Sprite2D
var tween :Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	print(tween!=null)
	tween = create_tween()
	tween.connect("finished",Callable(self,"done"))
	tween.tween_property(self,"position",Vector2(500,500),1)
	tween.play()

func done():
	tween = create_tween()
	tween.connect("finished",Callable(self,"done"))
	tween.tween_property(self,"position",Vector2(0,0),1)
	tween.play()
