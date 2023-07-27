#!/bin/bash

CSV_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")/export"

cd plt &&
python3 -m venv ./venv &&
python3 -m pip install --no-cache-dir -r requirements.txt

for filename in ${CSV_DIR}/*.csv; do
  python3 rps_chart.py "$filename"
done
