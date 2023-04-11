require_relative "../lib/set_mtags"
describe SetTags do
  context "run" do
    it "runs" do
      time = Time.now
      formatteddate = time.strftime("%m/%d/%Y")
      unaddsetnamepattern = "OCLC_all_physical_titles_v2 - Combined - #{formatteddate}" # this is the combined set with the bigger set
      stub_alma_get_request(url: "conf/sets?set_type=ITEMIZED&q=name~#{unaddsetnamepattern}&limit=1&offset=0")
      # need to deal with 'contents'

      contents = <<-CONTENT
      {
        "parameter": [
            {
              "name": {
                "value": "task_MmsTaggingParams_boolean"
              },
              "value": "NONE"
            },
            {
              "name": {
                "value": "set_id"
              },
              "value": ""
            },
            {
              "name": {
                "value": "job_name"
              },
              "value": "Synchronize Bib records with OCLC - do not publish - "
            }
          ]
        }
        CONTENT
        stub_alma_post_request(url: "conf/jobs/M12889770000231?op=run", input: contents)

      expect(SetTags.run).to eq(true)
    end
  end
end