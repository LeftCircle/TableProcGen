extends RefCounted
class_name ColorIDs

const COLORS = [
	Color('#F8A81A'),
	Color('#f76d86'),
	Color('#ed5833'),
	Color('#61acc9'),
	Color('#10679b')
]

static func get_random_color() -> Color:
	return COLORS[randi() % COLORS.size()]

static func get_random_color_other_than(color : Color) -> Color:
	var new_color = get_random_color()
	while new_color == color:
		new_color = get_random_color()
	return new_color
