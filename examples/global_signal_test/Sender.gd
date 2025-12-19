# Sender.gd
extends Node

func _input(event):
	# 키보드 스페이스바를 누르면 신호 발송
	if event.is_action_pressed("ui_accept"):
		print("신호 발송 시작...")
		US.GlobalEvent.EmitSignal("TEST_SIGNAL", ["안녕하세요", 777])
