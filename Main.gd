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
var emergency_level := 300					# EV
var emergency_damage := 0					# ED
var emergency_flow := 0						# EF
var primary_level := 120 					# PV
var primary_quality := 1 					# QP
var primary_damage := 0						# PD
var primary_failure := 0 					# PB
var primary_flow := 0						# PF
var primary_heat := 0						# PH
var secondary_level := 120					# SV
var secondary_quality := 1 					# QS
var secondary_damage := 0					# SD
var secondary_failure := 0					# SB
var secondary_flow := 0						# SF
var control_rod_position := 0				# A
var control_rod_position_prev_1 := 0 		# A1
var control_rod_position_prev_2 := 0 		# A2
var reactor_heat := 0						# RH
var reactor_level := 0						# RL
var reactor_temperature := 25				# RT
var reactor_previous_temperature := 25		# T7
var reactor_damage := 0						# RD
var exchange_temperature := 25				# XT
var exchange_previous_temperature := 25		# T8
var exchange_damage := 0 					# TD
var exchange_failure := 0					# TB
var tower_temperature := 25					# CT
var tower_previous_temp := 25				# T9
var generator_damage := 0					# GD
var generator_failure := 0					# GB
var generator_production := 0				# GZ
var kilowatt_average := 0					# KW
var kilowatt_value := 0						# VE
var day_number := 0							# DAY
var previous_day_number := 0 				# D4
var maintenance_days := 0					# MD
var total_damage := 0 						# DMGE
var fuel_remaining := 100					# FL

# -[ private variables ]---------------------------------------------------------------------------
# -[ onready variables ]---------------------------------------------------------------------------

# =[ METHODS: ]====================================================================================


func _ready() -> void:
	do_maintenance()

	dump_report()
	pass


# -[ built in virtual methods ]--------------------------------------------------------------------
# -[ public methods ]------------------------------------------------------------------------------


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


# -[ private methods ]-----------------------------------------------------------------------------

