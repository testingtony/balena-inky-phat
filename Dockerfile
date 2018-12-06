ARG pi=raspberry-pi
FROM resin/${pi}-alpine-python:3 as builder

# Set our working directory
WORKDIR /usr/src/app

# Copy requirements.txt first for better cache on later pushes
COPY ./requirements.txt /requirements.txt

RUN [ "cross-build-start" ]
RUN apk add --no-cache freetype-dev
RUN pip install --install-option="--prefix=/install" -r /requirements.txt
RUN [ "cross-build-end" ]

FROM resin/${pi}-alpine-python:3-slim

RUN [ "cross-build-start" ]
RUN apk add --no-cache freetype libjpeg
RUN [ "cross-build-end" ]

COPY --from=builder /install /usr/local

WORKDIR /usr/src/app

# CMD ["python", "name-badge.py", "-t", "phat", "-c", "red"]
