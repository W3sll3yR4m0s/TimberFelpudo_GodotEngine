extends Node2D

func _ready():
	pass
	
func destruir(sent):
	if sent == -1:
		get_node("AnimBarril").play("direita")
	else:
		get_node("AnimBarril").play("esquerda")
