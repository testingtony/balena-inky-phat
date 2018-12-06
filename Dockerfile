ARG pi=raspberry-pi
ARG python=3.6
FROM resin/${pi}-alpine-python:${python} as builder

# Set our working directory
WORKDIR /usr/src/app

# Copy requirements.txt first for better cache on later pushes
COPY ./requirements.txt /requirements.txt

RUN [ "cross-build-start" ]
RUN apk add --no-cache freetype-dev libc-dev linux-headers
RUN pip install --install-option="--prefix=/install" -r /requirements.txt
RUN [ "cross-build-end" ]

FROM resin/${pi}-alpine-python:${python}-slim

RUN [ "cross-build-start" ]
RUN apk add --no-cache freetype libjpeg
RUN [ "cross-build-end" ]

COPY --from=builder /install /usr/local

