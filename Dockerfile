FROM python:3

#RUN apk update
#RUN apk add --no-cache python3 py3-pip
#RUN pip3 install --upgrade pip 
#RUN apk add mpc1-dev
#RUN apk add --no-cache --virtual .build-deps gcc musl-dev 

WORKDIR /app

COPY obmovies /app/obmovies
COPY tests /app/tests
COPY migrations /app/migrations
COPY requirements.txt /app
COPY pytest.ini /app
COPY .ini /app
COPY run.py /app
COPY base.txt /app

EXPOSE 5000

RUN pip install -r requirements.txt

ENTRYPOINT [ "python3", "/app/run.py", "--host", "0.0.0.0" ]