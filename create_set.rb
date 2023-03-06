require "faraday"
#This script creates an itemized set by combining the two sets: OCLC_every_physical_title_with_acquisition_v2 NOT OCLC_every_physical_title_except_acquisition_v2.
#The combined set which results consists of all acq-only Physical Titles in Alma.
contents = <<-CONTENT
{
   "status" : {
      "desc" : "Active",
      "value" : "ACTIVE"
   },
   "description" : null,
   "origin" : {
      "desc" : "Institution only",
      "value" : "UI"
   },
   "note" : null,
   "query" : null,
   "members" : null,
   "link" : "",
   "private" : {
      "desc" : "No",
      "value" : "false"
   },
   "type" : {
      "desc" : "Itemized",
      "value" : "ITEMIZED"
   },
   "content" : {
      "value" : "IEP"
   },
   "created_by" : {
     "desc" : "API, Ex Libris",
     "value" : "exl_api"
   }
}
CONTENT

set1 = 31337200330006381 #OCLC_every_physical_title_with_acquisition_v2
set2 = 22766924310006381 #OCLC_every_physical_title_except_acquisition_v2
#set1 = 31338526090006381 #set of one record
#set2 = 31338526140006381 #set of one record
operator = 'NOT' #AND OR NOT
apikey = "#{ENV["ALMA_API_KEY"]}" #Sandbox

puts "Combining sets: #{set1} #{operator} #{set2}."

connection = Faraday.new(
)

response = connection.post do |req|
  req.url "https://api-na.hosted.exlibrisgroup.com/almaws/v1/conf/sets?combine=#{operator}&set1=#{set1}&set2=#{set2}"
  req.headers[:content_type] = 'application/json'
  req.headers[:Accept] = 'application/json'
  req.headers[:Authorization] = "apikey #{apikey}"
  req.body = contents
  req.options.timeout = 600 #this gives it 10 minutes
end

  #puts JSON.pretty_generate(JSON.parse(response.body))
  #puts response.body
  puts "Response status: " + response.status.to_s
begin
  puts "Set created id: " + JSON.parse(response.body)['id']
  puts "Set created name: " + JSON.parse(response.body)['name']
rescue Exception => e
  puts "The Alma API response was not JSON."
end