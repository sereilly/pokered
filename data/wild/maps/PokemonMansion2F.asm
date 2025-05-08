PokemonMansion2FWildMons:
	def_grass_wildmons 10 ; encounter rate
IF DEF(_RED)
	db 32, GROWLITHE
	db 34, KOFFING
	db 34, KOFFING
	db 30, PONYTA
	db 30, KOFFING
	db 32, PONYTA
	db 30, GRIMER
	db 28, PONYTA
	db 39, WEEZING
	db 37, MUK
ENDC
IF DEF(_BLUE)
	db 32, VULPIX
	db 34, GRIMER
	db 34, GRIMER
	db 30, PONYTA
	db 30, GRIMER
	db 32, PONYTA
	db 30, KOFFING
	db 28, PONYTA
	db 39, MUK
	db 37, WEEZING
ENDC
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons

PokemonMansion2FWildMons0:
	def_grass_wildmons 10 ; encounter rate
IF DEF(_RED)
	db 6, GROWLITHE
	db 7, KOFFING
	db 5, KOFFING
	db 6, PONYTA
	db 4, KOFFING
	db 5, PONYTA
	db 6, GRIMER
	db 3, PONYTA
	db 8, KOFFING
	db 8, GRIMER
ENDC
IF DEF(_BLUE)
	db 6, VULPIX
	db 7, GRIMER
	db 5, GRIMER
	db 6, PONYTA
	db 4, GRIMER
	db 5, PONYTA
	db 6, KOFFING
	db 3, PONYTA
	db 8, GRIMER
	db 8, KOFFING
ENDC
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
