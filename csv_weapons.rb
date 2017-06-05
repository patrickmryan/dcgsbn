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

output_csv << headers + [weapon_name]

n = 1
while (n < arr_of_arrs.length)
  row = arr_of_arrs[n]

  hash = Hash.new('')
  m = 0
  weapons = []

  headers.each do | h |
    # this code assumes that the columns are in the sequence of the headers above

    hash[h] = (row[m] ? row[m] : '')

    m=m+1
  end

  [ 'antitank', 'artillery', 'ifv', 'mbt', 'mortar',  'radar' ].each do |w|
    value = hash[w]  # is there a value in this column?
    if (value)
      weapons.concat(value.split(/\s*,\s*/))   # append all the found weapons
    end
  end

  # emit a row for every weapon found
  weapons.each do |w|
    output_csv << row + [w]
  end

  n = n+1
end
exit
