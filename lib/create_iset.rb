require "logger"
require "alma_rest_client"
module CreateSet
  # This script creates an itemized set by combining the two sets: OCLC_every_physical_title_with_acquisition_v2 NOT OCLC_every_physical_title_except_acquisition_v2.
  # The combined set which results consists of all acq-only Physical Titles in Alma.
  def self.contents
    {
      "status" => {
        "desc" => "Active",
        "value" => "ACTIVE"
      },
      "description" => nil,
      "origin" => {
        "desc" => "Institution only",
        "value" => "UI"
      },
      "note" => nil,
      "query" => nil,
      "members" => nil,
      "link" => "",
      "private" => {
        "desc" => "No",
        "value" => "false"
      },
      "type" => {
        "desc" => "Itemized",
        "value" => "ITEMIZED"
      },
      "content" => {
        "value" => "IEP"
      },
      "created_by" => {
        "desc" => "API, Ex Libris",
        "value" => "exl_api"
      }
    }.to_json
  end

  def self.run(logger = Logger.new($stdout))

    # set1 = 31337200330006381 #OCLC_every_physical_title_with_acquisition_v2
    # set2 = 22766924310006381 #OCLC_every_physical_title_except_acquisition_v2
     set1 = 31338526090006381 # set of one record
     set2 = 31338526140006381 # set of one record
    operator = "NOT" # AND OR NOT

    logger.info "Combining sets: #{set1} #{operator} #{set2}."
    conn = Faraday.new do |f|
      f.options.timeout = 600
    end
    response = AlmaRestClient.client(conn).post("conf/sets?combine=#{operator}&set1=#{set1}&set2=#{set2}", body: contents)
    # response = connection.post do |req|
    # req.url "https://api-na.hosted.exlibrisgroup.com/almaws/v1/conf/sets?combine=#{operator}&set1=#{set1}&set2=#{set2}"
    # req.headers[:content_type] = 'application/json'
    # req.headers[:Accept] = 'application/json'
    # req.headers[:Authorization] = "apikey #{apikey}"
    # req.body = contents
    # req.options.timeout = 600 #this gives it 10 minutes
    # end

    # puts JSON.pretty_generate(JSON.parse(response.body))
    # puts response.body
    logger.info "Response status: " + response.status.to_s
    begin
      logger.info "Set created id: " + response.body["id"]
      logger.info "Set created name: " + response.body["name"]
    rescue Exception => e
      logger.info "Alma didn't return the expected information"
    end
    true
  end
end
