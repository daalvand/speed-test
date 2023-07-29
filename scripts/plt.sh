#!/bin/bash

USE_DOCKER="${1:-1}"
BASE_DIR=$(dirname "$(dirname "$(readlink -f "$0")")")
CSV_DIR="${BASE_DIR}/export"

cd "$BASE_DIR"

if [ "$USE_DOCKER" = "1" ]; then
  docker-compose build plt
else
  cd './plt' && python -m venv ./venv && source ./venv/bin/activate && pip install -r requirements.txt
fi

generate_chart() {
  local file="$1"
  local base_name=$(basename "$file" .csv)
  local output_file="${CSV_DIR}/${base_name}.png"

  if [ "$USE_DOCKER" = "1" ]; then
    docker-compose run --rm plt "$(cat "$file")" >"$output_file"
  else
    python3 ./rps_chart.py "$(cat "$file")" >"$output_file"
  fi
}

for file in "${CSV_DIR}"/*.csv; do
  generate_chart "$file"
done
