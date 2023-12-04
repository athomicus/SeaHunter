extends Node

const SoundScript = preload("res://SCRIPTS/sound.gd")

func play_sound(sound):
	
	
	var audio_stream_player = AudioStreamPlayer.new()

	audio_stream_player.set_script(SoundScript) #dodaj do obiektu dźwięku skrypt[usuwa obiekt po skonczeniu]
	audio_stream_player.stream = sound #dodaj plik dźwiękowy
	add_child(audio_stream_player) #umieść go w Scenie
	audio_stream_player.play()    #zagraj dźwięk
