extends Node2D

@onready var Enemies = [
	preload("res://Scenes/enemy_1.tscn")
	
	
	
	]

@onready var SpawnPoints = [$SpawnPoint1, $SpawnPoint2]

var EnemiesAlive = [] #Array of the enemies currently on the scene

var Wave: int = 0
var EnemiesPerWave: int = 15 #MUST be an EVEN number, as enemies are always spawned in pairs
var EnemiesToSpawn: int = EnemiesPerWave
var TimeBetweenSpawns: float = 3.0 #interval between spawning enemies during a wave
var TimeBetweenWaves: float = 10.0 #interval between waves

func _ready():
	EndWave()


func _process(delta):
	if $CanvasLayer/TimeToNextWave.visible:
		$CanvasLayer/TimeToNextWave.text = "Next wave in " + str(round($between_waves_timer.time_left))
	
	if EnemiesToSpawn <= 0:
		if EnemiesAlive.size() == 0 and $between_waves_timer.time_left == 0:
			EndWave()


func StartNewWave():
	Wave += 1
	$spawn_timer.start(TimeBetweenSpawns)
	EnemiesToSpawn = EnemiesPerWave + 2 #2 is the minimum amount that can be added here, as it must stay even
	
	$CanvasLayer/TimeToNextWave.visible = false
	$CanvasLayer/WaveLabel.visible = true
	$CanvasLayer/WaveLabel.text = "Wave " + str(Wave)
	await get_tree().create_timer(1).timeout #this defines how long the wave number displays on screen
	$CanvasLayer/WaveLabel.visible = false


func EndWave():
	$spawn_timer.stop()
	$between_waves_timer.start(TimeBetweenWaves)
	$CanvasLayer/TimeToNextWave.visible = true
	await $between_waves_timer.timeout
	StartNewWave()


func _on_spawn_timer_timeout():
	if EnemiesToSpawn <= 0:
		return
	
	for i in SpawnPoints:
		EnemiesToSpawn -= 1
		var Enemy = Enemies.pick_random().instantiate()
		Enemy.spawner = self
		EnemiesAlive.append(Enemy)
		get_parent().call_deferred("add_child", Enemy)
		Enemy.global_position = i.global_position
	
	
