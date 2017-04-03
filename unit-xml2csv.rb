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

csv = CSV($stdout, force_quotes: false)

csv << all_headers

# read from stdin

ARGV.each do | file |

  doc = File.open(file) { |f| Nokogiri::XML(f) }

  #file = IO.new STDIN.fileno
  #doc = Nokogiri::XML(file)

  # a = []

  doc.css('Unit').each do |node|

    row_hash = Hash.new('')

    # extract the standard info
    standard_columns.each do | name |
      set = doc.xpath("/Unit/#{name}")
      node = set.first

      row_hash[name] = node.content()

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

      #    headings << key
      #    data << (value ? value : '')  # use space if property not found

      row_hash[key] = (value ? value : '') # use space if property not found

    end

    # now get lat/lon

    locations = doc.xpath("//Unit//Locations")

    loc = locations.first.elements.first
    #  puts loc.class.to_s + " " + loc.to_s
    #  exit
    location_columns.each do |key|
      prop = loc.elements.find { | e | e.name() == key }

      row_hash[key] = (prop ? prop.content() : '')  # handle case of missing field
    end

    # finally, write out the collected data as a row to the csv file
    csv << all_headers.collect { | key | row_hash[key] }

  end

end

