extends Node

var saved_values = {}

func set_value(key: String, value) -> void:
	saved_values[key] = value

func get_value(key: String, default_value = null):
	return saved_values.get(key, default_value)
