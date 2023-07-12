class_name ActiveHoverNode
extends Object

enum NodeKind {
	foreground, background, tile
}

var node_index_int: int = 0
var node_index_str: String = "0"
var node: Node2D
var node_kind: NodeKind = NodeKind.foreground
