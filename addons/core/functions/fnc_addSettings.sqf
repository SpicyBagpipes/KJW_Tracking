#include "script_component.hpp"
/*
 *  Author: KJW
 * 
 *  Adds settings required for the mod to function
 * 
 *  Arguments:
 *  None
 * 
 *  Return Value:
 *  None
 * 
 *  Example:
 *  call KJW_Diseases_Core_fnc_addSettings
 * 
 *  Public: No
 */

[
	QGVAR(frequency),
	"SLIDER",
	["PPE Threshold", "Threshold for PPE blocking all damage"],
	["KJW's Medical Expansion", "Diseases"],
	[0, 15, 2.2, 1], // Default value
	1, // 1: all clients share the same setting, 2: setting can’t be overwritten (optional, default: 0)
	{}, // Setting changed code
	false // Requires restart
] call CBA_fnc_addSetting;