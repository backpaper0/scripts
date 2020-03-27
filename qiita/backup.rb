require "json"
require "net/http"

base_url = "https://qiita.com/api/v2"

username = ARGV[0]
unless username then
  puts "第1引数にユーザー名が必要"
  exit(1)
end

uri = URI.parse("#{base_url}/users/#{username}/items")
resp = Net::HTTP.get_response(uri)

unless resp.code == "200" then
  puts "記事一覧を取得できなかった"
  exit(1)
end

ids = JSON.parse(resp.body).map { |item| item["id"] }

if ids.empty? then
  puts "記事がない"
  exit(0)
end

Dir.mkdir("backup")

ids.each do |id|
  uri = URI.parse("#{base_url}/items/#{id}")
  resp = Net::HTTP.get_response(uri)
  if resp.code == "200" then
    body = JSON.parse(resp.body)["body"]
    open("backup/#{id}.md", "w") do |io|
      io.puts(body)
    end
  end
end

# TODO 画像の保存
