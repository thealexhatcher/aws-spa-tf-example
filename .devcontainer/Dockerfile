FROM amazonlinux:latest
ARG TERRAFORM_VERSION=0.15.1
ARG GH_VERSION=1.9.2
## SYSTEM SETUP
RUN yum update -y
RUN yum install -y sudo gcc g++ make git zip unzip tar bzip2 wget jq openssl uuid aws-cli
## TERRAFORM
RUN wget --progress=dot:mega https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
	&& unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
	&& mv terraform /usr/local/bin/ \
	&& chmod +x /usr/local/bin/terraform \
	&& terraform --version
## GITHUB CLI 
RUN wget --progress=dot:mega --no-check-certificate https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz \
	&& tar -zxvf gh_${GH_VERSION}_linux_amd64.tar.gz \
	&& mv gh_${GH_VERSION}_linux_amd64/bin/gh /usr/local/bin/gh \
	&& chmod +x /usr/local/bin/gh \
	&& gh --version
### VSCODE USER Setup
RUN adduser vscode 
RUN usermod -aG wheel vscode
RUN echo '%vscode ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
USER vscode