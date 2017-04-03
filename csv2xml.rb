require 'csv'
require 'nokogiri'
require 'open-uri'


csv = CSV($stdin)

n = 1
csv.each do |row|
  puts "row #{n}"
  row.each do |col|
    puts "    #{col} "
  end
  print "\n"
  n = n+1
end
exit


doc = Nokogiri::XML::Document.new()
doc.encoding=("UTF-8")
doc['standalone'] = 'yes'
  
#doc.keys.each do |key|
#  puts "#{key} -> " + doc[key] + "\n"
#end

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
  child = secinfo.add_child("<#{tag}>test data</#{tag}>")
  
end


#puts doc.to_s

doc.write_to(IO.new(STDOUT.fileno), :encoding => 'UTF-8')
