this is a placeholder for a universal docker container that may assist users, especiall M1+ chips with running GIFT via docker rather than the host OS.

This will only work within the GSU network (direct or VPN connection is required).

#to build the container, do the following (once you've installed git package and configured your username and password):

cd #Directory_For_Cloning_Src
git clone #repo 
cd #repo
export DOCKER_DEFAULT_PLATFORM=linux/amd64 
docker build -t trends-gift .

#you should adjust your docker desktop to maximize resources that you have available where you are running docker.
export DOCKER_DEFAULT_PLATFORM=linux/amd64 
docker run -it --rm -p 8888:8888 --shm-size=512M -e MLM_LICENSE_FILE=27000@matlab.license.gsu.edu trends-gift -browser

#open your browser or type the following into a terminal: 
  open http://localhost:8888/index.html
