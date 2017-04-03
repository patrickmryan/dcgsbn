require 'csv'
require 'nokogiri'
require 'open-uri'

# read from stdin


doc = Nokogiri::XML($stdin)

csv = CSV($stdout, force_quotes: false)

rel_keys = [ 'Id',
  'LeftEntityType',
  'LeftGuid',
  'LeftName',
  'RightEntityType',
  'RightGuid',
  'RightName'
]

# write out the headers
csv << rel_keys  

relationships = doc.xpath("//Relationships")


# iterate over the relationships
relationships.first.elements.each do | rel |

  # put all the values in a hash for easy access
  hash = Hash.new('')
  rel.elements.each do |e|
    hash[e.name] = e.content()
  end

  row = rel_keys.collect { | k | hash[k] }

  # write out the row of data to the CSV
  csv << row

end

