require 'csv'
require 'nokogiri'

file = File.read('t1.xml')
doc = Nokogiri::XML(file)
a = []
csv = CSV.open('output.csv', 'wb') 

doc.css('Equipment').each do |node|
    a.push << node.content.split
end

a.each { |a| csv << a }

