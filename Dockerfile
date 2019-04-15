FROM alpine:latest AS builder

RUN echo "Need MUSL steamclient.so... Open Steam Works?"
#
#
# Build open steam works into steamclient.so for musl which should have parity with officially build steamclient.so build for Glibc by Valve.
# Use some program to verify soname file compat.
#
#

FROM mcr.microsoft.com/dotnet/core/runtime:2.2-alpine3.9

LABEL maintainer="JJTC <docker@jjtc.eu>"

#COPY --from=builder steamclient.so /usr/lib/steamclient.so 

ENV ddler_full_ver=2.3.0-hotfix1 \
	ddler_ver=2.3.0

# Get and setup DepotDownloader
RUN mkdir /usr/share/ddler \
    && cd /usr/share/ddler \
    && wget https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_${ddler_ver}/depotdownloader-${ddler_full_ver}.zip \
    && unzip depotdownloader-${ddler_full_ver}.zip \
    && rm depotdownloader-${ddler_full_ver}.zip \
    && echo "#!/usr/bin/env sh" > /usr/bin/ddler \
    && echo "dotnet /usr/share/ddler/DepotDownloader.dll \"\$@\"" >> /usr/bin/ddler \
    && chmod +x /usr/bin/ddler \
    # Create steam group and user
    && addgroup -S steam \
    && adduser -D steam -G steam

# Switch to steam user
USER steam

WORKDIR /home/steam

ENTRYPOINT [ "echo", "Use https://steamdb.info/search/?a=app&q=server or https://developer.valvesoftware.com/wiki/Dedicated_Servers_List to find the appid.\n\n\
Two examples of installing an app which is based on Java so it should run without GNU Libc:\n\
\n\
- Out of Reach Dedicated Server for Linux\n\
    ddler -app 406800 -os linux -dir out-of-reach/ -validate\n\
\n\
- Project Zomboid Dedicated Server for Linux requires a user that have bought the game to download it\n\
    ddler -app 108600 -os linux -dir project-zomboid/ -validate -username <user> -password <pass>" ]

CMD [ "ddler", "$@" ]
