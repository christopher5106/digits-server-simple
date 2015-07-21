bash "install-digits" do
  user "root"
  cwd "/digits"
  code <<-EOH
  wget -O cuda.deb #{node.cuda[:url]}
  dpkg -i cuda.deb
  apt-get update
  apt-get -y install cuda
  rm cuda.deb
  wget -O cudnn.tgz #{node.cudnn[:url]}
  tar xvzf cudnn.tgz
  rm cudnn.tgz
  cp cudnn-6.5-linux-x64-v2/cudnn.h /usr/local/cuda/include/
  cp cudnn-6.5-linux-x64-v2/libcudnn* /usr/local/cuda/lib64/
  rm -r cudnn-6.5-linux-x64-v2
  apt-get -y install git
  wget -O digits.tgz #{node.digits[:url]}
  tar xvzf digits.tgz
  rm digits.tgz
  cd digits-2.0/
  ./install.sh
  cd caffe
  apt-get -y install --no-install-recommends libboost-all-dev #missing
  make all --jobs=8
  cd ../digits/
  export CUDA_HOME=/usr/local/cuda
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/lib64
  ln /dev/null /dev/raw1394
  pip install -r requirements.txt
  export CAFE_HOME=/digits/digits-2.0/caffe
  ldconfig
  mkdir /digits/data/mnist -p
  python tools/download_data/main.py mnist /digits/data/mnist
  apt-get install linux-image-extra-$(uname -r)
  ./digits-server
  EOH
end
