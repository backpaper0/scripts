require "json"

base_url = "https://qiita.com/api/v2"

username = ARGV[0]
unless username then
  puts "第1引数にユーザー名が必要"
  exit(1)
end

items = `curl -s #{base_url}/users/#{username}/items`

unless $?.exitstatus == 0 then
  puts "記事一覧を取得できなかった"
  exit(1)
end

ids = JSON.parse(items).map { |item| item["id"] }

if ids.empty? then
  puts "記事がない"
  exit(0)
end

Dir.mkdir("backup")

ids.each do |id|
  item = `curl -s #{base_url}/items/#{id}`
  if $?.exitstatus == 0 then
    body = JSON.parse(item)["body"]
    open("backup/#{id}.md", "w") do |io|
      io.puts(body)
    end
  end
end

# TODO 画像の保存
