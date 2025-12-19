extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	US.GlobalEvent.ConnectSignal("TEST_SIGNAL", Callable(when_testsignal_called))

func when_testsignal_called(msg, num):
	print("TEST_SIGNAL was Called!")
