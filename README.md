#Fast Launch of a NVIDIA DIGITS Server in AWS Opsworks

This Chef recipe launch a NVIDIA DIGITS Server on Ubuntu 14.04.

Create a repository in which you put a `Berksfile` with the following line:

    cookbook 'digits-server-simple', git: 'git://github.com/christopher5106/digits-server-simple.git'

Create a stack on AWS Opsworks with your repository.

Create a custom layer and add the recipe 'digits-server-simple' to the layer's recipes in the setup step. Add also a EBS volume to the layer configuration under `/digits` mount point (since we cannot change root volume size in Opsworks). Define a security group with TCP connection for port `8080`.

Launch an instance, for example a `g2.2xlarge`.

Digits server will be accessible on port 8080.
