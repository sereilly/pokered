IF DEF(_RED)
DefaultNamesPlayer:
	db   "NEW NAME"
	next "RED"
	next "ASH"
	next "JACK"
	db   "@"

DefaultNamesRival:
	db   "NEW NAME"
	next "BLUE"
	next "GARY"
	next "JOHN"
	db   "@"
ENDC

IF DEF(_BLUE)
DefaultNamesPlayer:
	db   "NEW NAME"
	next "BLUE"
	next "GARY"
	next "JOHN"
	db   "@"

DefaultNamesRival:
	db   "NEW NAME"
	next "RED"
	next "ASH"
	next "JACK"
	db   "@"
ENDC

TownNames1:
	db   "PALETTE"
	next "PEWTER"
	next "CERULEAN"
	next "VERMILION"
	next "MORE..."
	db   "@"

TownNames2:
	db   "CELADON"
	next "SAFFRON"
	next "FUCHSIA"
	next "CINNABAR"
	next "VIRIDIAN"
	db   "@"