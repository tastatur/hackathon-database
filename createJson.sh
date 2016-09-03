#!/bin/bash


INPUT=$1
YEAR=$2
MEASUREMENT=$3
#Parse city->ID mapping
cat ${INPUT} | jq ".stadt" | grep -v "[\{\}]" > cities.tmp
#Parse id->value (no2 etc
cat ${INPUT} | jq ".jahr_${YEAR}" | grep -v "[\{\}]" > values.tmp

##Calculate averages
#cat values.tmp | grep -v "null" | while read i; do
#  CODE=$(echo "$i" | awk -F ":" '{print $1}')
#  VALUE=$(echo "$i" | awk -F ":" '{print $2}')


#done

echo "{"
cat values.tmp | grep -v "null" | while read i; do
  CODE=$(echo "$i" | awk -F ":" '{print $1}')
  VALUE=$(echo "$i" | awk -F ":" '{print $2}')
  CITY=$(cat cities.tmp | grep "$CODE" |  awk -F ":" '{print $2}')
  echo "${CITY}:{ \"${MEASUREMENT}\": $VALUE }" | sed "s/,//"
done
echo "}"

rm cities.tmp
rm values.tmp
