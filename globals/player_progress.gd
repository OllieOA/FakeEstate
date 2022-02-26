extends Node
# class_name PlayerProgress (AutoLoaded)


var deck = []

func _ready() -> void:
	# Generate initial deck
	
	for _i in range(3):
		deck.append(CardProperties.Type.COAX)
	for _i in range(3):
		deck.append(CardProperties.Type.SPECULATE)
	for _i in range(3):
		deck.append(CardProperties.Type.EXCITE)
	deck.append(CardProperties.Type.FORCE)
