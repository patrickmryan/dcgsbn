#!/bin/sh
#set -x

xmldir="$1"

unit_files=`ruby find-type.rb Unit $xmldir`
equip_files=`ruby find-type.rb Equipment $xmldir`

echo processing Unit
ruby unit-xml2csv.rb $unit_files > all-units.csv

echo processing Equipment
ruby equip-xml2csv.rb $equip_files > all-equip.csv

echo processing Relationships
ruby rel-xml2csv.rb $unit_files $equip_files > all-relationships.csv


