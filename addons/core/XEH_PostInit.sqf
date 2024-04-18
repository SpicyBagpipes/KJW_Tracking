#include "script_component.hpp"
/*
 *  Author: KJW
 * 
 *  Handles postinit for the addon
 * 
 *  Arguments:
 *  None
 * 
 *  Return Value:
 *  None
 * 
 *  Example:
 *  call KJW_Tracking_Core_XEH_PostInit
 * 
 *  Public: No
 */

call FUNC(addSettings);

[QGVAR(postInitialised),[]] call CBA_fnc_localEvent;

GVAR(possibleItems) = [
    "Land_PenBlack_F", // Black pen
    "Land_PencilBlue_F", // Blue pencil
    QGVAR(orangePiece), // Orange piece
    "Land_Matches_F", // Matches
    "Land_Can_Dented_F", // Dented can
    "Land_WaterBottle_01_cap_F", // Bottle cap
    "Land_Tableware_01_fork_F", // Disposable fork
    "Land_Tableware_01_knife_F", // Disposable knife
    "Land_Tableware_01_spoon_F", // Disposable spoon
    QGVAR(drawing) // Piece of paper, needs 0.05m agl added
];

GVAR(footprintPaths) = [
    QGVAR(leftStep), // [-0.1,0.4,0]
    QGVAR(rightStep) // [0.2,-0.2,0]
];

GVAR(totalSteps) = [];

[{
	if (isGamePaused) exitWith {};
	{
        if (GVAR(doPlayers) && _x in allPlayers) then {continue};
		if (_x getVariable [QGVAR(Exception),false]) then {continue};
		if (hasInterface && (vectorMagnitude velocity _x > 1)) then {
			private _obj = "";
			private _footTracker = _x getVariable [QGVAR(FootTracker),1];
			private _pos = getPosATL _x;
			private _dir = getDir _x;
            if (_footTracker mod 2 != 0) then {
                _obj = createSimpleObject ["UserTexture1m_F",(getPosASL _x) vectorAdd [-0.1,0.4,0],true];
                _obj setObjectTexture [0,"y\KJW_Tracking\addons\core\data\footprint_l_ca.paa"];
            } else {
                _obj = createSimpleObject ["UserTexture1m_F",(getPosASL _x) vectorAdd [0.2,-0.2], true];
                _obj setObjectTexture [0,"y\KJW_Tracking\addons\core\data\footprint_r_ca.paa"];
            };
			if (_footTracker >= 10000) then {
				_footTracker = 0;
			};
            _obj setObjectMaterial [0,"\a3\characters_f_bootcamp\common\data\vrarmoremmisive.rvmat"];
			private _vector_dir = surfaceNormal _pos;
			private _vector_up = _vector_dir vectorCrossProduct [sin _dir, cos _dir, 0] vectorCrossProduct _vector_dir;
			_obj setVectorDirAndUp [_vector_dir vectorMultiply -1, vectorNormalized _vector_up];
			_obj setObjectScale 0.3;
			_x setVariable [QGVAR(FootTracker), _footTracker + 1];
			if (ace_player getVariable [QGVAR(TrackingUnit),objNull] isNotEqualTo _x) then {
				hideObject _obj;
			};
			private _steps = _x getVariable [QGVAR(Steps),[]];
            _steps pushBack _obj;
			private _totalSteps = GVAR(TotalSteps);
			_totalSteps pushBack _obj;
			if (count _totalSteps > 50000) then {
                private _firstStep = _totalSteps#0;
                GVAR(TotalSteps) deleteAt 0;
				deleteVehicle (_firstSTep);
			};
			_x setVariable [QGVAR(Steps),_steps];
		};
		private _roll = random 1;
		if (isServer && (_roll < GVAR(chance)/0.6)) then {
			private _classname = selectRandom GVAR(possibleItems);
			private _pos = getPosATL _x;
			private _dir = getDir _x;
			private _obj = _classname createVehicle _pos;
			_obj setDir _dir;
			_obj setVectorUp surfaceNormal _pos;
			_obj setVariable [QGVAR(owner), _x, true];
			[QGVAR(addInteraction),[_obj]] call CBA_fnc_globalEvent;
			// Fire global event for the ace interaction adding
		};	  
	} forEach allUnits;
}, 0.6, []] call CBA_fnc_addPerFrameHandler;

[QGVAR(addInteraction), {
	params ["_item"];
	if isNull _item exitWith {};
	private _action = [
		QGVAR(TrackTarget),
		"Track",
		"",
		{
			private _owner = _target getVariable [QGVAR(owner),objNull];
			if isNull _owner exitWith {};
			
            [QGVAR(trackTarget), [_owner]] call CBA_fnc_localEvent;
		},
		{true},
		{},
		[],
		[0,0,0],
		50] call ace_interact_menu_fnc_createAction;
	[_item, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;
}] call CBA_fnc_addEventHandler;

[QGVAR(trackTarget), {
    params ["_unit"];

    {_x hideObject true} forEach ((ace_player getVariable [QGVAR(TrackingUnit),objNull]) getVariable [QGVAR(Steps),[]]);

    if (isNull _unit) exitWith {};

    ace_player setVariable [QGVAR(TrackingUnit),_unit];
	{_x hideObject false} forEach (_unit getVariable [QGVAR(steps),[]]);
}] call CBA_fnc_addEventHandler;