extends Node2D

onready var marcador = get_node("Marcador")

var percentual = 1

signal gameover

func _ready():
	set_process(true)
	
func _process(delta):
	if percentual > 0:
		percentual -= 0.1*delta
		marcador.set_region_rect(Rect2(0, 0, percentual*188, 23))
		marcador.set_pos(Vector2(-(1-percentual)*188/2, 0))
	
	else:
		emit_signal("gameover")
		
func addTime(delta):
	percentual += delta
	if percentual > 1: percentual = 1