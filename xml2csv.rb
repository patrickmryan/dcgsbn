require 'csv'
require 'nokogiri'
require 'open-uri'

# read from stdin
file = IO.new STDIN.fileno
doc = Nokogiri::XML(file)

#print doc.to_s


a = []
csv = CSV($stdout, force_quotes: false)

doc.css('Equipment').each do |node|

  n = 0
  node.elements.each do |e|
     puts "[#{n}]  #{e.name}: #{e.content}"
     n = n+1
  end
  
#  content = node.content
#   
#  if (content.is_a?(String))
#    a.push << [ content ]
#  else      
#    a.push << content.split  
#  end  

  
end

a.each { |a| csv << a }

