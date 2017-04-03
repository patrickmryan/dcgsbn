require 'csv'
require 'nokogiri'
require 'open-uri'




# iterate over the files listed on the command line

if (ARGV.length != 2)
  puts "syntax: ruby find-type.rb entity-type directory"
  exit 1
end

entity_type = ARGV[0]
directory = ARGV[1]


Dir.entries(directory).each do | entry |
  filename = "#{directory}/#{entry}"
  if (/.*\.xml$/.match(filename))  # only read xml files
    doc = File.open(filename) { |f| Nokogiri::XML(f) }
      node = doc.children.first
      if (node.name() == entity_type)
        # the entity in this file matches the desired entity type
        puts filename
      end
      
  end
  
end 
