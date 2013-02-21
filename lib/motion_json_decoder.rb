unless ENV['SKIP_RM_CHECK']
  unless defined?(Motion::Project::Config)
    raise "This file must be required within a RubyMotion project Rakefile."
  end

  Motion::Project::App.setup do |app|
    Dir.glob(File.join(File.dirname(__FILE__), 'motion_json_decoder/*.rb')).each do |file|
      app.files.unshift(file)
    end
  end
end

require 'motion_json_decoder/version'
require 'motion_json_decoder/node'
require 'motion_json_decoder/date_parser'
