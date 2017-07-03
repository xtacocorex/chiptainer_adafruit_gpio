# BASE OFF THE PYTHON IO CHIPTAINER
FROM xtacocorex/chiptainer_alpine_edge

RUN apk update --no-cache && \
    apk add --no-cache make && \
    apk add --no-cache gcc && \
    apk add --no-cache g++ && \
    apk add --no-cache flex && \
    apk add --no-cache bison && \
    apk add --no-cache build-base && \
    apk add --no-cache linux-headers && \
    apk add --no-cache git && \
    # DOWNLOAD PYTHON AND TOOLS FOR INSTALLING LIBRARIES
    apk add --no-cache python-dev && \
    apk add --no-cache py-setuptools && \
    # GET TOOLS FOR I2C
    apk add --no-cache i2c-tools && \
    apk add --no-cache py-smbus && \
    # GET PIP FOR SPIDEV
    apk add --no-cache py2-pip && \
    pip install --upgrade pip && \
    pip install spidev && \
    # DOWNLOAD SOURCE CODE FOR DEVICE TREE COMPILER NEEDED FOR CHIP_IO
    git clone https://github.com/NextThingCo/dtc.git && \
    # BUILD AND INSTALL THE DEVICE TREE COMPILER
    cd dtc && \
    make && \
    make install PREFIX=/usr && \
    # REMOVE THE DEVICE TREE COMPILER SOURCE CODE NOW THAT WE'VE BUILT IT
    cd .. && \
    rm dtc -rf && \
    # DOWNLOAD NTC'S CHIP OVERLAY CODE
    git clone https://github.com/NextThingCo/CHIP-dt-overlays.git && \
    cd CHIP-dt-overlays && \
    make && \
    # MAKE DIRECTORIES FOR THE DTBO AND COPY OVER
    mkdir -p /lib/firmware/nextthingco/chip/ && \
    mkdir -p /lib/firmware/nextthingco/chip/early/ && \
    cp samples/*.dtbo /lib/firmware/nextthingco/chip/ && \
    cp firmware/early/*.dtbo /lib/firmware/nextthingco/chip/early/ && \
    cd ../ && \
    # DOWNLOAD THE LATEST CHIP_IO SOURCE CODE
    git clone https://github.com/xtacocorex/CHIP_IO.git && \
    # INSTALL THE CHIP_IO LIBRARY FROM THE PROPER DIRECTORY
    cd CHIP_IO && \
    python setup.py install && \
    # REMOVE CHIP_IO SOURCE CODE DIRECTORY AFTER IT HAS BEEN INSTALLED
    cd ../ && \
    rm -rf CHIP_IO && \
    # ADAFRUIT_GPIO INSTALL
    git clone --depth=1 https://github.com/xtacocorex/Adafruit_Python_GPIO.git && \
    cd Adafruit_Python_GPIO && \
    python setup.py install && \
    cd ../ && \
    rm -rf Adafruit_Python_GPIO && \
    # REMOVE BUILD TOOLS, WHICH ARE NO LONGER NEEDED AFTER INSTALLATION
    apk del flex && \
    apk del bison && \
    apk del py-setuptools && \
    apk del gcc && \
    apk del g++ && \
    apk del make && \
    apk del linux-headers && \
    apk del py2-pip && \
    apk del git && \
    # REMOVE CACHE
    rm -rf /var/cache/apk/*

# THE ENTRY POINT
ENTRYPOINT /bin/sh
