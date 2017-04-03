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
  
  link_node = doc.css('LinkName')
  
  headings << 'Symbology'
  data << link_node.children.first.content().to_s 
  
  
end

# a.each { |a| csv << a }

csv << headings
csv << data
