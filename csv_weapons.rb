require 'csv'

headers = ['ID',
  'URI',
  'antitank',
  'artillery',
  'ifv',
  'mbt',
  'mortar',
  'radar',
  'unit',
  'DATE',
  'DATE_FACET_ID'
  #,'Weapon Name'
]

weapon_name = 'Weapon Name'

if (ARGV.length < 1)
  puts "must specify input file"
  exit
end

arr_of_arrs = CSV.read(ARGV[0])
output_csv = CSV($stdout, force_quotes: false)

#output_csv << arr_of_arrs[0]  # write out headers

output_csv << headers + [weapon_name]

n = 1
while (n < arr_of_arrs.length)
  row = arr_of_arrs[n]

  #puts "row #{n}"
  hash = Hash.new('')
  m = 0
  weapons = []

  headers.each do | h |
    # this code assumes that the columns are in the sequence of the headers above

    hash[h] = (row[m] ? row[m] : '')

    m=m+1
  end

  [ 'ifv', 'mbt', 'mortar',  'radar' ].each do |w|
    value = hash[w]  # is there a value in this column?
    if (value)
      weapons.concat(value.split(/\s*,\s*/))   # append all the found weapons
    end
  end

  # emit a row for every weapon found
  weapons.each do |w|
    output_csv << row + [w]
  end

  #output_csv << row

  n = n+1
end
exit

#CSV.foreach(ARGV[0]) do |row|
#   puts row.to_s
#end
#exit

opts = Hash.new()
opts[:headers] = :first_row
#input_csv = CSV.new($stdin, opts)
#puts "opened input"

CSV($stdin) do |input_csv|
  input_csv.each do |row|
    puts row.to_s
  end
end
exit

output_csv = CSV($stdout, force_quotes: false)
puts "opened output"

input_csv.each do | row |
  output_csv << row

end