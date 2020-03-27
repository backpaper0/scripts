require "net/https"
require "json"

org = ARGV[0]

unless org then
  puts "第1引数にorganization名が必要"
  exit(1)
end

path = "https://api.github.com/orgs/#{org}/repos"

while path do

  resp = Net::HTTP.get_response(URI.parse(path))

  exit(1) if resp.code != "200"
  if resp.code != "200" then
    puts "#{resp.code} #{resp.message}"
    exit(1)
  end

  repos = JSON.parse(resp.body, symbolize_names: true)

  # 標準出力へリポジトリURLを書き出す
  puts repos.map { |repo| repo[:clone_url] }

  # Linkヘッダーをパースして次のページを取得する
  link = resp.header["link"].split(/\s*,\s*/)
    .map { |a| /<([^>]+)>;\s*rel="([^"]+)"/.match(a) }
    .map { |a| [a[1], a[2]]}
    .find { |a| a[1] == "next" } if resp.header["link"]

  path = nil
  path = link[0] if link

end

