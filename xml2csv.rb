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
  node.content.split.each do | f |
    print "[#{n}] #{f}\n"
    n = n + 1
    a.push << [ f ]
  end

#  contents = node.content.split
#  if (contents.length == 1)
#    a.push << contents
#  else
#    joined = contents.join(' ')
#    a.push << [ joined ]
#  end


  #a.push << '"'
  
end

#a.each { |a| csv << a }

