extends Object
class_name SharedEnums

## When a node is added to the canvas what is the mode its in?
enum NodeCanvasMode {
	ModeDesign, ModeRun
}

## Determines what layer an object fits into
enum ObjectLayer {
	LayerForeground, LayerBackground, LayerTile, LayerUI
}

## For property types
enum PropertyType {
	TypeString, TypeInt, TypeFloat, TypeDropDown, TypeBool
}
