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
var primary_failure := 0	 				# PB
var primary_flow := 0						# PF
var primary_heat := 0						# PH
var secondary_level := 120					# SV
var secondary_quality := 1					# QS
var secondary_damage := 0					# SD
var secondary_failure := 0					# SB
var secondary_flow := 0						# SF
var control_rods := 0						# A
var control_rods_prev_1 := 0 				# A1
var control_rods_prev_2 := 0 				# A2
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
var day_number := 0							# DAY
var previous_day_number := 0 				# D4
var maintenance_days := 0					# MD
var total_damage := 0						# DMGE

# -[ private variables ]---------------------------------------------------------------------------
# -[ onready variables ]---------------------------------------------------------------------------

# =[ METHODS: ]====================================================================================


func _ready() -> void:
	pass


# -[ built in virtual methods ]--------------------------------------------------------------------
# -[ public methods ]------------------------------------------------------------------------------
# -[ private methods ]-----------------------------------------------------------------------------

