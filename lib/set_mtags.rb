require "logger"
require "alma_rest_client"
module SetTags
  def self.run(time = Time.now, logger = Logger.new($stdout))
    # Retrieve the setid of the set to be used with the Set Management Tags job
    formatteddate = time.strftime("%m/%d/%Y")
    unaddsetnamepattern = "OCLC_all_physical_titles_v2 - Combined - #{formatteddate}" # this is the combined set with the bigger set
    # unaddsetnamepattern = "OCLC_every_physical_title_with_acquisition_v2 - Combined - #{formatteddate}" #this is the combined set with the smaller set
    # puts unaddsetnamepattern

    # apikey = (ENV["ALMA_API_KEY"]).to_s

    # connection = Faraday.new
    response = AlmaRestClient.client.get("conf/sets?set_type=ITEMIZED&q=name~#{unaddsetnamepattern}&limit=1&offset=0")
    # response = connection.get do |req|
    #  req.url "https://api-na.hosted.exlibrisgroup.com/almaws/v1/conf/sets?set_type=ITEMIZED&q=name~#{unaddsetnamepattern}&limit=1&offset=0"
    #  req.headers[:content_type] = "application/json"
    #  req.headers[:Accept] = "application/json"
    #  req.headers[:Authorization] = "apikey #{apikey}"
    # end
    # puts JSON.pretty_generate(JSON.parse(response.body))
    begin
      unaddsetid = response.body["set"][0]["id"]
      unaddsetname = response.body["set"][0]["name"]
      logger.info "Set retrieved id: #{unaddsetid} name: #{unaddsetname}"
      logger.info "Starting the Set Management Tags job..."
    rescue
      logger.info "Alma didn't return the expected information"
    end

    flag_action = "NONE"
    job_name = "Synchronize Bib records with OCLC - do not publish"
    contents =
      {
        "parameter" => [
          {
            "name" => {
              "value" => "task_MmsTaggingParams_boolean"
            },
            "value" => flag_action.to_s
          },
          {
            "name" => {
              "value" => "set_id"
            },
            "value" => unaddsetid.to_s
          },
          {
            "name" => {
              "value" => "job_name"
            },
            "value" => "#{job_name} - #{unaddsetname}"
          }
        ]
      }.to_json

    response = AlmaRestClient.client.post("conf/jobs/M12889770000231?op=run", body: contents)

    if response.status != 200
      logger.error "Failed to submit job"
      exit
    end

    # response2 = connection.post do |req|
    #  req.url "https://api-na.hosted.exlibrisgroup.com/almaws/v1/conf/jobs/M12889770000231?op=run"
    #  req.headers[:content_type] = "application/json"
    # req.headers[:content_type] = 'application/xml'
    #  req.headers[:Accept] = "application/json"
    #  req.headers[:Authorization] = "apikey #{apikey}"
    #  req.body = contents
    #  req.options.timeout = 600 # this gives it 10 minutes
    # end
    # puts response2.body
    # puts " "
    # puts response2.status
    logger.info "Set Management Tags job submitted."
    true
  end
end
