FROM arm32v5/python:3.10-slim-buster

RUN pip3 install pyserial
RUN pip3 install requests

ADD powermeter.py /app/powermeter.py
WORKDIR /app/

ENTRYPOINT [ "python3", "powermeter.py" ]