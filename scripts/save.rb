require './wsg-info'
require 'json'

wsg_json = get_wsg_info()

File.open("../data/v1/" + Constant::FILENAME+".json", "wb") { |json|
    json.write(JSON.pretty_generate(wsg_json))
}

puts ">> Finished!"