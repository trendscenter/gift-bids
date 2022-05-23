# GIFT BIDS-App
### GIFT under BIDS-Apps using Docker
![TReNDS](https://trendscenter.org/wp-content/uploads/2019/06/background_eeg_1.jpg)
### Table of Contents
1. [Introduction](#secIntro)
2. [Usage](#secUsage)
3. [Demo](#secDemo)
4. [Version](#secVer)
### Introduction <a name="secIntro"></a>
This BIDS-App (gift-bids) works after Docker is installed and does not need any other application such as MATLAB since a compiled MATLAB engine is used. The gift-bids app implements multiple algorithms for independent component analysis and blind source separation of group (and single subject) functional magnetic resonance imaging data.
### Usage <a name="secUsage"></a>
After Docker is properly installed you can download your gift-bids image from the internet (https://hub.docker.com/u/trends) by following:
```
$ docker pull trends/gift-bids
```
To run gift-bids you need: 
1. A directory with image files in accordance with the BIDS format (my_data)
2. An empty output directory (gift_out) you may create
3. A configuration directory with your configuration file and change the syntax of YYY in accordance with box below and your configuration file.
4. Choose subject you want to process, by replacing XX with that subject number in box below and you may run:
```
$ docker run -ti --rm \
  -v /tmp:/tmp \
  -v /var/tmp:/var/tmp \
  -v /path/to/local/bids/input/my_data/:/data \
  -v /path/to/local/gift_out/:/output \
  -v /path/to/local/cfg/:/cfg \
  trends/gift-bids \
    /data /output participant --participant_label XX \
    --config /cfg/config_YYY.m
```
### Demo <a name="secDemo"></a>
A demo (gift-bids-demo.sh) is available, using a public fMRI dataset and the fMRIPrep BIDS app to preprocess and smooth the fMRI data. In 6 simple steps you may run the entire demo:
1. Install Docker (https://www.docker.com/products/personal).
2. Open terminal, create and go to working directory of your choice.
3. Clone or unzip the https://github.com/trendscenter/gift-bids repository to the root of your working directory.
4. Download the ds005.tar dataset from https://drive.google.com/drive/folders/0B2JWN60ZLkgkMGlUY3B4MXZIZW8?resourcekey=0-EYVSOlRbxeFKO8NpjWWM3w into the demo directory. This ds005.tar dataset is described at the BIDS App tutorial web page (https://bids-apps.neuroimaging.io/tutorial).
5. If you do not have a free FreeSurfer license you need to apply for the license file by registering according with the link https://surfer.nmr.mgh.harvard.edu/registration.html and then place your FreeSurfer license.txt file into the demo directory.
6. Finally this script (gift-bids-demo.sh) may be run in terminal by: 
```
$ cd demo
$ chmod +x gift-bids-demo.sh
$ ./gift-bids-demo.sh
```
After this Docker may download images for fmriprep and bids/gift containers (if needed)). It will then run fmriprep for a single subject which may take 2h or more. Finally bids/gift will run for at least 5 min. Results may be found under ds005-gift-out directory
### Version <a name="secVer"></a>
GIFT-BIDS-Apps-Scripts=1.000
GIFT-Linux-Compile=1.000