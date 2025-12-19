extends Node

class _GlobalEvent:
	var _subscribers: Dictionary = {}

	func ConnectSignal(event_name: String, callable: Callable):
		if not callable.is_valid(): return
		if not _subscribers.has(event_name): _subscribers[event_name] = []
		if callable not in _subscribers[event_name]: _subscribers[event_name].append(callable)

	func EmitSignal(event_name: String, var_args: Variant):
		if not _subscribers.has(event_name): return
		var list = _subscribers[event_name]
		for callable in list:
			if callable.is_valid(): callable.callv(var_args)
			else: list.erase(callable)

class _Random:
	func RangeI(min_val: Variant, max_val: Variant) -> int:
		var mn = int(min_val)
		var mx = int(max_val)
		if mn >= mx: return mn
		return randi_range(mn, mx - 1)

	func RangeF(min_val: Variant, max_val: Variant) -> float:
		return randf_range(float(min_val), float(max_val))

	func Value() -> float:
		return randf()

var GlobalEvent: _GlobalEvent = _GlobalEvent.new()
var Random: _Random = _Random.new()

func Invoke(callable: Callable, delay: Variant):
	var f_delay = float(delay)
	if f_delay <= 0:
		callable.call()
		return
	get_tree().create_timer(f_delay).timeout.connect(callable, CONNECT_ONE_SHOT)

func Instantiate(scene: PackedScene, pos: Variant = null, parent: Node = null) -> Node:
	var instance = scene.instantiate()
	var target_parent = parent if parent != null else get_tree().current_scene
	target_parent.add_child(instance)
	if pos != null:
		if instance is Node2D or instance is Control or instance is Node3D:
			instance.global_position = pos
	return instance

func Destroy(node: Variant, delay: float = 0.0):
	if not is_instance_valid(node) or not node is Node:
		return
	
	if delay <= 0:
		node.queue_free()
	else:
		get_tree().create_timer(delay).timeout.connect(node.queue_free)

func _ready():
	randomize()
