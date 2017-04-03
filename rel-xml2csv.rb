require 'csv'
require 'nokogiri'
require 'open-uri'

# iterate over the files listed on the command line

if (ARGV.length == 0)
  puts "specify at least one input file on the command line"
  exit 1
end


csv = CSV($stdout, force_quotes: false)

rel_keys = [ 'Id',
  'LeftEntityType',
  'LeftGuid',
  'LeftName',
  'RightEntityType',
  'RightGuid',
  'RightName',
  'TypeAlias'
]

# write out the headers
csv << rel_keys

ARGV.each do | file |
  
  doc = File.open(file) { |f| Nokogiri::XML(f) }

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

end