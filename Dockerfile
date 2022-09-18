FROM ubuntu:20.04

# Install git
RUN apt-get update && apt-get install -y git
# Install unzip
RUN apt-get update && apt-get install -y unzip
# Install build-essential
RUN apt-get update && apt-get install -y build-essential

# Install golang==1.19
RUN apt-get update && apt-get install -y wget
RUN wget https://golang.org/dl/go1.19.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.19.linux-amd64.tar.gz
RUN rm go1.19.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
# set env for go
ENV GOPATH=/go
ENV PATH=$PATH:$GOPATH/bin


# Git clone Zond
# RUN wget https://zond-docs.theqrl.org/node/zond-dev-node-install.sh 
RUN rm -rf ~/.zond
RUN rm -rf ~/zond
RUN rm -rf ~/Downloads/bootstrap-devnet 
RUN rm -rf ~/Downloads/bootstrap-devnet.zip
# clone zond
# clone the zond repo, grabbing the latest code
RUN git clone https://github.com/theqrl/zond ~/zond

# Download the bootstrap files and unzip
RUN mkdir ~/Downloads
RUN wget https://zond-docs.theqrl.org/node/bootstrap-devnet.zip -O ~/Downloads/bootstrap-devnet.zip
RUN unzip ~/Downloads/bootstrap-devnet.zip -d ~/Downloads/

# Copy the genesis files and configuration into the correct directories
RUN cp -r ~/Downloads/bootstrap-devnet/block/genesis/devnet ~/zond/block/genesis/
RUN cp ~/Downloads/bootstrap-devnet/config/config.go ~/zond/config/config.go

# apply following patch to config.go using patch command
# @@ -178,7 +178,7 @@
#  func GetUserConfig() (userConf *UserConfig) {
#     node := &NodeConfig{
#         EnablePeerDiscovery:     true,
# -       PeerList:                []string{},
# +       PeerList:                []string{"/ip4/45.76.43.83/tcp/15005/p2p/QmU6Uo93bSgU7bA8bkbdNhSfbmp7S5XJEcSqgrdLzH6ksT"},
#         BindingIP:               "0.0.0.0",
#         LocalPort:               15005,
#         PublicPort:              15005,
# EOF
COPY config.go.patch /tmp/config.go.patch
RUN patch -u ~/zond/config/config.go -p0 < /tmp/config.go.patch

# Build Zond node
RUN cd ~/zond && go build ~/zond/cmd/zond-cli && go build ~/zond/cmd/gzond
