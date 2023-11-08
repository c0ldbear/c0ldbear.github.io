require 'httparty'
require 'nokogiri'
require 'json'

def get_wsg_info
    url = "https://raw.githubusercontent.com/w3c/sustyweb/main/guidelines.json"
    response = HTTParty.get(url)
    result = ""

    if response.code == 200
        result = create_wsg_json(JSON.parse(response.body))
    else
        puts "Failed! #{response.code}"
    end
    result
end

def create_wsg_json(wsg_json)
    json_obj = {}
    result_json = []

    wsg_json[Constant::CATEGORY].each do |category|
        if !category["guidelines"].nil? 
            section_id = category[Constant::ID]
            section_name = category[Constant::NAME]
            category["guidelines"].each do |guideline|
                json_obj[Constant::TITLE] = section_id + "." + guideline[Constant::ID].to_s + " " + guideline["guideline"]
                json_obj[Constant::CATEGORY] = {
                    Constant::ID => section_id,
                    Constant::TITLE => section_name
                }
                json_obj[Constant::DESCRIPTION] = guideline[Constant::DESCRIPTION]
                json_obj[Constant::IMPACT] = guideline[Constant::IMPACT]
                json_obj[Constant::EFFORT] = guideline[Constant::EFFORT]
                json_obj[Constant::TAGS] = guideline[Constant::TAGS]
                result_json.append(json_obj)
                json_obj = {}
            end
        end
    end

    return result_json
end

class Constant
    CATEGORY = "category"
    ID = "id"
    NAME = "name"
    DESCRIPTION = "description"
    TITLE = "title"
    BENEFITS = "benefits"
    IMPACT = "impact"
    EFFORT = "effort"
    TAGS = "tags"
    FILENAME = "wsg-info"
end