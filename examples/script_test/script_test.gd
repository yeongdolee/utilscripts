extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var randomiNum = US.Random.RangeI(1, 5)
	print(randomiNum)
	var randomfNum = US.Random.RangeF(1.2, 5.4)
	print(randomfNum)
	var randomvNum = US.Random.Value()
	print(randomvNum)
	US.Invoke(printAnything, 2.4)

func printAnything():
	print("printAnything was Called!")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
