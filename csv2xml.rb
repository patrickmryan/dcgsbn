require 'csv'
require 'nokogiri'
require 'open-uri'


doc = Nokogiri::XML::Document.new()

equip = Nokogiri::XML::Element.new("Equipment",doc)

doc.add_child(equip)

equip.add_child("<Id>abcdefg</Id>")

puts doc.to_s
