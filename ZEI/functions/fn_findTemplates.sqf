// Called from ZEI_fnc_createTemplate. Finds a suitable '_templates' array according to the passed '_tempType'.
params ["_bld", ["_tempType", "mil"], ["_infoOnly", FALSE]];

[format ["Passed - B: %1 T: %2 I: %3", _bld, _tempType, _infoOnly], "DEBUG"] call ZEI_fnc_misc_logMsg;

private _bld = typeOf _bld;

// Fix Case
_tempType = toLower _tempType;

// Assign appropriate furnishing template for house			
private _templates = [];

// Find any user-created custom buildings.
private _customTemplate = missionNamespace getVariable [format["ZEI_%1_customBuildings", _tempType], []];

if !(_customTemplate isEqualTo []) then {
	private _path = [_customTemplate, _bld] call BIS_fnc_findNestedElement;
	
	if !(_path isEqualTo []) then {
		(_customTemplate # (_path # 0)) params ["", ["_values", [], [[]]]];
		_templates append _values;
	};
};

if (_tempType isEqualTo "mil") then {
	_templates append (switch (_bld) do {
		// Vanilla
		#include "..\templates\mil_vanilla.sqf"
		
		// CUP
		#include "..\templates\mil_cup.sqf"
		
		// OTHER
		#include "..\templates\mil_other.sqf"
		
		default {[]};
	});
} else {
	_templates append (switch (_bld) do {
		// Vanilla
		#include "..\templates\civ_vanilla.sqf"
		
		// CUP
		#include "..\templates\civ_cup.sqf"
		
		default {[]};
	});
};

private _before = count _templates;

// Scan for spawnable templates for the current modset
_templates = _templates select {[_x] call ZEI_fnc_templateCanSpawn};

if !(_before isEqualTo count _templates) then {
	// TODO: Really needed? ZEI_fnc_randomiseObject will replace any invalid objects in a template. 
	[format ["Template(s) removed due to invalid objects (%3): Before %1 | After: %2", _before, count _templates, toUpper _tempType], "WARNING"] call ZEI_fnc_misc_logMsg;
};

// Don't spam messages if there is an area to fill
if (!_infoOnly && {_templates isEqualTo []}) then {
	[format ["Building Not Found: %1 (%2) - We need your help to get a template/scheme for this building!", _bld,  getText (configFile >> "CfgVehicles" >> _bld >> "displayName")], "INFO"] call ZEI_fnc_misc_logMsg;
}; 

_templates;
