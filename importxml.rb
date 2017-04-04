require 'fileutils'

print "enter name of cab file > "
line = gets
cabfile = line.chomp()

xmldir = "xmldir"
unless File.directory?(xmldir)
  FileUtils.mkdir_p(xmldir)
end

cmd = "7z x -o#{xmldir} -aoa -bd #{cabfile}"

# run the command
`#{cmd}`

rand = $$
units_file="units.#{rand}.txt"
equip_file="equip.#{rand}.txt"

`ruby find-type.rb Unit #{xmldir} > #{units_file}`
`ruby find-type.rb Equipment #{xmldir} > #{equip_file}`

csvname = 'all-units.csv'
puts "processing Unit files"
`ruby unit-xml2csv.rb  < #{units_file} > #{csvname}`
puts "created #{csvname}"

csvname = 'all-equip.csv'
puts "processing Equipment files"
`ruby equip-xml2csv.rb < #{equip_file} > #{csvname}`
puts "created #{csvname}"

csvname = 'all-relationships.csv'
puts "processing Relationships"
# processing Units creates the file. then process Equipment and append the data w/o headers
`ruby rel-xml2csv.rb < #{units_file}  > #{csvname}`
`ruby rel-xml2csv.rb --noheaders < #{equip_file} >> #{csvname}`
puts "created #{csvname}"

# delete temp files
File.delete(units_file)
File.delete(equip_file)
