#!/bin/sh

#1 Prepare files.

echo "-----------------------------------"
echo "Prepare files for conversion."
echo "-----------------------------------"
cd ./xl
for f in *\ *; do mv "$f" "${f// /_}"; done
ls -1 * > temp_xl_files.txt

#2 Convert to CSV format.

echo "-----------------------------------"
echo "Convert XLS to CSV format."
echo "-----------------------------------"

while read -r file
do
    csvExtension="csv"
    csvFileName=${file/xls/$csvExtension}
    echo "Converting $file to CSV."
    in2csv "$file" > ../csv/$csvFileName
done < "temp_xl_files.txt"
rm temp_xl_files.txt

#3 Replace first line of each CSV file with valid JSON compatible keys.

echo "-----------------------------------"
echo "Prepare CSV files to convert to JSON."
echo "-----------------------------------"

cd ../csv
ls -1 * > temp_csv_files.txt
keys="sno,arrival,quarantinedTill,origin,destination,houseNo,street,tehsil,district,state,pin,finalDistrict"

allCsvFiles=""
while read -r file
do
    sed -i "" "1s/.*/$keys/" "$file"
    allCsvFiles="${allCsvFiles} $file"
done < "temp_csv_files.txt"
rm temp_csv_files.txt

#4 Merge all CSV into one.

echo "-----------------------------------"
echo "Merge all CSV into one."
echo "-----------------------------------"

echo "Merging all CSV into one."
csvstack $allCsvFiles > "karnataka.csv"

#5 Convert to JSON.

echo "-----------------------------------"
echo "Convert to JSON."
echo "-----------------------------------"

echo "Converting to one JSON, might take a while . . ."
csvjson "karnataka.csv" > "karnataka.json"
mv "karnataka.json" ../../

