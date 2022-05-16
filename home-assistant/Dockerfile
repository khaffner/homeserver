FROM homeassistant/home-assistant:2022.5.4

# See readme for usage

# As of 2022.5 home-assistant is based on alpine 3.15: https://github.com/home-assistant/docker-base#base-images
# Pwsh must be compatible, see https://docs.microsoft.com/en-us/powershell/scripting/install/install-alpine?view=powershell-7.2#supported-versions
# But also, see the tag listing here: https://hub.docker.com/_/microsoft-powershell
# The current alpine version might just be there.
# If yes, copy from Dockerfile, paste below and adjust
# If no, try building locally first and cross fingers. As of 2022.5, seems to work.

# install the requirements
RUN apk add --no-cache \
  ca-certificates \
  less \
  ncurses-terminfo-base \
  krb5-libs \
  libgcc \
  libintl \
  libssl1.1 \
  libstdc++ \
  tzdata \
  userspace-rcu \
  zlib \
  icu-libs \
  curl

RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
  lttng-ust

# Download the powershell '.tar.gz' archive
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.2.3/powershell-7.2.3-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz

# Create the target folder where powershell will be placed
RUN mkdir -p /opt/microsoft/powershell/7

# Expand powershell to the target folder
RUN tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7

# Set execute permissions
RUN chmod +x /opt/microsoft/powershell/7/pwsh

# Create the symbolic link that points to pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh