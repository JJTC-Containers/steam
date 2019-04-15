# steam
Alpine image for use with Steam (MUSL Libc)

## Status
To my knowledge this currently has no use since steamclient.so is not available for MUSL Libc,
it might be possible to make an ABI compatible alternative with Open Steam Works. Will have to look into it.

Looking for a DepotDownloader replacement that is not dependent on dotNET.

## Info
This image is only for use with Steam distributed software that does not depend on GNU Libc (Glibc) such as software written in Java.

## Usage
```
FROM: jjtc/steam:latest

RUN ddler -app 406800 -os linux -dir out-of-reach/ -validate \
    && apk update \
    && apk add --no-cache openjdk8-jre-base

EXPOSE 19933/tcp 27010/udp 27010/tcp 27016/udp 27016/tcp

VOLUME ["/home/steam/out-of-reach/xxxxxxxxxxxx"]

CMD [ "/home/steam/out-of/reach/SFS2X/sfs2x-service start" ]
```
