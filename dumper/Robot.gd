class_name Robot
extends AnimatedSprite2D
var tujuan = Vector2(0,0)
@export var kecepatan_berjalan = 1.0
# Called when the node enters the scene tree for the first time.

func _process(delta):
	if position.x > tujuan.x:
		flip_h = true
	elif position.x < tujuan.x:
		flip_h = false

	if position != tujuan:
		position -= Vector2(max(-kecepatan_berjalan, min(position.x-tujuan.x, kecepatan_berjalan)),max(-kecepatan_berjalan, min(position.y-tujuan.y, kecepatan_berjalan)))
		animation = "walk"
	else:
		animation = "idle"
