require_relative "../lib/create_iset"
describe CreateSet do
  context "run" do
    it "runs" do
      logger = instance_double(Logger, info:nil)
      stub_alma_post_request(url: "conf/sets?combine=NOT&set1=#{ENV.fetch("SET_WITH_ALL_TITLES")}&set2=#{ENV.fetch("SET_WITHOUT_ACQ")}", input: CreateSet.contents)
      expect(CreateSet.run(logger)).to eq(true)
    end
  end
end
