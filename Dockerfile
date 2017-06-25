# BASE OFF THE PYTHON IO CHIPTAINER
FROM nextthingco/chiptainer_python_io

# SWITCH ALPINE FROM V3.5 TO EDGE
RUN sed -i -e 's/v3\.5/edge/g' /etc/apk/repositories && \
    sed -i -e '$i http://dl-cdn.alpinelinux.org/alpine/edge/testing\n' /etc/apk/repositories && \
    # UPDATE ALPINE
    apk upgrade --update-cache --available && \
    # INSTALL THE THINGS
    apk add build-base && \
    apk add i2c-tools && \
    apk add py-smbus && \
    apk add py-setuptools && \
    apk add git && \
    # STUFF REQUIRED FOR PIP
    apk add gcc && \
    apk add g++ && \
    apk add make && \
    apk add linux-headers && \
    apk add py2-pip && \
    pip install --upgrade pip && \
    pip install spidev && \
    # ADAFRUIT_GPIO INSTALL
    git clone --depth=1 https://github.com/xtacocorex/Adafruit_Python_GPIO.git && \
    cd Adafruit_Python_GPIO && \
    python setup.py install && \
    cd ../ && rm -rf Adafruit_Python_GPIO && \
    # Remove unneeded packages once build is complete.
    apk del py-setuptools && \
    apk del gcc && \
    apk del g++ && \
    apk del make && \
    apk del linux-headers && \
    apk del py2-pip && \
    apk del git && \
    # CLEAN APK CACHE
    rm -rf /var/cache/apk/*

# THE ENTRY POINT
ENTRYPOINT /bin/sh
