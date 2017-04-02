require 'csv'
require 'nokogiri'
require 'open-uri'


doc = Nokogiri::XML::Document.new()

equip = Nokogiri::XML::Element.new("Equipment",doc)

doc.add_child(equip)

equip.add_child("<Id>abcdefg</Id>")
#puts "equip class = " + equip.class.to_s + "\n"

secinfo = Nokogiri::XML::Element.new("SecurityInfo",doc)
#puts "secinfo class = " + secinfo.class.to_s + "\n"

equip.add_child(secinfo)

#secinfo.add_child("<ClassificationInfo>")

sec_tags = [ "ClassificationInfo", "DeclassificationInfo", "OwnerProducer", "SecurityID" ]
  
sec_tags.each do |tag|
  secinfo.add_child("<#{tag}>")
  
end


puts doc.to_s
