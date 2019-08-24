require "slack-ruby-client"

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

client = Slack::Web::Client.new
client.auth_test

channels = client.channels_list.channels

channel = channels.find { |c| c.name == "general" }.id

files = client.files_list(channel: channel).files

files.each { |file|
  puts "delete file: #{file.name}"
  client.files_delete(file: file.id)
  sleep 1
}
