FROM python:3.11-alpine
ENV PYTHONUNBUFFERED 1

WORKDIR /app/

COPY . .

RUN pip install -r requirements.txt

EXPOSE 80

CMD ["uvicorn", "index:app",  "--reload", "--host", "0.0.0.0", "--port", "80", "--workers", "9", "--limit-concurrency", "1000"]