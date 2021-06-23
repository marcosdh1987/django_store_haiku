FROM python:3.8-slim-buster

WORKDIR /django_store_haiku

COPY requirements.txt requirements.txt 
RUN pip install -r requirements.txt

COPY . .