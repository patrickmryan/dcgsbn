require 'csv'
require 'nokogiri'
require 'open-uri'

# iterate over the files listed on the command line

if (ARGV.length == 0)
  puts "specify at least one input file on the command line"
  exit 1
end

standard_columns =
["Id",
  "Url",
  "Name",
  "DateAsOf",
  "DateCreated",
  "DateLastModified",
  "EntityHistoryUrl",
  "Affiliation",
  "Allegiance",
  "AllegianceAlias",
  "IntelligenceEvaluation",
  "SymbolCode",
  "Azimuth",
  "Category",
  "EquipmentCode",
  "LocationReason",
  "Nomenclature",
  "NomenclatureAlias",
  "Quantity"]

#prop_columns = [ 'Raw Unit Name', 'Number of Enlisted', 'Number of NCOs',
#  'Number of Personnel', 'Number of Officers']

#location_columns = [ 'Latitude', 'Longitude']

# collect all of the headers
all_headers = Array.new(standard_columns)
#all_headers.concat(prop_columns)
#all_headers.concat(location_columns)

csv = CSV($stdout, force_quotes: false)

# write out the headers
csv << all_headers

entity_name = 'Equipment'

ARGV.each do | file |
  doc = File.open(file) { |f| Nokogiri::XML(f) }

  #doc.css(entity_name).each do |node|
  node = doc.at_css(entity_name)

  row_hash = Hash.new('')

  # extract the standard info
  standard_columns.each do | name |
    set = doc.xpath("/#{entity_name}/#{name}")

    if set.length > 0
      node = set.first
      value = node.content()
    else
      value = ''
    end
    row_hash[name] = value

  end

  # finally, write out the collected data as a row to the csv file
  csv << all_headers.collect { | key | row_hash[key] }

  #end

end

