
if (ARGV.length != 1)
  puts "usage: script directory"
end

xmldir=ARGV[0]

output=`ruby find-type.rb Unit #{xmldir}`

# whack the newlines, rejoin with spaces
#unit_files = output.split(/\s+/).join(' ')

words = output.split(/\s+/)
unit_file_count = words.length()
unit_files = words.join(' ')

output=`ruby find-type.rb Equipment #{xmldir}`
words = output.split(/\s+/)
equip_file_count = words.length()
equip_files = words.join(' ')


puts "processing #{unit_file_count} Unit files"
`ruby unit-xml2csv.rb #{unit_files} > all-units.csv`

puts "processing #{equip_file_count} Equipment files"
`ruby equip-xml2csv.rb #{equip_files} > all-equip.csv`

puts "processing Relationships"
`ruby rel-xml2csv.rb #{unit_files} #{equip_files} > all-relationships.csv`

