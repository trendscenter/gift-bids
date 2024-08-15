# Demo to run GIFT BIDS 081424

### Demo for Mac users
A demo (gift-bids-demo.sh) is available, using a public fMRI dataset and the fMRIPrep BIDS app to preprocess and smooth the fMRI data. In 6 simple steps you may run the entire demo:
1. Install Docker desktop ([https://www.docker.com/products/personal](https://www.docker.com/products/docker-desktop/).
2. Open terminal, create and go to working directory of your choice, that we will further call ~. then run following commands in terminal
3. wget https://trends-public-website-fileshare.s3.amazonaws.com/public_website_files/software/gift/data/demo_input3neuromark.zip
4. cd ~/demo_input3neuromark/cfg
5. wget https://github.com/trendscenter/gift-bids/blob/main/demo/cfg/config_multi_ses.m
6. test
```
$ docker run -ti --rm \
  -v /tmp:/tmp \
  -v /var/tmp:/var/tmp \
  -v ~/demo_input3neuromark:/data \
  -v ~/demo_input3neuromark/gift_out_my081424run:/output \
  -v ~/demo_input3neuromark/cfg:/cfg \
  trends/gift-bids:v4.0.5.3 \
    /data /output participant --participant_label 007 \
    --config /cfg/config_multi_ses.m
```

At first run docker has to download the GIFT Docker image that may take 15 min to download and initiate. Then the GIFT-BIDS may take 15 minutes to run and you will find an HTML report after your gift-bids run at ~/demo_input3neuromark/gift_out_my081424run/neuromark_gica_results/icatb_gica_html_report.html, which you may be able to double click to open up in web browser.
