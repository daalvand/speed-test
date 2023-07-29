#!/bin/bash

BASE_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")"
CSV_DIR="${BASE_DIR}/export"

cd "${BASE_DIR}"

docker-compose build plt

for FILE in ${CSV_DIR}/*.csv; do
  # Get the BASE_NAME of the file (without the path)
  BASE_NAME=$(BASE_NAME "$FILE" .csv)
  # Call docker-compose and save the output as a PNG
  docker-compose run --rm plt "$(cat "$FILE")" > "${CSV_DIR}/${BASE_NAME}.png"
done
