extends AudioStreamPlayer2D
class_name SoundEffect


func PlaySound(soundPath, soundVolume = 0, soundPitch = 1):
	stream = load(soundPath)
	volume_db = soundVolume
	pitch_scale = soundPitch
	play()
	await finished
	queue_free()
