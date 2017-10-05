/*
Name             : DPI
Purpose          : Return scaling factor or calculate position/values for AHK controls (font size, position (x y), width, height)
Version          : 0.2
Documentation    : https://github.com/hi5/dpi
AutoHotkey Forum : https://autohotkey.com/boards/viewtopic.php?f=6&t=37913
License          : see license.txt (GPL 2.0)

Documentation - see readme.md

*/

DPI(in="",r=0)
	{
	 RegRead, AppliedDPI, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI
	 ; If the AppliedDPI key is not found the default settings are used.
	 ; 96 is the default value.
	 if (errorlevel=1) OR (AppliedDPI=96)
		AppliedDPI:=96
	 if ###dpiset ; this is a global variable you define in your (main) script - see Documentation
		AppliedDPI:=###dpiset
	 factor:=AppliedDPI/96
	 if !in
		return factor

	 Loop, parse, in, %A_Space%
		{
		 option:=A_LoopField
		 if RegExMatch(option,"i)^[whxyrs]") ; width, height, x, y, rows, size (font)
			{
			 RegExMatch(option,"\K(\d+)",number)
			 ; Using ternary logic below to determine if we want to Round() the values
			 ; if so, Round() it - the part before the : - if not simply calculate the factor as is - part after the :
			 newnumber:=r ? Round(number*factor) : number*factor
			 option:=StrReplace(option,number,newnumber)
			 number:="",newnumber:=""
			}
		 out .= option A_Space
		}
	 return Trim(out)
	}
