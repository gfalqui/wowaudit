# Dependencies
require 'require_all'
require 'sequel'
require 'rbattlenet'
require 'typhoeus'
require 'aws-sdk'
require 'date'
require 'mysql2'
require 'yaml'
require 'tzinfo'
require 'csv'

# File Storage
storage_data = YAML::load(File.open('config/storage.yml'))
Aws.config.update(
  endpoint: storage_data["endpoint"],
  access_key_id: storage_data["access_key"],
  secret_access_key: storage_data["secret_access_key"],
  region: storage_data["region"]
)
STORAGE = Aws::S3::Resource.new
BUCKET = storage_data["bucket"]

# Load keys
keys = YAML::load(File.open('config/keys.yml'))
BNET_KEY = keys["bnet_key"]
WCL_KEY = keys["wcl_key"]

begin
  # Connections
  DB = Sequel.connect(YAML::load(File.open('config/database.yml')))
  DB2 = Mysql2::Client.new(YAML::load(File.open('config/database.yml')))

  # Modules
  require_rel 'constants'
  require_rel 'models'
  require_rel 'sections'
  require_rel 'utils'

rescue Mysql2::Error
  # The SQL proxy isn't always instantly available on server reboot
  # Therefore, retry connection after 5 seconds have passed
  puts "Connection to the database failed. Trying again in 5 seconds."
  sleep 5
  retry
end
