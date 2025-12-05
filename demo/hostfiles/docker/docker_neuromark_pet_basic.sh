#!/bin/bash

docker run -ti --rm \
  -v /tmp:/tmp \
  -v /var/tmp:/var/tmp \
  -v /home/cyrus/ext4max/fromSsd/Documents/trends/work/2023/jeremy/keater/docker111925/spect_bids/:/data \
  -v /home/cyrus/ext4max/fromSsd/Documents/trends/work/2023/jeremy/keater/docker111925/spect_bids/derivatives/05/:/out \
  -v /home/cyrus/ext4max/fromSsd/Documents/trends/work/2023/jeremy/keater/docker111925/spect_bids/code/cfg/:/cfg \
  trends/gift-bids:v4.0.5.3 \
    /data /out participant --participant_label 01 02 03 04 05 06 07 08 09 10\
    --config /cfg/input_neuromark_pet.m

# 111925 --config /cfg/input_sbm_neuromark111925a.m
