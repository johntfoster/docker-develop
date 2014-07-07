FROM johntfoster/ipython

MAINTAINER John Foster <johntfosterjr@gmail.com>

RUN apt-get -yq install git tmux
RUN apt-get -yq install libncurses-dev
RUN apt-get -yq install cmake
RUN pip install powerline-status

RUN git config --global user.name "John Foster"
RUN git config --global user.email johntfosterjr@gmail.com

RUN wget ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
RUN tar xjvf vim-7.4.tar.bz2
WORKDIR vim74
RUN ./configure --with-features=huge --enable-pythoninterp=yes
RUN make -j8 && make install

WORKDIR /
RUN rm -rf vim74 vim-7.4.tar.bz2

RUN rm ~/.bashrc 
RUN git clone https://github.com/johntfoster/dotfiles.git ~/.dotfiles; \
    ln -s ~/.dotfiles/bash_profile ~/.bash_profile; \
    ln -s ~/.dotfiles/bashrc ~/.bashrc; \
    ln -s ~/.dotfiles/screenrc ~/.screenrc; \
    ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf

RUN git clone https://github.com/johntfoster/dotvim.git ~/.vim; \
    ln -s ~/.vim/vimrc ~/.vimrc
RUN git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

RUN vim +PluginInstall +qall

WORKDIR /root/.vim/bundle/YouCompleteMe/
RUN ./install.sh --clang-completer

WORKDIR /

RUN apt-get -yq install man
ENV USER root
CMD ["/bin/bash","--login"]
