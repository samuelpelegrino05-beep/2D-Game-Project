extends Node

# Store sounds here
var sounds = {}
var music = {}

var music_player: AudioStreamPlayer

func _ready():
	# Preload your sounds
	sounds["hit"] = preload("res://Hit noise.mp3")
	sounds["bounce"] = preload("res://Bullet bounce.mp3")
	sounds["enemy_death"] = preload("res://enemy death.mp3")
	sounds["player_death"] = preload("res://player_death.mp3")
	music["main_music"] = preload("res://2DGame.mp3")
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Create dedicated music player
	music_player = AudioStreamPlayer.new()
	music_player.bus = "music"  # <-- Assign to Music bus
	add_child(music_player)
	play_music("main_music")

# =========================
# 🎧 SOUND EFFECTS
# =========================
func play(name: String):
	if not sounds.has(name):
		push_warning("Sound not found: " + name)
		return
	
	var player = AudioStreamPlayer.new()
	player.bus = "sfx"   # <-- Assign to SFX bus
	add_child(player)
	player.stream = sounds[name]
	player.play()
	
	player.finished.connect(func(): player.queue_free())

# =========================
# 🎵 MUSIC
# =========================
func play_music(name: String, volume_db: float = -10):
	if not music.has(name):
		push_warning("Music not found: " + name)
		return
	
	# Don't restart if already playing
	if music_player.stream == music[name] and music_player.playing:
		return
	
	music_player.stream = music[name]
	music_player.volume_db = volume_db
	music_player.play()
	music_player.finished.connect(
		func(): music_player.play()  # restart when finished
	)

func stop_music():
	music_player.stop()

func pause_music():
	music_player.stream_paused = true

func resume_music():
	music_player.stream_paused = false
