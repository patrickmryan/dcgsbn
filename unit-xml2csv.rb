require 'csv'
require 'nokogiri'
require 'open-uri'

#if (ARGV.length == 0)
#  puts "specify at least one input file on the command line"
#  exit 1
#end

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
  "CurrentStrength",
  "Echelon",
  "EchelonAlias",
  "FunctionalRole",
  "FunctionalRoleAlias",
  "Identification",
  "InitialStrength",
  "Number",
  "OrgType",
  "OrgTypeAlias",
  "ParentEchelon",
  "ParentEchelonAlias",
  "ParentFunctionalRole",
  "ParentFunctionalRoleAlias",
  "ParentIdentification",
  "ParentNumber",
  "ParentOrgType",
  "ParentOrgTypeAlias"]

prop_columns = [ 'Raw Unit Name', 'Number of Enlisted', 'Number of NCOs',
  'Number of Personnel', 'Number of Officers']

location_columns = [ 'Latitude', 'Longitude']

# collect all of the headers
all_headers = Array.new(standard_columns)
all_headers.concat(prop_columns)
all_headers.concat(location_columns)
all_headers <<  'LinkName' 

csv = CSV($stdout, force_quotes: true)

# write out the headers
csv << all_headers

entity_name = 'Unit'

# read standard input.  expect one filename per line of input.
$stdin.each do | line |
  file = line.chomp()
  if (!File.exists?(file))
    puts "#{file}: cannot open"
    exit
  end
  doc = File.open(file) { |f| Nokogiri::XML(f) }

  #doc.css(entity_name).each do |node|
  node = doc.at_css(entity_name)

  row_hash = Hash.new('')

  # extract the standard info
  standard_columns.each do | name |
    results = doc.xpath("/#{entity_name}/#{name}")
    row_hash[name] = (!results.empty? ? results.first.content : '') 
    
  end

  # now get specific properties
  nodeset = doc.css('PropertyValues')
  property_values = nodeset.first.elements

  prop_columns.each do | key |

    value = nil
    property_values.each do |val|
      name = val.elements.find { |e | e.name() == 'PropertyName' }
      if (name.content() == key)
        value = val.elements.find { |e | e.name() == 'Value' }
      end
    end

    row_hash[key] = (value ? value : '') # use space if property not found

  end

  # now get lat/lon
  results = doc.xpath("/#{entity_name}/Locations/Location")

  if (!results.empty?)
    loc = results.first

    location_columns.each do |key|
      prop = loc.elements.find { | e | e.name() == key }
      row_hash[key] = (prop ? prop.content() : '')  # handle case of missing field
    end
  end

  # fix unit Number
  k = 'Number'
  row_hash[k] = "'" + row_hash[k]  # prepend a single quote to force Excel to import at text

  # get the LinkName
  name = 'LinkName'
  results = doc.xpath("/#{entity_name}/Multimedias/Multimedia/#{name}")
  row_hash[name] = (!results.empty? ? results.first.content : '') 
    
  # finally, write out the collected data as a row to the csv file
  csv << all_headers.collect { | key | row_hash[key] }

  #end

end

