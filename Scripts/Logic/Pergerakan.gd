extends Path2D
@export var target_yang_dipindahkan : Node2D
@export var sedang_menggambar = false
@export var kecepatan = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !sedang_menggambar:
		if $Jejak.progress_ratio != 1:
			$Jejak.progress += 1*kecepatan
			target_yang_dipindahkan.position = $Jejak.position
		else:
			var patches : Curve2D = get_curve()
			patches.clear_points()


func pindah_indikator(perpindahan:Vector2):
	$Indikator.position += perpindahan
	tambahkan_titk_jejak()

func posisikan_indikator(posisi:Vector2):
	$Indikator.position = posisi
	tambahkan_titk_jejak()

func tambahkan_titk_jejak():
	if sedang_menggambar:
		var patches : Curve2D = get_curve()
		patches.add_point($Indikator.position)
