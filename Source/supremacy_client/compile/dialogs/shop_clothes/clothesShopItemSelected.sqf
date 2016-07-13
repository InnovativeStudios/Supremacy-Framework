/**
 * clothesShopItemSelected.sqf
 *
 * LICENSE: This file is subject to the terms and conditions defined in
 * file "LICENSE.md", which is part of this source code package.
 *
 * @package    Supremacy Framework
 * @author     Mark Eliasen <https://github.com/MrEliasen>
 * @copyright  2016 Mark Eliasen
 * @license    CC BY-NC 3.0 License
 * @link       https://github.com/MrEliasen/SupremacyFramework
 */

private["_item","_pricelist","_index","_value","_listNo","_section","_infoText","_skillDiscount"];
_section = [_this,0,"",[""]] call BIS_fnc_param;
_listNo = [];
_infoText = ["",""];
_skillDiscount = 1.0;

if(_section == "") exitWith {};

switch (_section) do {
    case "uniform": {
        _listNo = [2701,2721];
    };
    case "hat": {
        _listNo = [2702,2722];
    };
    case "glasses": {
        _listNo = [2703,2723];
    };
    case "vest": {
        _listNo = [2704,2724];
    };
    case "backpack": {
        _listNo = [2705,2725];
    };
};

if(count _listNo == 0) exitWith {};

disableSerialization;

// Update the price if the player have the Silver Tongue skill line
if (("silver-1" in SPMC_gbl_learnedSkills)) then {
    for "_i" from 2 to 50 do {
        if (!(format ["silver-%1", _i] in SPMC_gbl_learnedSkills)) exitWith {
            _skillDiscount = ([format["silver-%1", (_i - 1)]] call SPMC_fnc_getSkillDetails select 5) select 0;
        };
    };
};

_skillDiscount = (1.0 - _skillDiscount / 100);

_item = [lbData [(_listNo select 0), lbCurSel(_listNo select 0)]] call SPMC_fnc_getItemCfgDetails;
_pricelist = ["item_prices"] call SPMC_fnc_config;
_index = [(_item select 0), _pricelist] call SPMC_fnc_findIndex;
_value = 0;

if (_index != -1) then {
    _value = ((_pricelist select _index) select 1) * _skillDiscount;
};

ctrlSetText[(_listNo select 1), format["%1%2", ['currency_symbol'] call SPMC_fnc_config, [_value] call SPMC_fnc_numberToText]];

switch (_section) do {
    case "uniform": {
        _infoText = [
            format["<br/>Protection: <t color='#ffae2b'>None</t>", (_itemInfo select 11)],
            ""
        ];
    };
    case "hat": {
        _infoText = [
            format["<br/>Protection: <t color='#ffae2b'>None</t>", (_itemInfo select 11)],
            ""
        ];
    };
    case "glasses": {
        _infoText = [
            "",
            ""
        ];
    };
    case "vest": {
        _infoText = [
            format["<br/>Protection: <t color='#ffae2b'>None</t>", (_itemInfo select 11)],
            ""
        ];
    };
    case "backpack": {
        _infoText = [
            "",
            format["<br/>Capacity: <t color='#ffae2b'>%2</t>", (_itemInfo select 12)]
        ]
    };
};

((findDisplay 2700) displayCtrl 2726) ctrlSetStructuredText parseText format[
"<img size='6' image='%1'/><br/>
Name: <t color='#ffae2b'>%2</t>%3%4",
(_item select 3),
(_item select 1),
(_infoText select 0),
(_infoText select 1)];