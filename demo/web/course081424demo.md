# Demo to run GIFT BIDS 8/14/2024 fMRI Course

A demo (gift-bids-demo.sh) is available, using a public fMRI dataset and the fMRIPrep BIDS app to preprocess and smooth the fMRI data. In 6 simple steps you may run the entire demo:

### Demo for Windows 10/11 users
1. Install Docker desktop [https://www.docker.com/products/personal](https://www.docker.com/products/docker-desktop/).
2. Open Windows power shell, create and go to working directory of your choice, that we will further call c:\users\me. then run following commands in powershell
3. ```
   Invoke-WebRequest -Uri "https://trends-public-website-fileshare.s3.amazonaws.com/public_website_files/software/gift/data/demo_input3neuromark.zip" -OutFile "demo_input3neuromark.zip"
   ```
4. ```
   cd c:\users\me\demo_input3neuromark\cfg
   ```
5. ```
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/trendscenter/gift-bids/main/demo/cfg/config_multi_ses.m" -OutFile "config_multi_ses.m"
   ```
6. ```
   docker run -ti --rm -v C:\temp:/tmp  -v C:\temp:/var/tmp -v C:\users\me\demo_input3neuromark\:/data -v C:\users\me\demo_input3neuromark\gift_out_my081424:/output  -v C:\users\me\demo_input3neuromark\cfg\:/cfg  trends/gift-bids:v4.0.5.3 /data /output participant --participant_label 007 --config /cfg/config_multi_ses.m
   ```
At first run docker has to download the GIFT Docker image that may take 15 min to download and initiate. Then the GIFT-BIDS may take 15 minutes to run and you will find an HTML report after your gift-bids run at C:\users\me\demo_input3neuromark\gift_out_my081424\neuromark_gica_results\icatb_gica_html_report.html, which you may be able to double click to open up in web browser.

-------------------------------------------------------------

### Demo for Mac users
1. Install Docker desktop [https://www.docker.com/products/personal](https://www.docker.com/products/docker-desktop/).
2. Open terminal, create and go to working directory of your choice, that we will further call ~. then run following commands in terminal
3. ```
   wget https://trends-public-website-fileshare.s3.amazonaws.com/public_website_files/software/gift/data/demo_input3neuromark.zip
   ```
4. ```
   cd ~/demo_input3neuromark/cfg
   ```
5. ```
   wget https://raw.githubusercontent.com/trendscenter/gift-bids/main/demo/cfg/config_multi_ses.m
   ```
6. ```
   docker run -ti --rm \
     -v /tmp:/tmp \
     -v /var/tmp:/var/tmp \
     -v ~/demo_input3neuromark:/data \
     -v ~/demo_input3neuromark/gift_out_my081424:/output \
     -v ~/demo_input3neuromark/cfg:/cfg \
     trends/gift-bids:v4.0.5.3 \
       /data /output participant --participant_label 007 \
       --config /cfg/config_multi_ses.m
   ```
At first run docker has to download the GIFT Docker image that may take 15 min to download and initiate. Then the GIFT-BIDS may take 15 minutes to run and you will find an HTML report after your gift-bids run at ~/demo_input3neuromark/gift_out_my081424/neuromark_gica_results/icatb_gica_html_report.html, which you may be able to double click to open up in web browser.

