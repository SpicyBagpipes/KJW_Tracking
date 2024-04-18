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
call FUNC(addEventHandlers);

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