FROM ubuntu:22.04

MAINTAINER TReNDS Center Cyrus Eierud <ceierud@gsu.edu>

# Initiation of system
RUN apt-get update -y \
 && apt-get install wget unzip libxext-dev libxt-dev libxmu-dev libglu1-mesa-dev libxrandr-dev -y \
 && mkdir -p /tmp_mcr \
 && cd /tmp_mcr \
 && wget https://ssd.mathworks.com/supportfiles/downloads/R2016b/deployment_files/R2016b/installers/glnxa64/MCR_R2016b_glnxa64_installer.zip \
 && wget https://ssd.mathworks.com/supportfiles/downloads/R2016b/deployment_files/R2016b/installers/glnxa64/MCR_R2016b_Update_6_glnxa64.sh \
 && unzip MCR_R2016b_glnxa64_installer.zip \
 && ./install -destinationFolder /usr/local/MATLAB/MATLAB_Runtime/ -mode silent -agreeToLicense yes \
 && chmod +x MCR_R2016b_Update_6_glnxa64.sh \
 && ./MCR_R2016b_Update_6_glnxa64.sh \
 && mkdir -p /app \ 
 && rm -rf /tmp_mcr \
 && wget -P /app https://trendscenter.org/trends/software/gift/software/bids/groupica
# groupica is compiled using MATLAB version R2016b.

# Environment variables
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu/:/usr/local/MATLAB/MATLAB_Runtime/v91/:/usr/local/MATLAB/MATLAB_Runtime/v91/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v91/bin/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v91/sys/os/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v91/sys/java/jre/glnxa64/jre/lib/amd64/native_threads:/usr/local/MATLAB/MATLAB_Runtime/v91/sys/java/jre/glnxa64/jre/lib/amd64/server:/usr/local/MATLAB/MATLAB_Runtime/v91/sys/java/jre/glnxa64/jre/lib/amd64
ENV XAPPLRESDIR=/usr/local/MATLAB/MATLAB_Runtime/v91/X11/app-defaults
ENV MCR_CACHE_VERBOSE=true
ENV MCR_CACHE_ROOT=/tmp
ENV PATH=$PATH:/app:
ENV MATLAB_VER=R2016b
ENV GICA_VER=v4.0c
ENV GICA_INSTALL_DIR=/app/

# Building entrypoint
COPY run.sh *.m  /app/
WORKDIR /app
RUN chmod +x /app/groupica
ENTRYPOINT ["/app/run.sh"]

