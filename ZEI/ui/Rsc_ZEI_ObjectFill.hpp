class Rsc_ZEI_ObjectFill
{
	idd=1704;

	controlsBackground[]=
	{
		ZEI_OF_Background,
		ZEI_OF_Frame,
		ZEI_OF_Text_Title,
		ZEI_OF_Text_Type,
		ZEI_OF_Text_Items,
		ZEI_OF_Text_EditObject
	};
	
	controls[]={
		ZEI_OF_Combo_Type,
		ZEI_OF_Slider_Items,
		ZEI_OF_CheckBox_EditObject,
		ZEI_OF_Button_OK,
		ZEI_OF_Button_Cancel
	};

	class ZEI_OF_Background: IGUIBack
	{
		idc = -1;
		x = 0.335 * safezoneW + safezoneX;
		y = 0.324 * safezoneH + safezoneY;
		w = 0.2475 * safezoneW;
		h = 0.242 * safezoneH;
	};
	class ZEI_OF_Frame: RscFrame
	{
		idc = -1;
		x = 0.335 * safezoneW + safezoneX;
		y = 0.324 * safezoneH + safezoneY;
		w = 0.2475 * safezoneW;
		h = 0.242 * safezoneH;
	};
	class ZEI_OF_Text_Title: RscText
	{
		idc = -1;
		text = "Object Fill"; //--- ToDo: Localize;
		x = 0.340156 * safezoneW + safezoneX;
		y = 0.324 * safezoneH + safezoneY;
		w = 0.19 * safezoneW;
		h = 0.033 * safezoneH;
	};
	class ZEI_OF_Combo_Type: RscCombo
	{
		idc = 10;
		x = 0.432969 * safezoneW + safezoneX;
		y = 0.368 * safezoneH + safezoneY;
		w = 0.139219 * safezoneW;
		h = 0.022 * safezoneH;
		onLoad= "_this spawn {\
			waitUntil { !isNull (_this select 0) };\
			{ (findDisplay 1704 displayCtrl 10) lbAdd _x } forEach ['Random', 'Food', 'Medical', 'Office', 'Tools'];\
			(findDisplay 1704 displayCtrl 10) lbSetCurSel 0;\
		}";
	};
	class ZEI_OF_Text_Type: RscText
	{
		idc = -1;
		text = "Object Type"; //--- ToDo: Localize;
		x = 0.340156 * safezoneW + safezoneX;
		y = 0.368 * safezoneH + safezoneY;
		w = 0.0567187 * safezoneW;
		h = 0.022 * safezoneH;
	};
	class ZEI_OF_Text_Items: RscText
	{
		idc = 1;
		text = "Fill Percent (30)"; //--- ToDo: Localize;
		x = 0.340156 * safezoneW + safezoneX;
		y = 0.412 * safezoneH + safezoneY;
		w = 0.0825 * safezoneW;
		h = 0.022 * safezoneH;
	};
	class ZEI_OF_Slider_Items: RscSlider
	{
		idc = 20;
		x = 0.427812 * safezoneW + safezoneX;
		y = 0.412 * safezoneH + safezoneY;
		w = 0.144375 * safezoneW;
		h = 0.033 * safezoneH;
		tooltip = "Chance to spawn an object";
		onSliderPosChanged = "(findDisplay 1704 displayCtrl 1) ctrlSetText format['Fill Percent (%1)', round (_this select 1) * 10];";
		onLoad= "_this spawn {\
			waitUntil { !isNull (_this select 0) };\
			(findDisplay 1704 displayCtrl 20) sliderSetRange [ 1, 10 ];\
			(findDisplay 1704 displayCtrl 20) sliderSetPosition 3;\
			};";
	};
	class ZEI_OF_Text_EditObject: RscText
	{
		idc = -1;
		text = "Edit Object (ZEUS Only)"; //--- ToDo: Localize;
		x = 0.340156 * safezoneW + safezoneX;
		y = 0.467 * safezoneH + safezoneY;
		w = 0.0845 * safezoneW;
		h = 0.022 * safezoneH;
	};
	class ZEI_OF_CheckBox_EditObject: RscCheckbox
	{
		idc = 30;
		x = 0.422656 * safezoneW + safezoneX;
		y = 0.467 * safezoneH + safezoneY;
		w = 0.020625 * safezoneW;
		h = 0.033 * safezoneH;
		tooltip = "Allow Zeus to Move/Edit Objects";
		checked = "if is3DEN then { 0 } else { 1 }";
	};
	class ZEI_OF_Button_OK: RscButton
	{
		idc = -1;
		text = "OK"; //--- ToDo: Localize;
		x = 0.360781 * safezoneW + safezoneX;
		y = 0.522 * safezoneH + safezoneY;
		w = 0.04125 * safezoneW;
		h = 0.022 * safezoneH;
		onButtonClick  = "[ lbCurSel (findDisplay 1704 displayCtrl 10), round (sliderPosition (findDisplay 1704 displayCtrl 20)) * 10, cbChecked (findDisplay 1704 displayCtrl 30) ] spawn ZEI_fnc_ui_objectFill; (findDisplay 1704) closeDisplay 1;";
	};
	class ZEI_OF_Button_Cancel: RscButton
	{
		idc = -1;
		text = "Cancel"; //--- ToDo: Localize;
		x = 0.494844 * safezoneW + safezoneX;
		y = 0.522 * safezoneH + safezoneY;
		w = 0.04125 * safezoneW;
		h = 0.022 * safezoneH;
		onButtonClick  = "(findDisplay 1704) closeDisplay 2;";
	};
};