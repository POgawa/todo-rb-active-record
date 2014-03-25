require 'active_record'
require 'rspec'
require 'shoulda-matchers'

require 'task'
require 'category'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.after(:each) do
    Task.all.each { |task| task.destroy }
  end
end
