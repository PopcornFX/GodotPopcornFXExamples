extends Node3D


@onready var track_low: StaticBody3D = $TrackLow
@onready var track_mid: StaticBody3D = $TrackMid
@onready var track_high: StaticBody3D = $TrackHigh
@onready var microphone: StaticBody3D = $Microphone

@onready var low: AudioStreamPlayer3D = $Low
@onready var mid: AudioStreamPlayer3D = $Mid
@onready var high: AudioStreamPlayer3D = $High
@onready var mic: AudioStreamPlayer = $Mic

@onready var music_bus_volume_db := AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"SoundSamplerDemo"))
func _ready() -> void:
	track_low.activated.connect(
		func ():
			set_bus_volume(music_bus_volume_db)
			microphone.active = false
			low.volume_linear = 1.3
	)
	track_low.deactivated.connect(
		func ():
			low.volume_linear = 0.0
	)
	
	track_mid.activated.connect(
		func ():
			set_bus_volume(music_bus_volume_db)
			microphone.active = false
			mid.volume_linear = 0.1
	)
	track_mid.deactivated.connect(
		func ():
			mid.volume_linear = 0.0
	)
	
	track_high.activated.connect(
		func ():
			set_bus_volume(music_bus_volume_db)
			microphone.active = false
			high.volume_linear = 0.1
	)
	track_high.deactivated.connect(
		func ():
			high.volume_linear = 0.0
	)

	microphone.activated.connect(
		func ():
			set_bus_volume(-80.0)
			track_low.active = false
			track_mid.active = false
			track_high.active = false
			mic.volume_linear = 1.0
	)
	microphone.deactivated.connect(
		func ():
			set_bus_volume(music_bus_volume_db)
			mic.volume_linear = 0.0
	)

func set_bus_volume(v_db: float):
	var bus_idx := AudioServer.get_bus_index(&"SoundSamplerDemo")
	AudioServer.set_bus_volume_db(bus_idx, v_db)
	
