#require 'csv'
require 'nokogiri'
require 'open-uri'

# read standard input.  expect one filename per line of input.
$stdin.each do | line |
  file = line.chomp()
  
  #doc = File.open(file) { |f| Nokogiri::XML(f) }
  f = File.open(file)
  doc = Nokogiri::XML(f) do |config|
    config.options = Nokogiri::XML::ParseOptions::STRICT 
  end

#doc = Nokogiri::XML(File.open("blossom.xml")) do |config|
#  config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NOBLANKS
#end

  puts doc.to_s

end
