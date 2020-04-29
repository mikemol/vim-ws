FROM alpine:latest as builder

RUN apk add \
        git \
        musl-dev \
        gcc \
        ncurses-terminfo \
        ncurses \
        ncurses-dev \
	make && \
    git clone https://github.com/vim/vim && \
    cd vim && \
    ./configure \
        --disable-darwin \
        --disable-smack \
        --disable-selinux \
        --disable-xsmp \
        --disable-xsmp-interact \
        --disable-netbeans \
        --enable-multibyte \
        --disable-xim \
        --disable-fontset \
        --enable-gui=no \
        --disable-gtktest \
        --disable-icon-cache-update \
        --disable-canberra \
        --disable-acl \
        --disable-gpm \
        --disable-sysmouse \
        --prefix=/opt/vim && \
    make install

FROM alpine:latest

COPY --from=builder /opt/vim/bin /usr/local/bin
COPY --from=builder /opt/vim/share /usr/local/share

RUN apk add --no-cache \
        diffutils \
        ncurses

WORKDIR /home/user

ENTRYPOINT ["vim"]

