extends Node2D

var barril = preload("res://scenes/barril.tscn")
var barrilEsq = preload("res://scenes/barrilEsq.tscn")
var barrilDir = preload("res://scenes/barrilDir.tscn")

onready var felpudo = get_node("Felpudo")
onready var camera = get_node("Camera")
onready var barris = get_node("Barris")
onready var destruirBarris = get_node("DestruirBarris")
onready var barraDeTempo = get_node("BarraDeTempo")

onready var labelPontos = get_node("Control/Pontos")

var ultimoInimigo

var pontos = 0

var estado = JOGANDO

const JOGANDO = 1
const PERDEU = 2

var encerraMovimentos = false

func _ready():
	randomize()
	set_process_input(true)
	
	gerarBarrisIniciais()
	
	barraDeTempo.connect("gameover", self, "perder")
	
func _input(event):
	event = camera.make_input_local(event)
	if event.type == InputEvent.SCREEN_TOUCH and event.pressed and estado == JOGANDO:
		
		if event.pos.x < 360 and !encerraMovimentos:
			felpudo.esq()
		elif event.pos.x > 360 and !encerraMovimentos:
			felpudo.dir()
			
		if !verifica() and !encerraMovimentos:
			felpudo.bater()
			var primeiroBarril = barris.get_children()[0]
			barris.remove_child(primeiroBarril)
			destruirBarris.add_child(primeiroBarril)
			primeiroBarril.destruir(felpudo.lado)
			
			aleatorizarBarril(Vector2(360, 1090 - 10*172))
			descerBarris()
			barraDeTempo.addTime(0.014)
			
			pontos += 1
			labelPontos.set_text(str(pontos))
			
			if verifica():
				perder()
	
		else:
			perder()
		
func aleatorizarBarril(pos):
	var num = rand_range(0, 3)
	if ultimoInimigo: num = 0
	gerarBarril(int(num), pos)

func gerarBarril(tipo, pos):
	var novo
	if tipo == 0:
		novo = barril.instance()
		ultimoInimigo = false
	elif tipo == 1:
		novo = barrilEsq.instance()
		novo.add_to_group("barrilEsq")
		ultimoInimigo = true
	elif tipo == 2:
		novo = barrilDir.instance()
		novo.add_to_group("barrilDir")
		ultimoInimigo = true
	
	novo.set_pos(pos)
	barris.add_child(novo)

func gerarBarrisIniciais():
	for i in range(0, 3):
		gerarBarril(0, Vector2(360, 1090 - i*172))
		
	for i in range(3, 10):
		aleatorizarBarril(Vector2(360, 1090 - i*172))
		
func verifica():
	var lado = felpudo.lado
	var primeiroBarril = barris.get_children()[0]
	if lado == felpudo.ESQ and primeiroBarril.is_in_group("barrilEsq") or lado == felpudo.DIR and primeiroBarril.is_in_group("barrilDir"):
		return true
	else:
		return false
	
func descerBarris():
	for b in barris.get_children():
		b.set_pos(b.get_pos() + Vector2(0, 172))
		
func perder():
	encerraMovimentos()
	
	felpudo.morrer()
	barraDeTempo.set_process(false)
	estado = PERDEU
	get_node("Timer").start()
	
func encerraMovimentos():
	encerraMovimentos = true

func _on_Timer_timeout():
	get_tree().reload_current_scene()
