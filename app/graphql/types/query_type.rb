module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :all_links, [LinkType], null: false,
      description: "An example field added by the generator"
    def all_links
      Link.all
    end

    field :a_name_age, String, null: false,
      description: "One Link"
    def a_name_age
      response=HTTParty.get("https://api.agify.io?name=michael")
      return response['name'] + ' ' + response['age'].to_s
    end

    field :track_detail, String, null: false,
      description: "Tracking detail from Canada Post API"
    def track_detail
      response=HTTParty.get('https://soa-gw.canadapost.ca/vis/track/pin/<pin>/detail', {
        headers: {"User-Agent" => "Httparty", "Authorization" => "Basic <base64-encoded username:password>"}#,
        #debug_output: STDOUT, # To show that User-Agent is Httparty
      })
      
      xml_response = response.body
      hash_data = Hash.from_xml(xml_response)
      print hash_data['tracking_detail']['destination_postal_id']      
      return hash_data['tracking_detail']['destination_postal_id'][0, 3]
    end
  end
end
