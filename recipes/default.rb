bash "install-digits" do
  user "root"
  cwd "/home/ubuntu"
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
  export CAFE_HOME=../caffe
  mkdir /home/ubuntu/data/mnist -p
  python tools/download_data/main.py mnist /home/ubuntu/data/mnist
  apt-get install linux-image-extra-$(uname -r)
  ./digits-server
  EOH
end
