FROM python:3.6

COPY ./src /app
WORKDIR /app

RUN pip install -r requirements.txt

EXPOSE 5000

ENTRYPOINT ["python", "/app/app.py"]