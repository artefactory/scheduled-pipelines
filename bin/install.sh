#!/bin/bash -e

read -p "Want to install conda env named 'scheduled-pipelines'? (y/n)" answer
if [ "$answer" = "y" ]; then
  echo "Installing conda env..."
  conda create -n scheduled-pipelines python=3.10 -y
  source $(conda info --base)/etc/profile.d/conda.sh
  conda activate scheduled-pipelines
  echo "Installing requirements..."
  pip install -r requirements-developer.txt
  python3 -m ipykernel install --user --name=scheduled-pipelines
  conda install -c conda-forge --name scheduled-pipelines notebook -y
  conda install grpcio # See issue https://stackoverflow.com/a/73245207/13891969
  echo "Installing pre-commit..."
  make install_precommit
  echo "Installation complete!";
else
  echo "Installation of conda env aborted!";
fi
