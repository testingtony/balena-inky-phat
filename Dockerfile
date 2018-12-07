ARG pi=raspberry-pi
FROM resin/${pi}-alpine as builder

ARG python=3.6
ENV PYTHON_VERSION=$python	

# Set our working directory
WORKDIR /usr/src/app

# Copy requirements.txt first for better cache on later pushes
COPY ./requirements.txt /requirements.txt

RUN [ "cross-build-start" ]
RUN if [ "${PYTHON_VERSION:0:1}" == "3" ] ; then \
      apk add --no-cache py3-numpy py3-pillow gcc python3-dev \
                         libc-dev linux-headers && \
      pip3 install --install-option="--prefix=/install" -r /requirements.txt ; \
    else \
      apk add --no-cache py-numpy py-pillow gcc python-dev py2-pip \
                         libc-dev linux-headers && \
      pip install --install-option="--prefix=/install" -r /requirements.txt ; \
    fi
RUN [ "cross-build-end" ]

# Once more but without the dev libraries
FROM resin/${pi}-alpine

ARG python=3.6

ENV PYTHON_VERSION=$python	
RUN [ "cross-build-start" ]
RUN if [ "${PYTHON_VERSION:0:1}" == "3" ] ; then \
      apk add --no-cache py3-numpy py3-pillow python3; \
      ln -s /usr/bin/python3 /usr/bin/python; \
      ln -s /usr/bin/pip3 /usr/bin/pip; \
    else \
      apk add --no-cache py-numpy py-pillow py2-pip python2; \
    fi
RUN [ "cross-build-end" ]

COPY --from=builder /install /usr

