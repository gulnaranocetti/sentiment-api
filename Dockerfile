# Dockerfile
FROM python:3.9-alpine

RUN apk add --no-cache gcc g++ musl-dev libffi-dev curl

WORKDIR /app

COPY requirements.txt .
COPY app.py sentiment_model.py ./

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
CMD ["python", "app.py"]