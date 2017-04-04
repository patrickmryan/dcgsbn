
if (ARGV.length != 1)
  puts "usage: script directory"
end

xmldir=ARGV[0]

#output=`ruby find-type.rb Unit #{xmldir}`
#words = output.split(/\s+/)
#unit_file_count = words.length()
#unit_files = words.join(' ')
#
#output=`ruby find-type.rb Equipment #{xmldir}`
#words = output.split(/\s+/)
#equip_file_count = words.length()
#equip_files = words.join(' ')


puts "processing Unit files"
`ruby find-type.rb Unit #{xmldir} | ruby unit-xml2csv.rb > all-units.csv`

puts "processing Equipment files"
`ruby find-type.rb Equipment #{xmldir} | ruby equip-xml2csv.rb > all-equip.csv`

puts "processing Relationships"
`ruby rel-xml2csv.rb #{unit_files} #{equip_files} > all-relationships.csv`

