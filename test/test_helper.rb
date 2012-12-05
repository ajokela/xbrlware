require 'test/unit'

require 'xbrlware'
require 'edgar'

require 'tmpdir'

begin
  require 'java'
  require File.dirname(__FILE__) + '/schema_validator_jruby'
rescue Exception
  ENV["SCHEMA_VALIDATION"]="False"
  require File.dirname(__FILE__) + '/schema_validator_ruby'
end


$LOG.level = Logger::INFO




