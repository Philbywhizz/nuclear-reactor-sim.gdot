extends Control
# =================================================================================================
# The master UI Script file
# =================================================================================================

# =[ PROPERTIES: ]=================================================================================


# -[ signals ]-------------------------------------------------------------------------------------
signal quit_requested


# -[ enums ]---------------------------------------------------------------------------------------
# -[ constants ]-----------------------------------------------------------------------------------
# -[ exported variables ]--------------------------------------------------------------------------
# -[ public variables ]----------------------------------------------------------------------------
# -[ private variables ]---------------------------------------------------------------------------
# -[ onready variables ]---------------------------------------------------------------------------


onready var panel_rods_input = $VBoxContainer/InputControls/HBoxControls/PanelControlRods
onready var panel_emergency_input = $VBoxContainer/InputControls/HBoxControls/PanelEmergencyCoolant
onready var panel_primary_input = $VBoxContainer/InputControls/HBoxControls/PanelPrimaryCoolant
onready var panel_secondary_input = $VBoxContainer/InputControls/HBoxControls/PanelSecondaryCoolant


# =[ METHODS: ]====================================================================================


func _ready() -> void:
	pass


# -[ built in virtual methods ]--------------------------------------------------------------------
# -[ public methods ]------------------------------------------------------------------------------


func reset_all_controls() -> void:
	panel_rods_input.reset_panel()
	panel_emergency_input.reset_panel()
	panel_primary_input.reset_panel()
	panel_secondary_input.reset_panel()


# -[ private methods ]-----------------------------------------------------------------------------


func _on_Quit_pressed() -> void:
	emit_signal("quit_requested")


func _on_Reset_pressed() -> void:
	reset_all_controls()
