#!/bin/bash


INPUT=$1
FIELD=$2
MEASUREMENT=$3
NAME=$4
#Parse city->ID mapping
cat ${INPUT} | jq ".stadt" | grep -v "[\{\}]" > cities.tmp
#Parse id->value (no2 etc
cat ${INPUT} | jq ".${FIELD}" | grep -v "[\{\}]" > values.tmp

#City-value
cat values.tmp | grep -v "null" | while read i; do
  CODE=$(echo "$i" | awk -F ":" '{print $1}' | sed "s/,//" )
  VALUE=$(echo "$i" | awk -F ":" '{print $2}' | sed "s/,//" )
  CITY=$(cat cities.tmp | grep "$CODE" |  awk -F ":" '{print $2}' | sed "s/,//")

  echo "${CITY}:${VALUE}" >> values.c.tmp
done

##Calculate averages

cat values.c.tmp | grep -v "null" | while read i; do
  CODE=$(echo "$i" | awk -F ":" '{print $1}')
  VALUE=$(echo "$i" | awk -F ":" '{print $2}')

  AVERAGE=$(cat values.c.tmp | grep -v "null" | grep "${CODE}" | awk -F ":" '{print $2}' | sed "s/,//" | bash ./avg.sh)
  echo "${CODE}:{ \"${MEASUREMENT}\": {\"average\": $AVERAGE, \"name\":\"${NAME}\"} }," >> tmp
done


rm *.tmp

echo "{"
cat tmp | sort -u
echo "}"
rm tmp
