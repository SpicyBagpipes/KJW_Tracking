class CfgVehicles {
    class Helper_Base_F;
    class GVAR(leftStep): Helper_Base_F {
        displayName = "Left Footstep";
        hiddenSelections[] = {"camo"};
        hiddenSelectionsTextures[] = {"#(argb,8,8,3)color(1,0,0,0.75,ca)"};
        model = "\A3\characters_f\footstep_L.p3d";
    };
    class GVAR(rightStep): Helper_Base_F {
        displayName = "Right Footstep";
        hiddenSelections[] = {"camo"};
        hiddenSelectionsTextures[] = {"#(argb,8,8,3)color(1,0,0,0.75,ca)"};
        model = "\A3\characters_f\footstep_R.p3d";
    };
    class Land_Orange_01_F;
    class GVAR(orangePiece): Land_Orange_01_F {
        displayName = "Orange Piece";
        model = "\A3\Props_F_Orange\Humanitarian\Supplies\Particles\Orange_01_part_F.p3d";
    };
    class FloatingStructure_F;
    class Leaflet_05_F;
    class GVAR(drawing): Leaflet_05_F {
        displayName = "Leaflet (Drawings)";
        hiddenSelectionsTextures[] = {"\A3\Missions_F_Orange\Data\Img\Orange_Compositions\S4+S5\S5_drawings_01_CO.paa"};
    };
};