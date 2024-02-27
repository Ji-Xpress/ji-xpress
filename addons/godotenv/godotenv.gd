@tool
extends Node

# Constants for .env file location
const FILE_NAME: String = ".env"
const FILE_PATH: String = "res://%s" % FILE_NAME

# Prefix for error and warning messages, make easier to identify the source
const ERROR_PREFIX: String = "GodotEnv: "

# Possible warnings and errors to make it easier to re-use and add if needed
var prompt: Dictionary = {
	"creating_dotenv_file": ".env file doesn't exists. Creating one at %s..." % FILE_PATH,
	"already_exists": "A variable called %s already exists, use argument override=true to override it.",
	"need_dotenv": "You need a .env file to create or read an environment variable",
	"creation_error": "Could not create .env file at %s."
}

# Every KEY=VALUE pair from .env will be parsed into this dictionary
var environment: Dictionary = {}

func _init() -> void:
	environment = get_parsed_env()

# Custom function to prompt error and warning messages
func prompt_message(msg: String, error: bool = false) -> void:
	if error:
		push_error(ERROR_PREFIX + msg)
	else:
		push_warning(ERROR_PREFIX + msg)

func get_parsed_env() -> Dictionary:
	var env_variables: Dictionary
	var dot_env: FileAccess = FileAccess.open(FILE_PATH, FileAccess.READ)
	if not dot_env == null:
		prompt_message(prompt.creating_dotenv_file)
		_create_dotenv()
		return env_variables
	
	while !dot_env.eof_reached():
		var line: String = dot_env.get_line()
		if line == "":
			continue
		var env_var: Array = line.split("=")
		
		# It's not a KEY=VALUE pair, skip it
		if len(env_var) < 2:
			continue
		
		env_variables[env_var[0]] = env_var[1]

	dot_env.close()
	return env_variables

func overwrite_dotenv() -> void:
	var dot_env: FileAccess = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	if not dot_env == null:
		var new_content: String
		for key in environment.keys():
			new_content += "%s=%s" % [key, environment[key]]
			var last_key: String = environment.keys()[len(environment) - 1]
			if key != last_key:
				new_content += "\n"
		dot_env.store_string(new_content)

func create_var(variable_name: String, value: String, overwrite: bool = false) -> void:
	if not FileAccess.file_exists(FILE_PATH):
		prompt_message(prompt.need_dotenv, true)
		return

	if environment.has(variable_name) and not overwrite:
#		Prevent user from accidentally overwriting an env var
		prompt_message(prompt.already_exists % variable_name)
		return
	elif environment.has(variable_name) and overwrite:
#		Overwrite an already existing env variable
		environment[variable_name] = value
		overwrite_dotenv()
		return
	
	var dot_env: FileAccess = FileAccess.open(FILE_PATH, FileAccess.READ_WRITE)
	if not dot_env == null:
		dot_env.seek_end()
	#	Append the new env var to the end of an existing .env file
		dot_env.store_string("\n%s=%s" % [variable_name, value])
		dot_env.close()
		environment = get_parsed_env()

func get_var(variable_name: String) -> String:
	if environment.has(variable_name):
		return environment[variable_name]

	push_warning("%s not found into %s. Returning ' %s ' zero value." % [variable_name, FILE_PATH, "\"\""])
	return ""

func _create_dotenv() -> void:
	var dot_env: FileAccess = FileAccess.open(FILE_PATH, FileAccess.WRITE)
#	Creates the .env file. Pushes an error cause it already exists.
	if not dot_env == null:
		dot_env.close()
	else:
		prompt_message(prompt.creation_error % FILE_PATH)
