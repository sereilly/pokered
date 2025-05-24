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
	next "SEAN"
	next "RANDY"
	db   "@"

DefaultNamesRival:
	db   "NEW NAME"
	next "RED"
	next "SEUNG"
	next "LOREN"
	db   "@"
ENDC

TownNames1:
	db   "PALLET"
	next "VIRIDIAN"
	next "PEWTER"
	next "CERULEAN"
	next "MORE..."
	db   "@"

TownNames2:
	db   "VERMILION"
	next "LAVENDER"
	next "CELADON"
	next "SAFFRON"
	next "MORE..."
	db   "@"

TownNames3:
	db   "FUCHSIA"
	next "CINNABAR"
	next "BACK"
	db   "@"