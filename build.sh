#!/bin/bash
cd bash/

./configure
make clean
make -j$(nproc)

cp ./bash ../bin/bash

echo "Success!"
echo "bVsh written to: ./bin/bash"
