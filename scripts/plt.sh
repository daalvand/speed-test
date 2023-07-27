#!/bin/bash

CSV_DIR="$(dirname "$(readlink -f "$0")")/export"

cd plt &&
python -m venv ./venv &&
python -m pip install --no-cache-dir -r requirements.txt

for filename in ${CSV_DIR}/*.csv; do
  python rps_chart.py "$filename"
done
