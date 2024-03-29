# rutorrent-docker

A repository for creating a docker container including rtorrent with rutorrent.

![docker pulls](https://img.shields.io/docker/pulls/romancin/rutorrent.svg) ![docker stars](https://img.shields.io/docker/stars/romancin/rutorrent.svg) [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=X2CT2SWQCP74U)

Latest version:

![Docker Image Version (latest semver)](https://img.shields.io/docker/v/romancin/rutorrent/0.9.8) ![docker size](https://img.shields.io/docker/image-size/romancin/rutorrent/0.9.8)

You can invite me a beer if you want ;)

## Description

This is a completely funcional Docker image with rutorrent, rtorrent, libtorrent and a lot of plugins
for rutorrent, like autodl-irssi, filemanager, fileshare and other useful ones.

Based on Alpine Linux, which provides a very small size.

Includes plugins: logoff fileshare filemanager pausewebui mobile ratiocolor force_save_session showip ...

Also installed and selected by default this awesome theme: club-QuickBox

Also includes MaterialDesign theme as an option.

You need to run pyrocore commands with user "abc", which is who runs rtorrent, so use "su - abc" after connecting container before using pyrocore commands. If you already have torrents in your rtorrent docker instance, you have to add extra information before using pyrocore, check here: http://pyrocore.readthedocs.io/en/latest/setup.html in the "Adding Missing Data to Your rTorrent Session" topic.

rTelegram is added, that will allow you to control your rtorrent instance from Telegram client.

Tested and working on Synology and QNAP, but should work on any x86_64 devices.

## Instructions

- Map any local port to 80 for rutorrent access (Default username/password is admin/admin)
- Map any local port to 443 for SSL rutorrent access if SSL_ENABLED=yes (Default username/password is admin/admin)
- Map any local port to 51415 for rtorrent
- Map a local volume to /config (Stores configuration data, including rtorrent session directory. Consider this on SSD Disk)
- Map a local volume to /downloads (Stores downloaded torrents)

In order to change rutorrent web access password execute this inside container:
- `sh -c "echo -n 'admin:' > /config/nginx/.htpasswd"`
- `sh -c "libressl passwd -apr1 >> /config/nginx/.htpasswd"`

**IMPORTANT**
- Old rtorrent versions are now deprecated since version 4.2.0 of the image. The older ones should remain available for use until docker hub deletes them.
- Since v1.0.0 version, rtorrent.rc file has changed completely, so rename it before starting with the new image the first time. After first run, add the changes you need to this config file. It is on <YOUR_MAPPED_FOLDER>/rtorrent directory.
- Since v2.0.0 version, config.php of rutorrent has added new utilities, so rename it before starting with the new image the first time. After first run, add the changes you need to this config file. It is on <YOUR_MAPPED_FOLDER>/rutorrent/settings directory.

## Sample run command

For rtorrent 0.9.8 version:

 ```bash
docker run -d --name=rutorrent \
-v /share/Container/rutorrent/config:/config \
-v /share/Container/rutorrent/downloads:/downloads \
-e PGID=0 -e PUID=0 -e TZ=Europe/Madrid \
-p 9443:443 \
-p 51415-51415:51415-51415 \
romancin/rutorrent:latest
```

For rtorrent 0.9.7 version **DEPRECATED**:

```bash
docker run -d --name=rutorrent \
-v /share/Container/rutorrent/config:/config \
-v /share/Container/rutorrent/downloads:/downloads \
-e PGID=0 -e PUID=0 -e TZ=Europe/Madrid \
-p 9443:443 \
-p 51415-51415:51415-51415 \
romancin/rutorrent:0.9.7
```

For rtorrent 0.9.6 version **DEPRECATED**:

```bash
docker run -d --name=rutorrent \
-v /share/Container/rutorrent/config:/config \
-v /share/Container/rutorrent/downloads:/downloads \
-e PGID=0 -e PUID=0 -e TZ=Europe/Madrid \
-p 9443:443 \
-p 51415-51415:51415-51415 \
romancin/rutorrent:0.9.6
```

For rtorrent 0.9.4 version **DEPRECATED**:

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

## Environment variables supported

| Variable | Function |
| :----: | --- |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-e CREATE_SUBDIR_BY_TRACKERS=YES` | YES to create downloads/watch subfolder for trackers (OLD BEHAVIOUR) or NO to create only completed/watch folder (DEFAULT) |
| `-e SSL_ENABLED=YES` | YES to enable SSL in nginx/flood or NO to not use it (DEFAULT) |
| `-e ENABLE_PYROSCOPE=YES` | YES to enable pyroscope installation or NO to not use it (DEFAULT, as currently pyroscope installation is broken) |
| `-e WAIT_NETWORK=YES` | YES to wait until network is available (Needed for TrueNAS kubernetes static IP address to work) or NO to not use it (DEFAULT) |
| `-e RT_TOKEN=your_bot_token` | for your Telegram BOT Token - [see rtelegram documentation for instructions](https://github.com/pyed/rtelegram/wiki/Getting-started). If not used, rtelegram won't start on boot. |
| `-e RT_MASTERS=your_real_telegram_username` | for your Telegram real username - [see rtelegram documentation for instructions](https://github.com/pyed/rtelegram/wiki/Getting-started). If not used, rtelegram won't start on boot. |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

## Changelog
v7.0.0 (21/03/2022): Implement pyroscope installation optionally (current pyrocore installation scripts do not work, so don't use it, and the project seems unmaintained :() and a new option to wait for network to be ready. **NOTE**: Important changes made in rutorrent [#2236](https://github.com/Novik/ruTorrent/pull/2236) and [#2247](https://github.com/Novik/ruTorrent/pull/2247) broke compatibility with v3.10 for some themes and plugins. For the moment, I am using certain forks from [stickz](https://github.com/stickz) (Thank you very much!) to fix certain plugins.

v6.0.0 (31/07/2021): Updated base image to Alpine 3.14 and applications to current versions.

v5.0.1 (07/11/2020): Disabled rar in filemanager plugin because it is not available in Alpine.

v5.0.0 (07/11/2020): Now old rtorrent versions are deprecated and the image updated to Alpine 3.12.

v4.2.0 (05/11/2020): Added Discord plugin installation, changed XMLRCP-C repository to the mirror in Github and change Flood to currently most active fork. Fixed PluginCheckPort plugin. You will no longer see 'Bad response from server: (500 [error,initportcheck])' error message in ruTorrent.

v4.0.4 (04/07/2020): Update image to Alpine 3.11 and current packages

v4.0.3 (24/05/2020): Update image to current packages

v4.0.2 (31/03/2020): Corrected rutorrentMobile plugin installation (Thanks @jorritsmit!!)

v4.0.0 (16/03/2020): Added variable for optional SSL configuration.

v3.0.0 (13/03/2020): Updated to Alpine 3.11 (rtorrent 0.9.8 only). Changed to new maxmind database.

v2.2.1 (20/09/2019): Unified Dockerfile and Jenkinsfile for easier image code management

v2.2.0 (09/09/2019): Added [rtelegram](https://github.com/pyed/rtelegram). It allows to control rtorrent from Telegram.

v2.1.0 (10/08/2019): Fixed cloudflare plugin. New 0.9.7 branch. Master branch updated to rtorrent/libtorrent 0.9.8/0.13.8.

v2.0.1 (29/04/2019): Added GeoIP2 plugin.

v2.0 (28/04/2019): Updated image to rutorrent 3.9. For the first time, I have eliminated the creation of subfolder directories for trackers by default. Since this moment, you can choose to create them using CREATE_SUBDIR_BY_TRACKERS variable.

v1.0.1 (28/03/2019): curl 7.64.0 version has an issue that causes very high CPU usage in rtorrent. This version should fix this behaviour.

v1.0.0 (16/03/2019): NEW: rTorrent 0.9.7 / libtorrent 0.13.7 version. rtorrent.rc file has changed completely, rename it before starting with the new image the first time. After first run, add the changes you need to this config file.

vN/A: 05/08/2018: NEW: Includes Pyrocore/rtcontrol - http://pyrocore.readthedocs.io/en/latest/index.html
