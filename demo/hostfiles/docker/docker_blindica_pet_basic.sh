#!/bin/bash

docker run -ti --rm \
  -v /tmp:/tmp \
  -v /var/tmp:/var/tmp \
  -v /home/cyrus/ext4max/fromSsd/Documents/trends/work/2023/jeremy/keater/docker110825/spect_bids/:/data \
  -v /home/cyrus/ext4max/fromSsd/Documents/trends/work/2023/jeremy/keater/docker110825/spect_bids/derivatives/20blind/:/out \
  -v /home/cyrus/ext4max/fromSsd/Documents/trends/work/2023/jeremy/keater/docker110825/spect_bids/code/cfg/:/cfg \
  trends/gift-bids:v4.0.5.3 \
    /data /out participant --participant_label 01 \
    --config /cfg/input_blind_pet.m
