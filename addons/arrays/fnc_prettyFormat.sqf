#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Function: CBA_fnc_prettyFormat

Description:
    Makes an array easier to read.

Parameters:
    _array - The array to format <ARRAY>
    _tab   - The tab char to use (optional, default: "    ") <STRING>
    _lineBreak - The char to use for line breaks (optional, default: endl) <STRING>
    _depth - Starting indent (optional, default: 0) <NUMBER>

Returns:
    Formatted string <STRING>

Examples:
    (begin example)
        _return = [ [0, 1, ["22", 33, []], 4] ] call CBA_fnc_prettyFormat;
        // _return ==>
        // "[
        //      0,
        //      1,
        //      [
        //          ""22"",
        //          33,
        //          []
        //      ],
        //      4
        //  ]"
        _return = [ [0, 1, ["22", 33, []], 4], ">---" ] call CBA_fnc_prettyFormat;
        // _return ==>
        // [
        // >---0,
        // >---1,
        // >---[
        // >--->---""22"",
        // >--->---33,
        // >--->---[]
        // >---],
        // >---4
        // ]
        _return = [[0, 1, ["22", 33, []], 4], ">---", "\n"] call CBA_fnc_prettyFormat;
        // _return ==> "[\n>---0,\n>---1,\n>---[\n>--->---""22"",\n>--->---33,\n>--->---[]\n>---],\n>---4\n]"
    (end)

Author:
   Terra, Dystopian, commy2
---------------------------------------------------------------------------- */
SCRIPT(prettyFormat);
params [["_array", [], [[]]], ["_tab", "    ", [""]], ["_lineBreak", endl, [""]], ["_depth", 0, [0]]];
private _indents = [];
_indents resize _depth;
_indents = (_indents apply {_tab}) joinString "";

if (_array isEqualTo []) exitWith {
    _indents + "[]"
};

private _lines = _array apply {
    if (_x isEqualType []) then {
        [_x, _tab, _lineBreak, _depth + 1] call CBA_fnc_prettyFormat
    } else {
        _tab + _indents + str _x
    };
};

_indents + "[" + _lineBreak + (_lines joinString ("," + _lineBreak)) + _lineBreak + _indents + "]"
