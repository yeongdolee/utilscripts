# Receiver.gd
extends Node

func _ready():
	# "TEST_SIGNAL"이라는 이름의 신호를 기다림
	US.GlobalEvent.ConnectSignal("TEST_SIGNAL", Callable(self, "_on_test_signal"))

func _on_test_signal(msg: Variant, value: Variant):
	print("신호 수신 성공!")
	print("메시지: ", msg)
	print("숫자: ", value)
