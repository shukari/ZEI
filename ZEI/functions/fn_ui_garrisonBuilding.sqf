params [
		["_faction", ""],
		["_units", 4],
		["_forceDS", TRUE]
	];

[format["Passed - F: %1 U: %2 DS: %2", _faction, _units, _forceDS], "DEBUG"] call ZEI_fnc_misc_logMsg;
	
// Need to pass logic pos info to GUI somehow?
private _bld = missionNamespace getVariable ["ZEI_LastBuilding", objNull];

// Get all units with a weapon and non-parachute backpack.
private _tempList = "getText (_x >> 'faction') == _faction && (configName _x) isKindoF 'CAManBase' && getNumber(_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles");

// FIX - BIS didn't add viper units as a separate faction!
if (_faction == "OPF_V_F") then {
	_tempList = [
		configFile >> "CfgVehicles" >> "O_V_Soldier_Exp_ghex_F",
		configFile >> "CfgVehicles" >> "O_V_Soldier_JTAC_ghex_F",
		configFile >> "CfgVehicles" >> "O_V_Soldier_M_ghex_F",
		configFile >> "CfgVehicles" >> "O_V_Soldier_ghex_F",
		configFile >> "CfgVehicles" >> "O_V_Soldier_Medic_ghex_F",
		configFile >> "CfgVehicles" >> "O_V_Soldier_LAT_ghex_F",
		configFile >> "CfgVehicles" >> "O_V_Soldier_TL_ghex_F"
	];
};

// Filter out and invalid unit types matching strings.
_fnc_notInString = {
	params ["_type"];
	
	private _notInString = TRUE;
	{
		if (toLower _type find _x >= 0) exitWith { _notInString = FALSE };
	} forEach [ "_story", "_vr", "competitor", "ghillie", "miller", "survivor", "crew", "diver", "pilot", "rangemaster", "uav", "unarmed", "officer" ];
	
	_notInString
};

// Attempt to clear up the units list - Include units with at least one weapon and a non-parachute backpack.
private _menList = _tempList select { ((configName _x) call _fnc_notInString) && (count getArray(_x >> "weapons") > 2) && (toLower getText (_x >> "backpack") find "para" < 0) };

// If no units remain, use the original list.
if (count _menList == 0) then { _menList = _tempList };

// No units exist at all!
if (count _menList == 0) exitWith {
	[format["No units found for faction: %1", _faction], "ERROR"] call ZEI_fnc_misc_logMsg;
};

private _bldPos = _bld buildingPos -1;

if (is3DEN) then {
	collect3DENHistory {
		// TODO: Find a neater way to create a group (create3DENComposition)?
		private _tempUnit = switch (getNumber (configFile >> "CfgFactionClasses" >> _faction >> "side")) do { 
				case 0: { create3DENEntity ["Object", "O_Soldier_F", [0, 0, 0]]; };
				case 1: { create3DENEntity ["Object", "B_Soldier_F", [0, 0, 0]]; };
				default { create3DENEntity ["Object", "I_Soldier_F", [0, 0, 0]]; };
			};
				
		for "_i" from 1 to _units do {
			if (count _bldPos == 0) exitWith {};
			private _rndPos = selectRandom _bldPos;
			_bldPos = _bldPos - [_rndPos];
			[group _tempUnit, configName (selectRandom _menList), _rndPos, _bld] call ZEI_fnc_garrisonUnit;
		};
		
		// Set group to be deleted when empty.
		(group _tempUnit) set3DENAttribute ["garbageCollectGroup", TRUE];
		
		// Set dynamicSimulation if forced or all units are inside a building.
		if (({(count (lineIntersectsWith [eyePos _x, ((eyePos _x) vectorAdd [0, 0, 10])] select {_x isKindOf 'Building'}) < 1)} count (units _tempUnit)) == 0 || {_forceDS}) then { 
				(group _tempUnit) set3DENAttribute ["dynamicSimulation", TRUE];
		};
		delete3DENEntities [_tempUnit];
	};
} else {
	private _grp = switch (getNumber (configFile >> "CfgFactionClasses" >> _faction >> "side")) do { 
		case 0: { createGroup [EAST, TRUE] };
		case 1: { createGroup [WEST, TRUE] };
		default { createGroup [INDEPENDENT, TRUE] };
	};

	for "_i" from 1 to _units do {
		if (count _bldPos == 0) exitWith {};
		private _rndPos = selectRandom _bldPos;
		_bldPos = _bldPos - [_rndPos];
		[_grp, configName (selectRandom _menList), _rndPos, _bld] call ZEI_fnc_garrisonUnit;
	};
	
	if (_forceDS) then { _grp spawn { sleep 5; _this enableDynamicSimulation TRUE; }; };
};