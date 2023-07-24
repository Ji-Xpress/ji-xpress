extends Object
class_name RecentProjects

# Constants
const prop_hash: String = "hash"
const prop_path: String = "path"
const prop_time: String = "time"


## Return the dict template
static func model_template():
	return {
	}


## Generates metadata for a single entry
static func generate_entry_metadata(path: String):
	return {
		prop_hash: path.hash(),
		prop_path: path,
		prop_time: Time.get_date_string_from_system()
	}
