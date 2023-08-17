### Tab Management Logic

The Main UI situated at `res://main_ui.tscn` manages how the tabs are working. The variables tracking how tabs work are as follows:

```gdscript
## Keeps track of current open tabs
var current_open_tabs: Dictionary = {}
## Keeps track of tab control requesting an action
var requesting_tab_instance_control: Control = null
## Keeps track of the curren tab type
var current_tab_type: TabType = TabType.TabNone
## Keeps track of the current scene name
var current_scene_name: String = ""
## Keeps track of the current script name
var current_script_name: String = ""
## Tab tracker dictionary
var tab_number_tracker: Dictionary = {}
```

The following are ways the tabs are being managed:

```gdscript
## Close the tab
func on_canvas_close_request(node_instance: Control, scene_id: String):
    # What is the index of the removed tab?
    var removed_tab_index: int = current_open_tabs[scene_id]
    # Lets iterate down the next set of open tab indexes
    current_open_tabs.erase(scene_id)

    if tab_number_tracker.has(str(removed_tab_index)):
        tab_number_tracker.erase(str(removed_tab_index))

    # Handle situation where the tab is in the middle of others so that we can keep track
    for tab in current_open_tabs:
        if current_open_tabs[tab] >= removed_tab_index:
            # Re arrange the tab tracker
            if tab_number_tracker.has(str(current_open_tabs[tab])):
                tab_number_tracker[str(current_open_tabs[tab] - 1)] = tab_number_tracker[str(current_open_tabs[tab])]
                tab_number_tracker.erase(str(current_open_tabs[tab]))

            # Re-orient the current open tab index
            current_open_tabs[tab] -= 1

# An object has been selected from the tree
func _on_project_tree_ui_object_selected(object_metadata):
    var object_index: int = object_metadata[GameObjectsLoader.prop_object_index]
    var object_id: String = object_metadata[GameObjectsLoader.prop_object_id]
    var object_url: String = object_metadata[GameObjectsLoader.prop_object_url]
    var script_file_name = object_id + Constants.scripts_extension
    
    # Set the current tab type to Scene Type
    current_tab_type = TabType.TabCode
    
    # Open or create the relevant tab's content
    if not current_open_tabs.has(script_prefix + script_file_name):
        # New canvas scene instance
        var new_script_canvas: Control = script_ui.instantiate()
        # Track the scene name in the new control
        new_script_canvas.script_name = script_file_name
        new_script_canvas.is_new_file = not ProjectManager.script_file_exists(script_file_name)
        new_script_canvas.object_index = object_index
        # Add to the tab container
        tab_container.call_deferred("add_child", new_script_canvas)
        
        new_script_canvas.connect("tab_close_request", Callable(self, "on_script_canvas_close_request"))
        
        # Track the child control 
        await tab_container.child_entered_tree
        
        # Assign current tab to current file
        var tab_index: int = tab_container.get_child_count() - 1
        current_open_tabs[script_prefix + script_file_name] = tab_index
        
        # Open as current active tab and set tab title
        tab_switch_timer.start()
        await tab_switch_timer.timeout
        
        tab_container.current_tab = tab_index
        tab_container.set_tab_title(tab_index, script_file_name)
        
        # Track the tab
        tab_number_tracker[str(tab_index)] = {
            prop_tab_tab_type: TabType.TabCode,
            prop_tab_tab_name: script_file_name
        }
        
        current_script_name = script_file_name
    else:
        tab_container.current_tab = current_open_tabs[script_prefix + script_file_name]


# A scene has been selected from the tree
func _on_project_tree_ui_scene_selected(scene_name):
    # Set the current tab type to Scene Type
    current_tab_type = TabType.TabScene

    # Open or create the relevant tab's content
    if not current_open_tabs.has(scene_name):
        # Create a new tab control ...

        # Track the child control 
        await tab_container.child_entered_tree

        # Assign current tab to current file
        var tab_index: int = tab_container.get_child_count() - 1
        current_open_tabs[scene_name] = tab_index

        # Open as current active tab and set tab title
        tab_switch_timer.start()
        await tab_switch_timer.timeout

        tab_container.current_tab = tab_index
        tab_container.set_tab_title(tab_index, scene_name)

        # Track the tab
        tab_number_tracker[str(tab_index)] = {
            prop_tab_tab_type: TabType.TabScene,
            prop_tab_tab_name: scene_name
        }

        current_scene_name = scene_name
    else:
        tab_container.current_tab = current_open_tabs[scene_name]


# Set the current tab metadata
func _on_tab_container_tab_changed(tab):
    if tab_number_tracker.has(str(tab)):
        current_tab_type = tab_number_tracker[str(tab)][prop_tab_tab_type]
        if current_tab_type == TabType.TabScene:
            current_scene_name = tab_number_tracker[str(tab)][prop_tab_tab_name]
        else:
            current_scene_name = ""
```