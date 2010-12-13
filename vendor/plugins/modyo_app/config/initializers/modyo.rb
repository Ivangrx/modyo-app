require 'oauth/consumer'

::MODYO = {}

begin
  yaml_file = YAML.load_file("#{RAILS_ROOT}/config/modyo.yml")
rescue Exception => e
  raise StandardError, "config/modyo.yml could not be loaded."
end

if yaml_file
  if yaml_file[RAILS_ENV]
    MODYO.merge!(yaml_file[RAILS_ENV])
  else
    raise StandardError, "config/modyo.yml exists, but doesn't have a configuration for RAILS_ENV=#{RAILS_ENV}."
  end
else
  raise StandardError, "config/modyo.yml does not exist."
end
