FROM lsiobase/alpine:3.8

MAINTAINER romancin

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BUILD_CORES
LABEL build_version="Romancin version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# package version
ARG MEDIAINF_VER="19.04"
ARG RTORRENT_VER="v0.9.7"
ARG LIBTORRENT_VER="v0.13.7"
ARG CURL_VER="7.64.1"
ARG GEOIP_VER="1.1.1"

# set env
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV CONTEXT_PATH=/
ENV CREATE_SUBDIR_BY_TRACKERS="no"
    
RUN NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} && \
 apk add --no-cache \
	bash-completion \
        ca-certificates \
        fcgi \
        ffmpeg \
        geoip \
        geoip-dev \
        gzip \
        logrotate \
        nginx \
        dtach \
        tar \
        unrar \
        unzip \
        sox \
        wget \
        irssi \
        irssi-perl \
        zlib \
        zlib-dev \
        libxml2-dev \
        perl-archive-zip \
        perl-net-ssleay \
        perl-digest-sha1 \
        git \
        libressl \
        binutils \
        findutils \
        zip \
        php7 \
        php7-cgi \
        php7-fpm \
        php7-json  \
        php7-mbstring \
        php7-sockets \
        php7-pear \
        php7-opcache \
        php7-apcu \
        php7-ctype \
        php7-dev \
        php7-phar \
        python \
        python3 && \
# install build packages
 apk add --no-cache --virtual=build-dependencies \
        autoconf \
        automake \
        cppunit-dev \
        perl-dev \
        file \
        g++ \
        gcc \
        libtool \
        make \
        ncurses-dev \
        build-base \
        libtool \
        subversion \
        cppunit-dev \
        linux-headers \
        curl-dev \
        libressl-dev && \
# compile curl to fix ssl for rtorrent
cd /tmp && \
mkdir curl && \
cd curl && \
wget -qO- https://curl.haxx.se/download/curl-${CURL_VER}.tar.gz | tar xz --strip 1 && \
./configure --with-ssl && make -j ${NB_CORES} && make install && \
ldconfig /usr/bin && ldconfig /usr/lib && \
# install webui
 mkdir -p \
        /usr/share/webapps/rutorrent \
        /defaults/rutorrent-conf && \
 git clone https://github.com/Novik/ruTorrent.git \
        /usr/share/webapps/rutorrent/ && \
 mv /usr/share/webapps/rutorrent/conf/* \
        /defaults/rutorrent-conf/ && \
 rm -rf \
        /defaults/rutorrent-conf/users && \
 pip3 install CfScrape && \
# install webui extras
# QuickBox Theme
git clone https://github.com/QuickBox/club-QuickBox /usr/share/webapps/rutorrent/plugins/theme/themes/club-QuickBox && \
git clone https://github.com/Phlooo/ruTorrent-MaterialDesign /usr/share/webapps/rutorrent/plugins/theme/themes/MaterialDesign && \
# ruTorrent plugins
cd /usr/share/webapps/rutorrent/plugins/ && \
git clone https://github.com/orobardet/rutorrent-force_save_session force_save_session && \
git clone https://github.com/AceP1983/ruTorrent-plugins  && \
mv ruTorrent-plugins/* . && \
rm -rf ruTorrent-plugins && \
apk add --no-cache cksfv && \
git clone https://github.com/nelu/rutorrent-thirdparty-plugins.git && \
mv rutorrent-thirdparty-plugins/* . && \
rm -rf rutorrent-thirdparty-plugins && \
cd /usr/share/webapps/rutorrent/ && \
chmod 755 plugins/filemanager/scripts/* && \
rm -rf plugins/fileupload && \
cd /tmp && \
git clone https://github.com/mcrapet/plowshare.git && \
cd plowshare/ && \
make install && \
cd .. && \
rm -rf plowshare* && \
apk add --no-cache unzip bzip2 && \
cd /usr/share/webapps/rutorrent/plugins/ && \
git clone https://github.com/Gyran/rutorrent-pausewebui pausewebui && \
git clone https://github.com/Gyran/rutorrent-ratiocolor ratiocolor && \
sed -i 's/changeWhat = "cell-background";/changeWhat = "font";/g' /usr/share/webapps/rutorrent/plugins/ratiocolor/init.js && \
git clone https://github.com/Gyran/rutorrent-instantsearch instantsearch && \
git clone https://github.com/xombiemp/rutorrentMobile && \
git clone https://github.com/dioltas/AddZip && \
git clone https://github.com/Micdu70/geoip2-rutorrent geoip2 && \
rm -rf geoip && \
mkdir -p /usr/share/GeoIP && \
cd /usr/share/GeoIP && \
wget https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz && \
wget https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz && \
tar xzf GeoLite2-City.tar.gz && \
tar xzf GeoLite2-Country.tar.gz && \
rm -f *.tar.gz && \
mv GeoLite2-*/*.mmdb . && \
cp *.mmdb /usr/share/webapps/rutorrent/plugins/geoip2/database/ && \
pecl install geoip-${GEOIP_VER} && \
chmod +x /usr/lib/php7/modules/geoip.so && \
echo ";extension=geoip.so" >> /etc/php7/php.ini && \
# install autodl-irssi perl modules
 perl -MCPAN -e 'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autoconfig => 1); $c->edit(prerequisites_policy => "follow"); $c->edit(build_requires_install_policy => "yes"); $c->commit' && \
 curl -L http://cpanmin.us | perl - App::cpanminus && \
        cpanm HTML::Entities XML::LibXML JSON JSON::XS && \
# compile xmlrpc-c
cd /tmp && \
svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c && \
cd /tmp/xmlrpc-c && \
./configure --with-libwww-ssl --disable-wininet-client --disable-curl-client --disable-libwww-client --disable-abyss-server --disable-cgi-server && make -j ${NB_CORES} && make install && \
# compile libtorrent
# apk add -X http://dl-cdn.alpinelinux.org/alpine/v3.6/main -U cppunit-dev==1.13.2-r1 cppunit==1.13.2-r1 && \
cd /tmp && \
mkdir libtorrent && \
cd libtorrent && \
wget -qO- https://github.com/rakshasa/libtorrent/archive/${LIBTORRENT_VER}.tar.gz | tar xz --strip 1 && \
./autogen.sh && ./configure && make -j ${NB_CORES} && make install && \
# compile rtorrent
cd /tmp && \
mkdir rtorrent && \
cd rtorrent && \
wget -qO- https://github.com/rakshasa/rtorrent/archive/${RTORRENT_VER}.tar.gz | tar xz --strip 1 && \
./autogen.sh && ./configure --with-xmlrpc-c && make -j ${NB_CORES} && make install && \
# compile mediainfo packages
 curl -o \
 /tmp/libmediainfo.tar.gz -L \
        "http://mediaarea.net/download/binary/libmediainfo0/${MEDIAINF_VER}/MediaInfo_DLL_${MEDIAINF_VER}_GNU_FromSource.tar.gz" && \
 curl -o \
 /tmp/mediainfo.tar.gz -L \
        "http://mediaarea.net/download/binary/mediainfo/${MEDIAINF_VER}/MediaInfo_CLI_${MEDIAINF_VER}_GNU_FromSource.tar.gz" && \
 mkdir -p \
        /tmp/libmediainfo \
        /tmp/mediainfo && \
 tar xf /tmp/libmediainfo.tar.gz -C \
        /tmp/libmediainfo --strip-components=1 && \
 tar xf /tmp/mediainfo.tar.gz -C \
        /tmp/mediainfo --strip-components=1 && \
 cd /tmp/libmediainfo && \
        ./SO_Compile.sh && \
 cd /tmp/libmediainfo/ZenLib/Project/GNU/Library && \
        make install && \
 cd /tmp/libmediainfo/MediaInfoLib/Project/GNU/Library && \
        make install && \
 cd /tmp/mediainfo && \
        ./CLI_Compile.sh && \
 cd /tmp/mediainfo/MediaInfo/Project/GNU/CLI && \
        make install && \
# cleanup
 apk del --purge \
        build-dependencies && \
# apk del -X http://dl-cdn.alpinelinux.org/alpine/v3.6/main cppunit-dev && \
 rm -rf \
        /tmp/*
# add local files
COPY root/ /
# add rtelegram bot
ENV RT_TOKEN="" \
    PARAMS=""
ADD https://github.com/pyed/rtelegram/releases/download/v1.1/rtelegram_1.1_linux_amd64.tar.gz /tmp/rtelegram.tar.gz
RUN tar -xzvf /rtelegram /tmp/rtelegram.tar.gz && chmod +x /rtelegram/rtelegram && rm /tmp/rtelegram.tar.gz && chmod +x /rtelegram.sh
# ports and volumes
EXPOSE 443 51415
VOLUME /config /downloads
ENTRYPOINT ["/rtelegram.sh"]
