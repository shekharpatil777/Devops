import yaml
import json

# Read YAML file
with open("config.yaml", 'r') as file:
    config_yaml = yaml.safe_load(file)
    print(config_yaml['database']['host'])

# Read JSON file
with open("config.json", 'r') as file:
    config_json = json.load(file)
    print(config_json['server_port'])