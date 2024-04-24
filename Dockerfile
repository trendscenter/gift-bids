FROM ubuntu:22.04
MAINTAINER TReNDS Center Cyrus Eierud <ceierud@gsu.edu>

# Initiation of system
RUN export MCR_CACHE_VERBOSE=true
RUN apt-get update -y \
 && apt-get install wget unzip libxext-dev libxt-dev libxmu-dev libglu1-mesa-dev libxrandr-dev -y \
 && mkdir -p /tmp_mcr \
 && cd /tmp_mcr \
 && wget https://ssd.mathworks.com/supportfiles/downloads/R2022b/Release/9/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2022b_Update_9_glnxa64.zip \
 && unzip MATLAB_Runtime_R2022b_Update_9_glnxa64.zip \
 && ./install -destinationFolder /usr/local/MATLAB/MATLAB_Runtime/ -mode silent -agreeToLicense yes \
 && mkdir -p /app \
 && rm -rf /tmp_mcr \
 && wget -P /app https://trends-public-website-fileshare.s3.amazonaws.com/public_website_files/software/gift/software/bids/v4.0.5.2M2022b/groupica
# groupica is compiled using MATLAB version R2022b.

# Environment variables
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu/:/usr/local/MATLAB/MATLAB_Runtime/R2022b/:/usr/local/MATLAB/MATLAB_Runtime/R2022b/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/R2022b/bin/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/R2022b/sys/os/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/R2022b/sys/java/jre/glnxa64/jre/lib/amd64/native_threads:/usr/local/MATLAB/MATLAB_Runtime/R2022b/sys/java/jre/glnxa64/jre/lib/amd64/server:/usr/local/MATLAB/MATLAB_Runtime/R2022b/sys/java/jre/glnxa64/jre/lib/amd64
ENV XAPPLRESDIR=/usr/local/MATLAB/MATLAB_Runtime/R2022b/X11/app-defaults
ENV MCR_CACHE_VERBOSE=true
ENV MCR_CACHE_ROOT=/tmp
ENV PATH=$PATH:/app:
ENV MATLAB_VER=R2022b
ENV GICA_VER=v4.0.5.2
ENV GICA_INSTALL_DIR=/app/

# Building entrypoint
COPY run.sh gica_bids_app.m /app/
WORKDIR /app
RUN chmod +x /app/groupica
ENTRYPOINT ["/app/run.sh"]
