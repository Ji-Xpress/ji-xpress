extends Object
class_name JSONUtils


## Convert a JSON string to class
static func json_string_to_class(json_string: String, _class: Object) -> Object:
	var json = JSON.new()
	var parse_result: Error = json.parse_string(json_string)
	if parse_result == Error.OK:
		return json_to_class(json.data, _class)
	
	return _class


## Convert a JSON dictionary into a class
static func json_to_class(json: Dictionary, _class: Object) -> Object:
	var properties: Array = _class.get_property_list()
	for key in json.keys():
		for property in properties:
			if property.name == key and property.usage >= (1 << 13):
				if (property["class_name"] in ["Reference", "Object"] and property["type"] == 17):
					_class.set(key, json_to_class(json[key], _class.get(key)))
				else:
					_class.set(key, json[key])
				break
			if key == property.hint_string and property.usage >= (1 << 13):
				if (property["class_name"] in ["Reference", "Object"] and property["type"] == 17):
					_class.set(property.name, json_to_class(json[key], _class.get(key)))
				else:
					_class.set(property.name, json[key])
				break
	return _class


## Convert a class into JSON string
static func class_to_json_string(_class: Object) -> String:
	return JSON.stringify(class_to_json(_class))


## Convert class to JSON dictionary
static func class_to_json(_class: Object) -> Dictionary:
	var dictionary: Dictionary = {}
	var properties: Array = _class.get_property_list()
	for property in properties:
		if not property["name"].is_empty() and property.usage >= (1 << 13):
			if (property["class_name"] in ["Reference", "Object"] and property["type"] == 17):
				dictionary[property.name] = class_to_json(_class.get(property.name))
			else:
				dictionary[property.name] = _class.get(property.name)
		if not property["hint_string"].is_empty() and property.usage >= (1 << 13):
			if (property["class_name"] in ["Reference", "Object"] and property["type"] == 17):
				dictionary[property.hint_string] = class_to_json(_class.get(property.name))
			else:
				dictionary[property.hint_string] = _class.get(property.name)
	return dictionary
