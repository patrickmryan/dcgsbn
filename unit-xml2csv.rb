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
  
  n = 0
  node.elements.each do |e|
    
    if (e.children().length() <= 1)    
#      csv << [ e.name(), e.content().to_s ]
      headings <<  e.name() 
      data <<  e.content().to_s 
      
    end
 
  end
  
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

end

csv << headings
csv << data
