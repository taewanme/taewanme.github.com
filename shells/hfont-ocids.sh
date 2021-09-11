#!/bin/bash

wget https://raw.githubusercontent.com/taewanme/oci-utils/master/datascience/nanum-font/install_nanum_font.sh
chmod 755 ./install_nanum_font.sh
sh ./install_nanum_font.sh

wget https://raw.githubusercontent.com/taewanme/oci-utils/master/datascience/nanum-font/check_font.py -O check.py
chmod 755 ./check.py
echo "====List of Nanum Fonts in Matplotlib."
python ./check.py

rm -f ./install_nanum_font.sh
rm -f ./check.py

echo ""
echo "====Guide for Configuring Nanum Font.===="
echo "#configure Nanum font for matplotlib with the next code into the jupyter cell."
echo "import matplotlib.pyplot as plt"
echo "plt.rcParams['font.family']='NanumGothic'"
echo ""


