extends PanelContainer
# =================================================================================================
# A simple generic script to handle a slider control panel
# =================================================================================================

# =[ PROPERTIES: ]=================================================================================

# -[ signals ]-------------------------------------------------------------------------------------
# -[ enums ]---------------------------------------------------------------------------------------
# -[ constants ]-----------------------------------------------------------------------------------
# -[ exported variables ]--------------------------------------------------------------------------
# -[ public variables ]----------------------------------------------------------------------------
# -[ private variables ]---------------------------------------------------------------------------


var _slider_value = 0


# -[ onready variables ]---------------------------------------------------------------------------


onready var value_label = $VBoxControls/Value
onready var vslider = $VBoxControls/VSlider

# =[ METHODS: ]====================================================================================


func _ready() -> void:
	pass


# -[ built in virtual methods ]--------------------------------------------------------------------
# -[ public methods ]------------------------------------------------------------------------------

func reset_panel() -> void:
	vslider.value = 0

# -[ private methods ]-----------------------------------------------------------------------------


func _on_VSlider_value_changed(value: float) -> void:
	_slider_value = value
	value_label.text = str(_slider_value)
