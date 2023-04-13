require_relative "../lib/create_iset"
describe CreateSet do
  context "run" do
    it "runs" do
      stub_alma_post_request(url: "conf/sets?combine=NOT&set1=31338526090006381&set2=31338526140006381", input: CreateSet.contents)
      expect(CreateSet.run).to eq(true)
    end
  end
end
