require 'fileutils'

print "enter name of cab file > "
line = gets
cabfile = line.chomp()


home = ENV['userprofile']

desktop = "#{home}/Desktop"
target = "#{desktop}/DCGS-files"
scripts = "#{home}/scripts"

unless File.directory?(target)
        FileUtils.mkdir_p(target)
end

xmldir = "#{target}/xmldir"
unless File.directory?(xmldir)
  FileUtils.mkdir_p(xmldir)
end

cmd = "7z x -o#{xmldir} -aoa -bd #{cabfile}"

# run the command
`#{cmd}`

rand = $$
units_file="#{target}/units.#{rand}.txt"
equip_file="#{target}/equip.#{rand}.txt"

`ruby #{scripts}/find-type.rb Unit #{xmldir} > #{units_file}`
`ruby #{scripts}/find-type.rb Equipment #{xmldir} > #{equip_file}`

csvname = "#{target}/all-units.csv"
puts "processing Unit files"
`ruby #{scripts}/unit-xml2csv.rb  < #{units_file} > #{csvname}`
puts "created #{csvname}"

csvname = "#{target}/all-equip.csv"
puts "processing Equipment files"
`ruby #{scripts}/equip-xml2csv.rb < #{equip_file} > #{csvname}`
puts "created #{csvname}"

csvname = "#{target}/all-relationships.csv"
puts "processing Relationships"
# processing Units creates the file. then process Equipment and append the data w/o headers
`ruby #{scripts}/rel-xml2csv.rb < #{units_file}  > #{csvname}`
`ruby #{scripts}/rel-xml2csv.rb --noheaders < #{equip_file} >> #{csvname}`
puts "created #{csvname}"

# delete temp files
File.delete(units_file)
File.delete(equip_file)

puts
puts "CSV files are located in #{target}."
puts 'Hit ENTER to finish.'
gets

