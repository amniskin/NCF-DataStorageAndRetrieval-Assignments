#!/bin/bash

##### to the directory containing the LayoutBFiles directory.
##### This is really just to make transporting on to the server easier.
ENVDIR=$1

#####  For release.clean  ###############
echo "releaseDate,releaseCode,SOID" > release.clean

for i in {1..9}
do
  egrep "^RELEASE\ DATE:" $ENVDIR/$i\ LAYOUT\ B\ CSV.csv |
  # If you'd like to allow null values in any of the fields, just change the + to a * by that field.
  sed -r 's/^RELEASE\ DATE:\ ([0-9\/]*)\ ,RELEASE\ CODE:\ ([-A-Za-z0-9\ ]*)\ ,SOID:\ ([0-9]+)[\ ,]*\r/\1,\2,\3/g' |
  sed '/^RELEASE.*/d' >> release.clean
done


######### For booking_addl-charge.clean #######

echo "bookingNumber,chargeType,charge,court,caseNumber" > booking_addl-charge.clean
for i in {1..9}
do
  egrep '^[^A-Za-z]' $ENVDIR/$i\ LAYOUT\ B\ CSV.csv |
  awk -F'"' -v OFS='"' '{ for (i=2; i<=NF; i+=2) gsub(",", ".", $i) } 1' |
  sed -r 's/\r//g;/^[\ ,]*$/d;s/^\"[-A-Za-z0-9\ ,\.\(\)\/]*\",([0-9]*).*$/\1/g;s/,,$//g;' |
  sed 's/^\ *,/,/g' |
  sed '/^\"ADDRESS.*$/d' |
  python script.py >> booking_addl-charge.clean
done
