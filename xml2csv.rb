require 'csv'
require 'nokogiri'

# read from stdin
file = IO.new STDIN.fileno

doc = Nokogiri::XML(file)
a = []
#csv = CSV.open('output.csv', 'wb')
#csv = CSV.open(IO.new STDOUT.fileno, 'wb')

# write CSV to stdout
csv = CSV($stdout)

doc.css('Equipment').each do |node|
    a.push << node.content.split
end

a.each { |a| csv << a }

