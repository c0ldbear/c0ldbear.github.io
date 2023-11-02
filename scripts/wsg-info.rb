require 'httparty'
require 'nokogiri'
require 'json'

def get_wsg_info
    url = "https://raw.githubusercontent.com/w3c/sustyweb/main/guidelines.json"
    response = HTTParty.get(url)
    result = ""
    json_obj = {}
    result_json = []

    if response.code == 200
        wsg_json = JSON.parse(response.body)

        wsg_json["category"].each do |category|
            if !category["guidelines"].nil? 
                section_id = category[Constant::ID]
                category["guidelines"].each do |guideline|
                    json_obj[Constant::TITLE] = section_id + "." + guideline[Constant::ID].to_s + " " + guideline["guideline"]
                    json_obj[Constant::DESCRIPTION] = guideline[Constant::DESCRIPTION]
                    json_obj[Constant::IMPACT] = guideline[Constant::IMPACT]
                    json_obj[Constant::EFFORT] = guideline[Constant::EFFORT]
                    json_obj[Constant::TAGS] = guideline[Constant::TAGS]
                    result_json.append(json_obj)
                    json_obj = {}
                end
            end
        end

        result = result_json 
        # result = wsg_json.to_json
    else
        puts "Failed! #{response.code}"
    end
    result
end

class Constant
    ID = "id"
    DESCRIPTION = "description"
    TITLE = "title"
    BENEFITS = "benefits"
    IMPACT = "impact"
    EFFORT = "effort"
    TAGS = "tags"
    FILENAME = "wsg-info"
end