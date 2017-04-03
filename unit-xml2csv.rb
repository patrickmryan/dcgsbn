require 'csv'
require 'nokogiri'
require 'open-uri'

# read from stdin

file = IO.new STDIN.fileno
doc = Nokogiri::XML(file)

# a = []
csv = CSV($stdout, force_quotes: false)

headings = []
data = []

doc.css('Unit').each do |node|

  # this code will translate all of the fields that do not have sub-elements
  n = 0
  node.elements.each do |e|

    if (e.children().length() <= 1)
      headings <<  e.name()
      data <<  e.content().to_s

    end

  end

  # now get specific properties
  prop_columns = [ 'Raw Unit Name', 'Number of Enlisted', 'Number of NCOs', 'Number of Personnel', 'Number of Officers']
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

    headings << key
    data << (value ? value : '')  # use space if property not found
  end
  
  # now get lat/lon
  
  locations = doc.xpath("//Unit//Locations")
#  locations.each do |loc|
#    puts loc.to_s
#  end
#  exit

  loc = locations.first.elements.first
#  puts loc.class.to_s + " " + loc.to_s
#  exit
  [ 'Latitude', 'Longitude'].each do |key|
    prop = loc.elements.find { | e | e.name() == key }
 
    val = (prop ? prop.content() : '')  # handle case of missing field

    headings << key
    data << val
          
  end
  
    
      
  
end

csv << headings
csv << data
