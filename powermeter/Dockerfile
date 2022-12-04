FROM arm32v5/python:3.10-slim-buster

RUN pip3 install pyserial

ADD powermeter.py /app/powermeter.py
WORKDIR /app/

ENTRYPOINT [ "python3", "powermeter.py" ]