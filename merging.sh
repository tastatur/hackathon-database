jq -s '.[0] * .[1] * .[2] * .[3]' pm10.parsed.json krank.parsed.json pm25.parsed.json no2.parsed.json > merged.json
