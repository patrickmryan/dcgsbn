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

doc.css('Equipment').each do |node|
  
  n = 0
  node.elements.each do |e|
    
    if (e.children().length() <= 1)    
#      csv << [ e.name(), e.content().to_s ]
      headings <<  e.name() 
      data <<  e.content().to_s 
      
    end
 
  end
  
  
end

# a.each { |a| csv << a }

csv << headings
csv << data
