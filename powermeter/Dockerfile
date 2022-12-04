FROM arm32v5/python:3.11-slim-bullseye

RUN apt-get update && apt-get install python3-serial -y

ADD powermeter.py /app/powermeter.py
WORKDIR /app/

ENTRYPOINT [ "python", "powermeter.py" ]