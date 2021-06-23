FROM python:3.8

WORKDIR /django_store_haiku

COPY requirements.txt requirements.txt 
RUN pip install -r requirements.txt

COPY . .


CMD [ "python", "manage.py" , "runserver", "0.0.0.0:8000"]