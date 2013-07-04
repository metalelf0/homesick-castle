# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="simple"
plugins=(git osx)
source $ZSH/oh-my-zsh.sh
source $HOME/.aliases.sh
export PATH=$HOME/bin:$PATH
export SSL_CERT_FILE=/usr/local/etc/openssl/certs/cert.pem
