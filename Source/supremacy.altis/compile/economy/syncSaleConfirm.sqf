/**
 * syncSaleConfirm.sqf
 *
 * LICENSE: This file is subject to the terms and conditions defined in
 * file "LICENSE.md", which is part of this source code package.
 *
 * @package    Supremacy Framework
 * @author     Mark Eliasen <https://github.com/MrEliasen>
 * @copyright  2015 Mark Eliasen
 * @license    CC BY-NC 3.0 License
 * @link       https://github.com/MrEliasen/SupremacyFramework
 */

private["_item","_itemdetails","_price","_sellPercentage","_money","_controller","_wpitem","_attachments","_confirmed","_priceIndex","_pricelist"];
_item = [_this,0,"",[""]] call BIS_fnc_param;
_money = [_this,1,0,[0]] call BIS_fnc_param;
_controller = [_this,2,0,[0]] call BIS_fnc_param;
_wpitem = [_this,3,false,[false]] call BIS_fnc_param;
_attachments = [_this,4,false,[false]] call BIS_fnc_param;
_confirmed = [_this,5,false,[false]] call BIS_fnc_param;
_isVehicle = [_this,6,false,[false]] call BIS_fnc_param;
_price = 0;

if (_item == "") exitWith {};

_itemdetails = [_item] call SPMC_fnc_getItemCfgDetails;

if (_confirmed) then { 
    if (!_isVehicle) then {
        _pricelist = ["item_prices"] call SPMC_fnc_config;

        _priceIndex = [_item, _pricelist] call SPMC_fnc_findIndex;
        if (_priceIndex != -1) then {
            _sellPercentage = ["sell_percentage"] call SPMC_fnc_config;
            _price = floor(((_pricelist select _priceIndex) select 1) * (_sellPercentage/100));
        };

        if (_wpitem) then {
            switch (true) do {
                case (_item in (primaryWeaponItems player)): {
                    player removePrimaryWeaponItem _item;
                };
                case (_item in (secondaryWeaponItems player)): {
                    player removeSecondaryWeaponItem _item;
                };
                case (_item in (handgunItems player)): {
                    player removeHandgunItem _item;
                };

                default {
                    player removeItem _item;
                };
            };
        };

        if (!isNull (findDisplay 2400) && _controller == 2402) then { 
            ctrlEnable[2402, true];
        };
    } else {
        if (!isNull (findDisplay 2600) && _controller == 2606) then { 
            ctrlEnable[2606, true];
        };
    };

    if (_attachments) then {
        hint format["%1%2 sold for %3%4!", (_itemdetails select 1), " (the attachment(s) where sold in the background)", ['currency_symbol'] call SPMC_fnc_config, _price];
    } else {
        hint format["%1 sold for %2%3!", (_itemdetails select 1), ['currency_symbol'] call SPMC_fnc_config, _price];
    };

    player say3D "sold_item";
    sleep 0.73;
} else {
    hint format["Sale of the %1 failed!", (_itemdetails select 1)];
    player say3D "error";
};

SPMC_gbl_money = _money;

