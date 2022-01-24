FROM arm32v5/debian:10-slim

RUN apt-get update && apt-get install jq curl -y

ADD powermeter.sh /app/powermeter.sh
RUN chmod +x /app/powermeter.sh
WORKDIR /app/

ENTRYPOINT [ "/bin/bash", "powermeter.sh" ]