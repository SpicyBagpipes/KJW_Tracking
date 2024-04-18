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
    "\A3\Structures_F\Items\Stationery\PenBlack_F.p3d", // Black pen
    "\A3\Structures_F\Items\Stationery\PencilBlue_F.p3d", // Blue pencil
    "\A3\Props_F_Orange\Humanitarian\Supplies\Particles\Orange_01_part_F.p3d", // Orange piece
    "\A3\Structures_F_EPA\Items\Tools\Matches_F.p3d", // Matches
    "\A3\Weapons_F\Chemlight\chemlight_blue.p3d", // Chemlight
    "\A3\Structures_F\Items\Food\Can_Dented_F.p3d", // Dented can
    "\A3\Props_F_Orange\Humanitarian\Supplies\WaterBottle_01_cap_F.p3d", // Bottle cap
    "\A3\Structures_F_Heli\Items\Food\Tableware_01_fork_F.p3d", // Disposable fork
    "\A3\Structures_F_Heli\Items\Food\Tableware_01_knife_F.p3d", // Disposable knife
    "\A3\Structures_F_Heli\Items\Food\Tableware_01_spoon_F.p3d", // Disposable spoon
    "\A3\weapons_f\ammo\flare_Yellow.p3d", // Yellow flare
    "\a3\Weapons_F_Orange\Ammo\leaflet_05_f.p3d" // Piece of paper, needs 0.05m agl added
];