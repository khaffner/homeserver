FROM arm32v5/debian:bullseye-slim

RUN apt-get install mosquitto-clients -y

ADD script.sh /app/script.sh
RUN chmod +x /app/script.sh

CMD [ "/app/script.sh" ]