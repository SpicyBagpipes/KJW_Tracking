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
 *  call KJW_Tracking_Core_fnc_addSettings
 * 
 *  Public: No
 */

[
	QGVAR(chance),
	"SLIDER",
	["Chance", "Chance for a unit to drop a piece of litter"],
	"KJW's Tracking",
	[0, 0.01, 0.0001, 5], // Default value
	1, // 1: all clients share the same setting, 2: setting can’t be overwritten (optional, default: 0)
	{}, // Setting changed code
	false // Requires restart
] call CBA_fnc_addSetting;

[
	QGVAR(doPlayers),
	"CHECKBOX",
	["Players", "Include players in litter dropping and step tracking"],
	"KJW's Tracking",
	false, // Default value
	1, // 1: all clients share the same setting, 2: setting can’t be overwritten (optional, default: 0)
	{}, // Setting changed code
	false // Requires restart
] call CBA_fnc_addSetting;

[
	QGVAR(addHelper),
	"CHECKBOX",
	["Add Helper", "Include a helper sphere on the litter in order to aid in visibility"],
	"KJW's Tracking",
	true, // Default value
	1, // 1: all clients share the same setting, 2: setting can’t be overwritten (optional, default: 0)
	{}, // Setting changed code
	false // Requires restart
] call CBA_fnc_addSetting;