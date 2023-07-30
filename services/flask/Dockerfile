FROM python:3.11-alpine
ENV PYTHONUNBUFFERED 1

WORKDIR /app/

COPY . .

RUN pip install -r requirements.txt

EXPOSE 80

CMD ["gunicorn", "-w", "9", "index:app", "-b", "0.0.0.0:80", "--worker-connections", "1000"]
