
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

rand = $$
units_file="units.#{rand}.txt"
equip_file="equip.#{rand}.txt"

`ruby find-type.rb Unit #{xmldir} > #{units_file}`
`ruby find-type.rb Equipment #{xmldir} > #{equip_file}`

puts "processing Unit files"
`ruby unit-xml2csv.rb  < #{units_file} > all-units.csv`

puts "processing Equipment files"
`ruby equip-xml2csv.rb < #{equip_file} > all-equip.csv`

puts "processing Relationships"
# processing Units creates the file. then process Equipment and append the data w/o headers
`ruby rel-xml2csv.rb < #{units_file}  > all-relationships.csv`
`ruby rel-xml2csv.rb --noheaders < #{equip_file} >> all-relationships.csv`

# delete temp files
File.delete(units_file)
File.delete(equip_file)
