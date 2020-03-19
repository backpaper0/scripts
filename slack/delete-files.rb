require "slack-ruby-client"

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

client = Slack::Web::Client.new
client.auth_test

files = client.files_list.files

files.each { |file|
  puts "delete file: #{file.name}"
  client.files_delete(file: file.id)
  sleep 1
}
