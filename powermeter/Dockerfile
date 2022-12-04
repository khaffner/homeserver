FROM arm32v5/python:3.10-slim-buster

RUN apt-get update && apt-get install python3-serial -y

ADD powermeter.py /app/powermeter.py
WORKDIR /app/

ENTRYPOINT [ "python3", "powermeter.py" ]