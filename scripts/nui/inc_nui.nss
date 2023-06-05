#include "nw_inc_nui"
//Events:
const string NUI_EVT_CLICK = "click";
const string NUI_EVT_WATCH = "watch";
const string NUI_EVT_RANGE = "range"; //Use with NuiGetEventPayload
const string NUI_EVT_MOUSE_UP  = "mouseup"; //Use with NuiGetEventPayload
const string NUI_EVT_MOUSE_DOWN = "mousedown"; //Use with NuiGetEventPayload
const string NUI_EVT_MOUSE_SCROLL = "mousescroll"; //Use with NuiGetEventPayload

//Wrappers

// Window, call once
// Special cases:
// * Set the window title to JsonBool(FALSE), Collapse to JsonBool(FALSE) and bClosable to FALSE
//   to hide the title bar.
//   Note: You MUST provide a way to close the window some other way, or the user will be stuck with it.
//   jResizable:        Set to JsonBool(TRUE) or JsonNull() to let user resize without binding.
//   jCollapsed,        Set to a static value JsonBool(FALSE) to disable collapsing.
//                      Set to JsonNull() to let user collapse without binding.
json NUI_Window(json jLayout, json jTitle /*Bind:String*/, json jGeometry /*Bind:NUI_GEO_Rect*/, json jResizable /*Bind:Bool*/, json jCollapsed /*Bind:Bool*/, json jClosable /*Bind:Bool*/, json jTransparent /*Bind:Bool*/, json jBorder /*Bind:Bool*/);

//Layouts

// A column will auto-space all elements inside of it and advise the parent
// about it's desired size. Should contain a JsonArray of Layouts/Elements.
json NUI_LY_Col(json jLYELE);

// A row will auto-space all elements inside of it and advise the parent
// about it's desired size. Should contain a JsonArray of Layouts/Elements.
json NUI_LY_Row(json jLYELE);


// A group, usually with a border and some padding, holding a single element. Can scroll.
// Will not advise parent of size, so you need to let it fill a span (col/row) as if it was
// a element.
json NUI_LY_Group(json jLYELE, int bBorder = TRUE, int nScroll = NUI_SCROLLBARS_AUTO);

//Elements

// A special widget that just takes up layout space.
// If you add multiple spacers to a span, they will try to size equally.
//  e.g.: [ <spacer> <button|w=50> <spacer> ] will try to center the button.
json NUI_ELE_NI_Spacer();

// Create a label field. Labels are single-line stylable non-editable text fields.
json NUI_ELE_NI_Label(json jValue, /*Bind:String*/ json jHAlign, /*Bind:Int:NUI_HALIGN_* */ json jVAlign /*Bind:Int:NUI_VALIGN_* */);

// Create a non-editable text field: This element can do multiple lines, has a skinned
// border and a scrollbar if needed.
json NUI_ELE_NI_Text(json jValue /*Bind:String*/);

// A clickable button with text as the label.
// Sends "click" events on click.
json NUI_ELE_I_Button(json jLabel /*Bind:String*/);

// A clickable button with an image as the label.
// Sends "click" events on click.
json NUI_ELE_I_ButtonImage(json jResRef /*Bind:String*/);

// A clickable button with text as the label.
// Same as the normal button, but this one is a toggle.
// Sends "click" events on click.
json NUI_ELE_I_ButtonSelect(json jLabel, /* Bind:String */ json jValue /* Bind:Bool */);

// A checkbox with a label to the right of it.
json NUI_ELE_I_Check(json jLabel, /*Bind:String*/ json jBool /*Bind:Bool*/);

// A image, with no border or padding.
json NUI_ELE_NI_Image(json jResRef,   /* Bind:String */ json jAspect,   /*Bind:Int:NUI_ASPECT_* */ json jHAlign,  /*Bind:Int:NUI_HALIGN_* */ json jVAlign  /*Bind:Int:NUI_VALIGN_* */);

//Insert into a JsonArray
json NUI_ELE_I_ComboEntry(string sLabel, int nValue);

// A combobox/dropdown.
// The bound jSelect will return nValue of the ComboEntry
// You may/should set the bound jSelect after initilization to the default value
json NUI_ELE_I_Combo(json jComEnt, /*Bind:ComboEntryArray*/  json jSelect /*Bind:Int*/);

// A floating-point slider. A good step size for normal-sized sliders is 0.01.
json NUI_ELE_I_SliderFloat(json jValue, /* Bind:Float*/ json jMin, /*Bind:Float*/ json jMax, /* Bind:Float*/ json jStepSize /* Bind:Float*/);

// A integer/discrete slider.
json NUI_ELE_I_Slider(json jValue, /* Bind:Int*/ json jMin, /*Bind:Int*/ json jMax, /* Bind:Int*/ json jStepSize /* Bind:Int*/);

// A progress bar. Progress is always from 0.0 to 1.0.
json NUI_ELE_I_Progress(json jValue /*Bind:Float*/);

// A editable text field.
// nMaxLength should be a number between 1 and 65535 inclusive
json NUI_ELE_I_TextEdit(json jPlaceholder, /*Bind:String */  json jValue, /*Bind:String */  int nMaxLength, int bMultiline);

// Insert into a JsonArray of only NUI_ELE_I_ListCell/NuiListTemplateCell
// fWidth: Float:0 = auto, >1 = pixel width
// bVariable: Cell can grow if space is available; otherwise static
json NUI_ELE_I_ListCell(json jElem,  float fWidth, int bVariable=TRUE);

// Creates a list view of elements.
// jTemplate needs to be an array of NUI_ELE_I_ListCell/NuiListTemplateCell instances.
// All binds referenced in jTemplate should be arrays of rRowCount size;
// e.g. when rendering a NuiLabel(), the bound label String should be an array of strings.
// You can pass in one of the template jRowCount into jSize as a convenience. The array
// size will be uses as the Int bind.
// jRowHeight defines the height of the rendered rows.
// For clarification: jRowCount can either be an array (where it's size is used) or an int
json NUI_ELE_I_List(json jTemplate, json jRowCount /*Bind:Int*/, float fRowHeight = NUI_STYLE_ROW_HEIGHT);

// A simple color picker, with no border or spacing.
// jColor is the selected Color
json NUI_ELE_I_ColorPicker(json jColor /*Bind:Color*/);

// A list of options (radio buttons). Only one can be selected
// at a time. jValue is updated every time a different element is
// selected. The special value -1 means "nothing".
// nDirection: NUI_DIRECTION_*
// jElements: A JsonArray of strings
json NUI_ELE_I_Options(int nDirection, json jElements, json jValue /*Bind:Int*/);

//Insert into an array of only NuiChartSlot/NUI_ELE_I_ChartSlot
// nType: NUI_CHART_TYPE_*
json NUI_ELE_I_ChartSlot(json jLegend, /*Bind:String*/  json jColor, /*Bind:NuiColor*/  json jData /*Bind:FloatArray*/, int nType = NUI_CHART_TYPE_COLUMN);

// Renders a chart.
// Currently, min and max values are determined automatically and
// cannot be influenced.
// jSlots: An Array of NUI_ELI_I_ChartSlot
json NUI_ELE_I_Chart(json jSlots);

// jScissor:Constrain painted elements to widget bounds.
// jList: An array of DrawListItems/NUI_DLI*
json NUI_ELE_NI_DrawList(json jElem, json jScissor /*Bind:Bool*/, json jList);

// Drawing

// Draw lists are raw painting primitives on top of widgets.
// They are anchored to the widget x/y coordinates, and are always
// painted in order of definition, without culling. You cannot bind
// the draw_list itself, but most parameters on individual draw_list
// entries can be bound.

// Draw Lists Items

//Insert into an array of only NUI_DLI_*
// jPoints: Always provide points in pairs
json NUI_DLI_PolyLine(json jEnabled, /*Bind:Bool*/ json jColor, /* Bind:NUI_Color */ json jFill, /*Bind:Bool*/  json jLineThickness,  /*Bind:Float*/  json jPoints /*Bind:FloatArray*/);

//Insert into an array of only NUI_DLI_*
json NUI_DLI_Curve(json jEnabled, /* Bind:Bool */ json jColor,  /*Bind:NUI_Color  */ json jLineThickness, /*Bind:Float*/  json jA, /*Bind:NUI_GEO_Vec*/ json jB, /*Bind:NUI_GEO_Vec*/ json jCtrl0, /*Bind:NUI_GEO_Vec*/ json jCtrl1 /*Bind:NUI_GEO_Vec*/);

//Insert into an array of only NUI_DLI_*
json NUI_DLI_Circle(json jEnabled, /*Bind:Bool*/  json jColor, /*Bind:NUI_Color*/  json jFill, /*Bind:Bool*/  json jLineThickness, /*Bind:Float*/ json jRect /*Bind:NUI_GEO_Rect*/);

//Insert into an array of only NUI_DLI_*
json NUI_DLI_Arc(json jEnabled,/* Bind:Bool*/  json jColor, /* Bind:NUI_Color*/ json jFill,/*Bind:Bool*/ json jLineThickness,/*Bind:Float*/ json jCenter, /*Bind:NUI_GEO_Vec*/ json jRadius, /* Bind:Float */ json jAMin, /*Bind:Float*/ json jAMax /*Bind:Float*/);

//Insert into an array of only NUI_DLI_*
json NUI_DLI_Text(json jEnabled, /*Bind:Bool*/ json jColor,/*Bind:NUI_Color*/ json jRect,/*Bind:NUI_GEO_Rect*/ json jText/*Bind:String*/);

//Insert into an array of only NUI_DLI_*
json NUI_DLI_Image(json jEnabled, /*Bind:Bool*/  json jResRef, /*Bind:String*/ json jPos,/*Bind:NUI_GEO_Rect*/ json jAspect, /*Bind:Int:NUI_ASPECT_**/ json jHAlign, /*Bind:Int:NUI_HALIGN_* */ json jVAlign /*Bind:Int:NUI_VALIGN_**/);
// Elements: Modifier

// Tag the given element with a id.
// Only tagged elements will send events (click, mouse, range) to the server.
json NUI_MOD_Id(json jElem, string sId);

//Width is in pixels
json NUI_MOD_Width(json jELEGR,  float fWidth);

//Height is in Pixels
json NUI_MOD_Height(json jELEGR,  float fHeight);


json NUI_MOD_Aspect(json jELEGR,  float fAspect);

// Set a margin on the widget. The margin is the spacing outside of the widget.
json NUI_MOD_Margin(json jELEGR,  float fMargin);

// Set padding on the widget. The margin is the spacing inside of the widget.
json NUI_MOD_Padding(json jELEGR, float fPadding);

// Disabled elements are non-interactive and greyed out.
json NUI_MOD_Enabled(json jELEGR,  json jEnabler /*Bind:Bool*/);

// Invisible elements do not render at all, but still take up layout space.
json NUI_MOD_Visible(json jElem, json jVisible /*Bind:Bool*/);

// Tooltips show on mouse hover.
json NUI_MOD_Tooltip(json jElem, json jTooltip /*Bind:String*/);

// Style the foreground color of the widget. This is dependent on the widget
// in question and only supports solid/full colors right now (no texture skinning).
// For example, labels would style their text color; progress bars would style the bar.
json NUI_MOD_Style_FG_Color(json jElem, json jColor/* Bind:NUI_Color*/);

//Geometry

//Vec2
json NUI_GEO_Vec(float x, float y);

//Rect
json NUI_GEO_Rect(float x, float y, float w, float h);

///Misc

// Create a dynamic bind. Unlike static values, these can change at runtime:
//    NuiBind("mybindlabel");
//    NuiSetBind(.., "mybindlabel", JsonString("hi"));
// To create static values, just use the json types directly:
//    JsonString("hi");
json NUI_Bind(string sId);

json NUI_Color(int r, int g, int b, int a = 255);

//Implementations
// -----------------------

json NUI_Window(json jLayout, json jTitle, json jGeometry, json jResizable, json jCollapsed, json jClosable, json jTransparent, json jBorder)
{
    return NuiWindow(jLayout, jTitle, jGeometry, jResizable, jCollapsed, jClosable, jTransparent, jBorder);
}

json NUI_Bind(string sId)
{
	return NuiBind(sId);
}

json NUI_MOD_Id(json jElem, string sId)
{
	return NuiId(jElem, sId);
}

json NUI_LY_Col(json jLYELE)
{
	return NuiCol(jLYELE);
}

json NUI_LY_Row(json jLYELE)
{
	return NuiRow(jLYELE);
}

json NUI_LY_Group(json jLYELE, int bBorder = TRUE, int nScroll = NUI_SCROLLBARS_AUTO)
{
	return NuiGroup(jLYELE, bBorder, nScroll);
}

json NUI_MOD_Width(json jELEGR,  float fWidth)
{
	return NuiWidth(jELEGR, fWidth);
}

json NUI_MOD_Height(json jELEGR,  float fHeight)
{
	return NuiHeight(jELEGR, fHeight);
}

json NUI_MOD_Aspect(json jELEGR,  float fAspect)
{
	return NuiAspect(jELEGR, fAspect);
}

json NUI_MOD_Margin(json jELEGR,  float fMargin)
{
	return NuiMargin(jELEGR, fMargin);
}

json NUI_MOD_Padding(json jELEGR,  float fPadding)
{
	return NuiPadding(jELEGR, fPadding);
}

json NUI_MOD_Style_FG_Color(json jElem, json jColor)
{
	return NuiStyleForegroundColor(jElem, jColor);
}

json NUI_Color(int r, int g, int b, int a = 255)
{
	return NuiColor(r,g,b,a);
}

json NUI_GEO_Vec(float x, float y)
{
	return NuiVec(x,y);
}

json NUI_GEO_Rect(float x, float y, float w, float h)
{
	return NuiRect(x,y,w,h);
}

json NUI_ELE_ST_Spacer()
{
	return NuiSpacer();
}

json NUI_ELE_NI_Label(json jValue, json jHAlign, json jVAlign)
{
	return NuiLabel(jValue, jHAlign, jVAlign);
}

json NUI_ELE_NI_Text(json jValue)
{
	return NuiText(jValue);
}

json NUI_ELE_I_Button(json jLabel)
{
	return NuiButton(jLabel);
}

json NUI_ELE_I_ButtonImage(json jResRef)
{
	return NuiButtonImage(jResRef);
}

json NUI_ELE_I_ButtonSelect(json jLabel, json jValue)
{
	return NuiButtonSelect(jLabel, jValue);
}

json NUI_ELE_I_Check(json jLabel, json jBool)
{
	return NuiCheck(jLabel, jBool);
}

json NUI_ELE_NI_Image(json jResRef, json jAspect, json jHAlign, json jVAlign)
{
	return NuiImage(jResRef, jAspect, jHAlign, jVAlign);
}

json NUI_ELE_I_ComboEntry(string sLabel, int nValue)
{
	return NuiComboEntry(sLabel, nValue);
}

json NUI_ELE_I_Combo(json jComEnt, json jSelect)
{
	return NuiCombo(jComEnt, jSelect);
}

json NUI_ELE_I_SliderFloat(json jValue,  json jMin, json jMax,  json jStepSize)
{
	return NuiSliderFloat(jValue, jMin, jMax, jStepSize);
}

json NUI_ELE_I_Slider(json jValue,  json jMin, json jMax,  json jStepSize)
{
	return NuiSlider(jValue, jMin, jMax, jStepSize);
}

json NUI_ELE_I_Progress(json jValue)
{
	return NuiProgress(jValue);
}

json NUI_ELE_I_TextEdit(json jPlaceholder, json jValue,  int nMaxLength, int bMultiline)
{
	return NuiTextEdit(jPlaceholder, jValue, nMaxLength, bMultiline);
}

json NUI_ELE_I_ListCell(json jElem,  float fWidth, int bVariable=TRUE)
{
	return NuiListTemplateCell(jElem, fWidth, bVariable);
}

json NUI_ELE_I_List(json jTemplate, json jRowCount, float fRowHeight = NUI_STYLE_ROW_HEIGHT)
{
	return NuiList(jTemplate, jRowCount, fRowHeight);
}

json NUI_ELE_I_ColorPicker(json jColor)
{
	return NuiColorPicker(jColor);
}

json NUI_ELE_I_Options(int nDirection, json jElements, json jValue)
{
	return NuiOptions(nDirection, jElements, jValue);
}

json NUI_ELE_I_ChartSlot(json jLegend, json jColor, json jData, int nType = NUI_CHART_TYPE_COLUMN)
{
	return NuiChartSlot(nType, jLegend, jColor, jData);
}

json NUI_ELE_I_Chart(json jSlots)
{
	return NuiChart(jSlots);
}

json NUI_DLI_PolyLine(json jEnabled, json jColor, json jFill, json jLineThickness, json jPoints)
{
	return NuiDrawListPolyLine(jEnabled, jColor, jFill, jLineThickness, jPoints);
}

json NUI_DLI_Curve(json jEnabled, json jColor, json jLineThickness, json jA, json jB, json jCtrl0, json jCtrl1)
{
	return NuiDrawListCurve(jEnabled,jColor, jLineThickness, jA,jB,jCtrl0,jCtrl1);
}

json NUI_DLI_Circle(json jEnabled, json jColor, json jFill, json jLineThickness, json jRect)
{
	return  NuiDrawListCircle(jEnabled, jColor, jFill, jLineThickness, jRect);
}

json NUI_DLI_Arc(json jEnabled, json jColor, json jFill, json jLineThickness, json jCenter, json jRadius, json jAMin, json jAMax)
{
	return NuiDrawListArc(jEnabled, jColor, jFill, jLineThickness, jCenter, jRadius, jAMin, jAMax);
}

json NUI_DLI_Text(json jEnabled, json jColor, json jRect, json jText)
{
	return NuiDrawListText(jEnabled, jColor, jRect, jText);
}

//Insert into an array of only NUI_DLI_*
json NUI_DLI_Image(json jEnabled,  json jResRef, json jPos, json jAspect, json jHAlign, json jVAlign)
{
	return NuiDrawListImage(jEnabled, jResRef, jPos, jAspect, jHAlign, jVAlign);
}

json NUI_ELE_NI_DrawList(json jElem, json jScissor, json jList)
{
	return NuiDrawList(jElem, jScissor, jList);
}
