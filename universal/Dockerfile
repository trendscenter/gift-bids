FROM mathworks/matlab:r2023b
# Switch to root user temporarily to install Git
USER root
# Install Git
RUN apt-get update -y \
 && apt-get install -y git wget
# Switch back to the default non-root user for MATLAB
USER $MATLAB_USER
# Create directory structure with correct permissions
RUN mkdir -p /app/trends && chmod 777 /app
# Set the working directory
WORKDIR /app/trends
# Clone the git repository
RUN git clone https://github.com/trendscenter/gift.git
RUN wget https://trends-public-website-fileshare.s3.amazonaws.com/public_website_files/software/gift/data/example_subjects.zip
RUN unzip example_subjects.zip
RUN rm -fr example_subjects.zip
RUN cd /app/trends
RUN mv /app/trends/gift/GroupICAT /app/trends/gift/GroupICATv4.0b
# Set environment variables
ENV PATH=$PATH:/app
RUN echo "addpath(genpath('/app/trends/gift/GroupICATv4.0b')); savepath;" >> /app/trends/startup.m

