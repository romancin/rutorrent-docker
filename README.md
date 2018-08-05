# rutorrent-docker

A repository for creating a docker container including rtorrent with rutorrent.

[![](https://images.microbadger.com/badges/version/romancin/rutorrent.svg)](https://microbadger.com/images/romancin/rutorrent "Docker image version")
[![](https://images.microbadger.com/badges/image/romancin/rutorrent.svg)](https://microbadger.com/images/romancin/rutorrent "Docker image size")
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=X2CT2SWQCP74U)

You can invite me a beer if you want ;) 

This is a completely funcional Docker image with rutorrent, rtorrent, libtorrent and a lot of plugins 
for rutorrent, like autodl-irssi, filemanager, fileshare and other useful ones.

Based on Alpine Linux, which provides a very small size. 

Includes plugins: logoff fileshare filemanager pausewebui mobile ratiocolor force_save_session showip ...

Also installed and selected by default this awesome theme: club-QuickBox

Also includes MaterialDesign theme as an option.

05/08/2018: NEW: Includes Pyrocore/rtcontrol - http://pyrocore.readthedocs.io/en/latest/index.html

You need to run pyrocore commands with user "abc", which is who runs rtorrent, so use "su - abc" after connecting container before using pyrocore commands. If you already have torrents in your rtorrent docker instance, you have to add extra information before usinf pyrocore, check here: http://pyrocore.readthedocs.io/en/latest/setup.html in the "Adding Missing Data to Your rTorrent Session" topic.

Tested and working on Synology and QNAP, but should work on any x86_64 devices.

Instructions: 
- Map any local port to 443 for SSL rutorrent access (Default username/password is admin/admin) 
- Map any local port to 51415 for rtorrent 
- Map a local volume to /config (Stores configuration data, including rtorrent session directory. Consider this on SSD Disk) 
- Map a local volume to /downloads (Stores downloaded torrents)

In order to change rutorrent web access password execute this inside container: 
- `sh -c "echo -n 'admin:' > /config/nginx/.htpasswd"`
- `sh -c "openssl passwd -apr1 >> /config/nginx/.htpasswd"`

Sample run command:

For rtorrent 0.9.6 version:

```bash
docker run -d --name=rutorrent \
-v /share/Container/rutorrent/config:/config \
-v /share/Container/rutorrent/downloads:/downloads \
-e PGID=0 -e PUID=0 -e TZ=Europe/Madrid \
-p 9443:443 \
-p 51415-51415:51415-51415 \
romancin/rutorrent:latest
```

For rtorrent 0.9.4 version:

```bash
docker run -d --name=rutorrent \
-v /share/Container/rutorrent/config:/config \
-v /share/Container/rutorrent/downloads:/downloads \
-e PGID=0 -e PUID=0 -e TZ=Europe/Madrid \
-p 9443:443 \
-p 51415-51415:51415-51415 \
romancin/rutorrent:0.9.4
```

Remember editing `/config/rtorrent/rtorrent.rc` with your own settings, especially your watch subfolder configuration.
