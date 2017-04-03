require 'csv'
require 'nokogiri'
require 'open-uri'

# read from stdin
file = IO.new STDIN.fileno
doc = Nokogiri::XML(file)

a = []
csv = CSV($stdout, force_quotes: false)

doc.css('Equipment').each do |node|
  
  n = 0
  node.elements.each do |e|
    
    if (e.children().length() <= 1)    
      csv << [ e.name(), e.content().to_s ]
    end
    
#    c = e.children
#    print "element is a " + e.class.to_s + " with " + c.length.to_s + " children, " 
#    if (e.text?)
#      print ", (text node)"
#    else
#      print ", (not text node)"
#    end
#    if (e.element?)
#      print ", (element node)"
#    else
#      print ", (not element node)"
#    end  
#    if (e.xml?)
#      print ", (xml node)"
#    else
#      print ", (not xml node)"
#    end
#    print "\n"
#
#    puts "[#{n}]  #{e.name}: #{e.content}"
#    n = n+1
    
  end
  
  
end

# a.each { |a| csv << a }

