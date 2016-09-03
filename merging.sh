jq -s '.[0] * .[1] * .[2] * .[3] * .[4]' pm10.parsed.json krank.parsed.json pm25.parsed.json no2.parsed.json tot.parsed.json > merged.json
