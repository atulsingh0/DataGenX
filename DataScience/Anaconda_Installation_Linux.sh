# Download the Anaconda Python
mkdir -p /app && cd /app && wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh

# Install this Anaconda*.sh
./Anaconda3-2019.10-Linux-x86_64.sh
# It will ask to accept the Licence Agreement and the location where you want to install the Anaconda

# Check if conda is install
conda -V

# Create Virtual Env for your Project 
conda create -n nlp python=3.7

# Activate the Environemt
conda activate nlp

# Deactivate the Env
conda deavtivate