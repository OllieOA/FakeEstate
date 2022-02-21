extends MarginContainer


export (Resource) onready var card_properties = card_properties as CardProperties
export (CardProperties.Type) var card_type

onready var card_attributes = card_properties.card_database[card_type]
export (NodePath) onready var border_texture = get_node(border_texture) as NinePatchRect 


func _ready() -> void:
	print(card_attributes)
