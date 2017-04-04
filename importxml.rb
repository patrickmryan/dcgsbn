
if (ARGV.length != 1)
  puts "usage: script directory"
end

xmldir=ARGV[0]

unit_files=`ruby find-type.rb Unit #{xmldir}`
equip_files=`ruby find-type.rb Equipment #{xmldir}`

puts "processing Unit"
`ruby unit-xml2csv.rb #{unit_files} > all-units.csv`

puts "processing Equipment"
`ruby equip-xml2csv.rb #{equip_files} > all-equip.csv`

puts "processing Relationships"
`ruby rel-xml2csv.rb #{unit_files} #{equip_files} > all-relationships.csv`

