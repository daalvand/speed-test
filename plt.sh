#plt

# Set default values for time limit and concurrency
TIME_LIMIT="${1:-10}"
CONCURRENCY="${2:-100}"

cd plt &&
python -m venv ./venv &&
python -m pip install --no-cache-dir -r requirements.txt &&
python rps_chart.py ab-summary-c-${CONCURRENCY}-t${TIME_LIMIT}s.csv &&
python rps_chart.py wrk-summary-c-${CONCURRENCY}-t${TIME_LIMIT}s.csv