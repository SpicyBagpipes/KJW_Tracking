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
GVAR(maxSteps) = 500;

[{
	if (isGamePaused || GVAR(chance) == 0) exitWith {};
	{
        if (GVAR(doPlayers) && _x in allPlayers) then {continue};
		if (_x getVariable [QGVAR(exception),false]) then {continue};
		if (vectorMagnitude velocity _x < 1) then {continue};
		if (hasInterface) then {
			private _obj = "";
			private _footTracker = _x getVariable [QGVAR(footTracker),1];
			private _pos = getPosASL _x;
			private _dir = getDir _x;
			private _vector_dir = surfaceNormal _pos;
			private _vector_up = _vector_dir vectorCrossProduct [sin _dir, cos _dir, 0] vectorCrossProduct _vector_dir;
			if (_footTracker >= 10000) then {
				_footTracker = 0;
			};
			_x setVariable [QGVAR(footTracker), _footTracker + 1];
			private _stepCounter = _x getVariable [QGVAR(stepCounter),0];
			if (ace_player getVariable [QGVAR(TrackingUnit),objNull] isEqualTo _x) then {
				//hideObject _obj;

				if (_stepCounter mod 2 != 0) then {
					_obj = createSimpleObject ["UserTexture1m_F",_pos,true];
					_obj setObjectTexture [0,"y\KJW_Tracking\addons\core\data\footprint_l_ca.paa"];
				} else {
					_obj = createSimpleObject ["UserTexture1m_F",_pos, true];
					_obj setObjectTexture [0,"y\KJW_Tracking\addons\core\data\footprint_r_ca.paa"];
				};
		
				_obj setObjectMaterial [0,"\a3\characters_f_bootcamp\common\data\vrarmoremmisive.rvmat"];
				_obj setVectorDirAndUp [_vector_dir vectorMultiply -1, vectorNormalized _vector_up];
				_obj setObjectScale 0.3;
		
				GVAR(stepObjects) pushBack _obj;
			};
			_stepCounter = _stepCounter + 1;
			_x setVariable [QGVAR(stepCounter),_stepCounter];
			private _objInfo = [_pos, _dir, [_vector_dir, _vector_up], _footTracker];
			private _steps = _x getVariable [QGVAR(steps), false];
			if (_steps isEqualType false) then {
				_steps = [];
				_steps resize GVAR(maxSteps);
				_steps resize 0;
				_x setVariable [QGVAR(steps), _steps];
				_x setVariable [QGVAR(nextStep), GVAR(maxSteps) - 1];
			};

			if (count _steps >= GVAR(maxSteps)) then {
				private _nextStep = _x getVariable QGVAR(nextStep);
				_nextStep = (_nextStep + 1) % GVAR(maxSteps);
				_steps set [_nextStep, _objInfo];
				_x setVariable [QGVAR(nextStep), _nextStep];
			} else	{
				_steps pushBack _objInfo;
			};
		};
		private _roll = random 1;
		if (isServer && (_roll < GVAR(chance)/0.6)) then {
			private _classname = selectRandom GVAR(possibleItems);
			private _pos = getPosATL _x;
			private _dir = getDir _x;
			private _obj = _classname createVehicle _pos;
			_obj setDir _dir;
			_obj setVectorUp surfaceNormal _pos;
			_obj enableSimulationGlobal false;
			_obj setVariable [QGVAR(owner), _x, true];
			[QGVAR(addInteraction),[_obj]] call CBA_fnc_globalEvent;
			// Fire global event for the ace interaction adding
		};	  
	} forEach allUnits;
}, 0.6, []] call CBA_fnc_addPerFrameHandler;

[QGVAR(addInteraction), {
	params ["_item"];
	if isNull _item exitWith {};
	private _obj = createSimpleObject ["Sign_Sphere10cm_F", [0,0,0], true];
	_obj setPosASL getPosASL _item;
	_obj setObjectScale 0.75;
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

    {deleteVehicle _x} forEach GVAR(stepObjects);
	ace_player setVariable [QGVAR(TrackingUnit),_unit];

    if (isNull _unit) exitWith {};

	GVAR(stepObjects) = [];
	{
		_x params ["_pos", "_dir", "_vdirup", "_stepCounter"];
		_vdirup params ["_vector_dir", "_vector_up"];

		private _obj = "";

		if (_stepCounter mod 2 != 0) then {
			_obj = createSimpleObject ["UserTexture1m_F",_pos,true];
			_obj setObjectTexture [0,"y\KJW_Tracking\addons\core\data\footprint_l_ca.paa"];
		} else {
			_obj = createSimpleObject ["UserTexture1m_F",_pos, true];
			_obj setObjectTexture [0,"y\KJW_Tracking\addons\core\data\footprint_r_ca.paa"];
		};

		_obj setObjectMaterial [0,"\a3\characters_f_bootcamp\common\data\vrarmoremmisive.rvmat"];
		_obj setVectorDirAndUp [_vector_dir vectorMultiply -1, vectorNormalized _vector_up];
		_obj setObjectScale 0.3;

		GVAR(stepObjects) pushBack _obj;
	} forEach (_unit getVariable [QGVAR(steps),[]]);
}] call CBA_fnc_addEventHandler;