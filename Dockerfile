FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive DEBCONF_NOWARNINGS=yes

RUN echo 'APT::Install-Suggests   "0";' > "/etc/apt/apt.conf.d/99install-suggests"   && \
    echo 'APT::Install-Recommends "0";' > "/etc/apt/apt.conf.d/99install-recommends" && \
    true

RUN apt-get update \
 && apt-get upgrade --yes \
 && apt-get install --yes \
        build-essential \
        ca-certificates \
        curl \
        file \
        htop \
        less \
        patch \
        tree \
        unzip \
 && true

ADD musl-cross-make.tgz /opt/

WORKDIR /root

# -----------------------------------------------------------------------------
# ncurses

RUN mkdir src \
 && cd src \
 && curl -sL https://ftpmirror.gnu.org/gnu/ncurses/ncurses-6.5.tar.gz | tar xz

# -----------------------------------------------------------------------------
# readline

RUN cd src \
 && mkdir readline-8.3-patches \
 && curl -sL https://ftpmirror.gnu.org/gnu/readline/readline-8.3.tar.gz | tar xz \
 && cd readline-8.3 && for i in 001 002 003 ; do \
      curl -sL https://ftpmirror.gnu.org/gnu/readline/readline-8.3-patches/readline83-$i | patch -p2 ; \
    done

# -----------------------------------------------------------------------------
# oils

RUN cd src \
 && curl -sL "https://oils.pub/download/oils-for-unix-0.37.0.tar.gz" | tar xz

# -----------------------------------------------------------------------------
# make-all

COPY make-all.sh .

ENTRYPOINT [ "/root/make-all.sh" ]

# -----------------------------------------------------------------------------
# done
