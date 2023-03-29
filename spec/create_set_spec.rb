require_relative "../lib/management_tags"
describe ManagementTags do
  
  context "run" do
    it "runs" do
      stub_alma_post_request(url: "conf/sets?combine=NOT&set1=31338526090006381&set2=31338526140006381", input: ManagementTags.contents) 
      expect(ManagementTags.run).to eq(true)
    end
  end
end
