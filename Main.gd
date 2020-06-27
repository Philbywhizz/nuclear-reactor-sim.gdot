extends Node2D
# =[ Main Game Loop ]==============================================================================
# This script is the main game loop
# =================================================================================================

# =[ PROPERTIES: ]=================================================================================

# -[ signals ]-------------------------------------------------------------------------------------
# -[ enums ]---------------------------------------------------------------------------------------
# -[ constants ]-----------------------------------------------------------------------------------
# -[ exported variables ]--------------------------------------------------------------------------
# -[ public variables ]----------------------------------------------------------------------------
var emergency_level = 300					# EV
var emergency_damage = 0					# ED
var emergency_heat = 0						# EH
var emergency_flow = 0						# EF
var primary_level = 120 					# PV
var primary_quality = 1 					# QP
var primary_damage = 0						# PD
var primary_failure = 0 					# PB
var primary_flow = 0						# PF
var primary_heat = 0						# PH
var secondary_level = 120					# SV
var secondary_quality = 1 					# QS
var secondary_damage = 0					# SD
var secondary_failure = 0					# SB
var secondary_flow = 0						# SF
var secondary_heat = 0						# SH
var control_rod_position = 0				# A
var control_rod_position_prev_1 = 0 		# A1
var control_rod_position_prev_2 = 0 		# A2
var reactor_heat = 0						# RH
var reactor_level = 0						# RL
var reactor_temperature = 25				# RT
var reactor_previous_temperature = 25		# T7
var reactor_damage = 0						# RD
var exchange_temperature = 25				# XT
var exchange_previous_temperature = 25		# T8
var exchange_damage = 0 					# TD
var exchange_failure = 0					# TB
var tower_temperature = 25					# CT
var tower_previous_temp = 25				# T9
var generator_damage = 0					# GD
var generator_failure = 0					# GB
var generator_production = 0				# GZ
var kilowatt_average = 0					# KW
var kilowatt_value = 0						# VE
var day_number = 0							# DAY
var previous_day_number = 0 				# D4
var maintenance_days = 0					# MD
var total_damage = 0 						# DMGE
var fuel_remaining = 100					# FL
var total_generation = 0					# TT

# -[ private variables ]---------------------------------------------------------------------------
# -[ onready variables ]---------------------------------------------------------------------------

# =[ METHODS: ]====================================================================================


func _ready() -> void:
	randomize()
	do_maintenance()

	do_status_report()
	dump_report()
	print("=== Calulating... ===")

	# Temp set some settings
	control_rod_position = 50
	emergency_flow = 0
	primary_flow = 0
	secondary_flow = 0
	daily_operations()
	do_status_report()
	dump_report()

	pass


# -[ built in virtual methods ]--------------------------------------------------------------------
# -[ public methods ]------------------------------------------------------------------------------


func do_status_report() -> void:
	day_number += 1
	print("===== STATUS REPORT DAY ", day_number, " =====")

	var warning_count = 0
	print("WARNINGS:")

	if reactor_temperature > 800:
		print(" - Reactor Overheated")
		warning_count += 1
		primary_damage += 1
		emergency_damage += 1
		var damage = 1
		if reactor_temperature > 850:
			damage += 1
			emergency_damage += 1 # extra damage
		if reactor_temperature > 900:
			damage += 1
		if reactor_temperature > 950:
			damage += 2

	if exchange_temperature > 500:
		print(" - Heat Exchange overheated")
		warning_count += 1
		if exchange_temperature > 600:
			exchange_damage += 1
			primary_damage += 1
			secondary_damage += 1

	if generator_production > 2000:
		print(" - Turbine overloaded")
		warning_count += 1
		if generator_production > 2500:
			generator_damage += 1
			secondary_damage += 1

	if tower_temperature > 300:
		print(" - Cooling tower overheated")
		warning_count += 1
		secondary_damage += 1

	if generator_production < 1000 and day_number - previous_day_number > 8:
		print(" - Power output low")
		warning_count += 1

	if emergency_level < 200:
		print(" - Emergency coolant low")
		warning_count += 1

	if primary_level < 100:
		print(" - Primary coolant low")
		warning_count += 1
		primary_damage += 1

	if secondary_level < 100:
		print(" - Secondary coolant low")
		warning_count += 1
		secondary_damage += 1

	if warning_count == 0:
		print(" - None")

	# DAMAGE
	var damage_count = 0
	print("DAMAGE:")

	if reactor_damage > 3:
		print(" - Reactor core damaged")
		damage_count += 1

	if primary_damage >= 5:
		print(" - Primary coolant leak: ", primary_damage, " / Day")
		damage_count += 1
		primary_level -= primary_damage

	if secondary_damage >= 5:
		print(" - Secondary coolant leak: ", secondary_damage, " / Day")
		damage_count += 1
		secondary_level -= secondary_damage

	if emergency_damage >= 3:
		print(" - Emergency coolant leak: ", emergency_level, " / Day")
		damage_count += 1
		emergency_level -= emergency_damage

	if primary_failure > 0:
		print(" - Primary coolant pump failure")
		damage_count += 1
		# need to show percentage

	if secondary_failure > 0:
		print(" - Secondary coolant pump failure")
		damage_count += 1
		# need to show percentage

	if exchange_failure > 0:
		print(" - Heat Exchange Failure")
		damage_count += 1

	if generator_failure > 0:
		print(" - Turbine Failure")
		damage_count += 1

	if damage_count == 0:
		print(" - None")

	print("===== END OF STATUS REPORT =====")

func do_maintenance() -> void:
	# reset fluid levels
	emergency_level = 300
	primary_level = 120
	secondary_level = 120

	# Calculate quality
	primary_quality = 1	# default is 1st class workmanship
	if rand_range(0.0, 1.0) > 0.57: # 43% chance of 2nd class workmanship
		primary_quality += 1
	if rand_range(0.0, 1.0) > 0.95: # 5% chance of 3rd class workmanshop
		primary_quality += 1
	secondary_quality = 1 # default is 1st class workmanship
	if rand_range(0.0, 1.0) > 0.57: # 43% chance of 2nd class workmanship
		secondary_quality += 1
	if rand_range(0.0, 1.0) > 0.95: # 5% chance of 3rd class workmanship
		secondary_quality += 1

	# reset temperatures
	reactor_temperature = 25
	reactor_previous_temperature = 25
	exchange_temperature = 25
	exchange_previous_temperature = 25
	tower_temperature = 25
	tower_previous_temp = 25

	# Calculate total damage
	total_damage = (2 * reactor_damage) + emergency_damage + primary_damage + exchange_damage + secondary_damage + generator_damage

	# Calculate maintenance days
	# TODO!!

	day_number += maintenance_days
	previous_day_number = day_number

	# Reset damage
	reactor_damage = 0
	emergency_damage = 0
	primary_damage = 0
	exchange_damage = 0
	secondary_damage = 0
	generator_damage = 0
	primary_failure = 0
	secondary_failure = 0
	exchange_failure = 0
	generator_failure = 0
	emergency_flow = 0
	primary_flow = 0
	secondary_flow = 0

	# reset current generator production
	generator_production = 0


func dump_report() -> void:
	# Simply dumps a text based report to the console, very similar to the original
	# basic application. This is to check things are working as intended
	print("---------------------------------------------------")
	print("Day number: ", day_number)
	print("Control Rod Position: ", control_rod_position, "%")
	print("\n")
	print("Temperatures:  MAX   CHANGE    NOW")
	print("Reactor        800        ", reactor_temperature - reactor_previous_temperature, "     ", reactor_temperature)
	print("Heat exchange  500        ", exchange_temperature - exchange_previous_temperature, "     ", exchange_temperature)
	print("Cooling tower  300        ", tower_temperature - tower_previous_temp, "     ", tower_temperature)
	print("\n")
	print("  Power output (Max 2000): ", generator_production, " kW")
	print("     Average power output: ", kilowatt_average, " kW")
	print("Value of energy produced : $ ", kilowatt_value)
	print("\n")
	print("Coolants:    LEVEL   LEAKAGE   FLOW")
	print("Emergency      ", emergency_level, "    ", emergency_damage, "/day      ", emergency_flow)
	print("Primary        ", primary_level, "    ", primary_damage, "/day      ", primary_flow)
	print("Secondary      ", secondary_level, "    ", secondary_damage, "/day      ", secondary_flow)
	print("% Fuel remaining = ", fuel_remaining)
	print("---------------------------------------------------")


func daily_operations() -> void:
	# Calculate Emergency coolant system
	emergency_level -= emergency_flow
	if emergency_damage > 3:
		emergency_level -= 2 * emergency_damage

	# Calculate leakage probabilities for primary coolant
	match primary_quality:
		1:
			# high quality
			if primary_flow > 65 and rand_range(0,1) > 0.9998:
				primary_damage += 1
			if primary_flow > 90 and rand_range(0,1) > 0.996:
				primary_damage += 1
			if primary_flow > 95 and rand_range(0,1) > 0.95 and 4000 * rand_range(0,1) < day_number:
				primary_damage += 1
		2:
			# medium quality
			if primary_flow > 55 and rand_range(0,1) > 0.9995:
				primary_damage += 1
			if primary_flow > 80 and rand_range(0,1) > 0.993:
				primary_damage += 1
			if primary_flow > 92 and rand_range(0,1) > 0.94 and 2700 * rand_range(0,1) < day_number:
				primary_damage += 1
		3:
			# low quality
			if primary_flow > 40 and rand_range(0,1) > 0.999:
				primary_damage += 1
			if primary_flow > 70 and rand_range(0,1) > 0.985:
				primary_damage += 1
			if primary_flow > 87 and rand_range(0,1) > 0.93 and 1400 * rand_range(0,1) < day_number:
				primary_damage += 1

	# Calculate leakage probabilities for secondary coolant
	match secondary_quality:
		1:
			# high quality
			if secondary_flow > 75 and rand_range(0,1) > 0.9997:
				secondary_damage += 1
			if secondary_flow > 93 and rand_range(0,1) > 0.995:
				secondary_damage += 1
			if secondary_flow > 97 and rand_range(0,1) > 0.94 and 3000 * rand_range(0,1) < day_number:
				secondary_damage += 1
		2:
			# medium quality
			if secondary_flow > 60 and rand_range(0,1) > 0.9992:
				secondary_damage += 1
			if secondary_flow > 85 and rand_range(0,1) > 0.99:
				secondary_damage += 1
			if secondary_flow > 94 and rand_range(0,1) > 0.92 and 2400 * rand_range(0,1) < day_number:
				secondary_damage += 1
		3:
			# low quality
			if secondary_flow > 40 and rand_range(0,1) > 0.985:
				secondary_damage += 1
			if secondary_flow > 78 and rand_range(0,1) > 0.98:
				secondary_damage += 1
			if secondary_flow > 89 and rand_range(0,1) > 0.9 and 1800 * rand_range(0,1) < day_number:
				secondary_damage += 1

	# calculate coolant failures
	if primary_damage > 5:
		primary_failure = 1
	if secondary_damage > 5:
		secondary_failure = 1

	# recalculate coolant flows based on damaged components
	# TODO

	# calculate heat transfers
	reactor_level += reactor_heat / 50
	fuel_remaining = 100 - reactor_level

	reactor_heat = (control_rod_position * 30 + control_rod_position_prev_1 * 60 + control_rod_position_prev_2 * 10) / 2500 * (100 - reactor_level)

	# primary heat
	if primary_level > 100:
		primary_heat = primary_flow * 100
	else:
		primary_heat = primary_level / 350

	emergency_heat = emergency_flow / 200 * (reactor_temperature - 25)

	if reactor_temperature > 25:
		reactor_temperature = reactor_temperature + reactor_heat - emergency_heat - primary_heat
	if reactor_temperature < 25:
		reactor_temperature = 25

	exchange_temperature = (reactor_temperature - 25) * primary_flow + ((tower_temperature - 25) * secondary_flow) / (primary_flow + secondary_flow + 1) + 25

	if exchange_failure > 0:
		# some heat will leak from the reactor to the exchange
		exchange_temperature = reactor_temperature * 0.8 + 5

	# secondary heat
	if secondary_level > 100:
		secondary_heat = secondary_flow * 100
	else:
		secondary_heat = secondary_flow / 350 * (exchange_temperature - tower_temperature)

	if exchange_damage > 0:
		secondary_heat = secondary_heat * 0.2

	# generator
	generator_production = secondary_heat / exchange_temperature * (exchange_temperature - tower_temperature) * 2 / 3
	if generator_production > 2600:
		generator_production = 2600

	if generator_damage > 0:
		generator_production = 0

	# Cooling tower
	tower_temperature = 25 + ((exchange_temperature - 25) * (secondary_heat - generator_production) / (secondary_heat + 1) * 0.75)
	if tower_temperature < 25:
		tower_temperature = 25

	# failures
	if exchange_failure < 1:
		if exchange_temperature > 2 and rand_range(0,3) > 0.9:
			exchange_failure = 1

	if generator_failure < 1:
		if generator_damage > 4 and rand_range(0,3) > 0.9:
			generator_failure = 1

	# Finally, lets tally up the total generation
	total_generation += generator_production

	pass

# -[ private methods ]-----------------------------------------------------------------------------
