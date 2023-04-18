<?php
	// configuration parameters

	// for snoopy client
	$httpUserAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36';
	$httpTimeOut = 30;			// in seconds
	$httpUseGzip = true;
	$httpIP = null;				// IP string. Or null for any.
	$httpProxy = array
	(
		'use'	=> false,
		'proto'	=> 'http',		// 'http' or 'https'
		'host'	=> 'PROXY_HOST_HERE',
		'port'	=> 3128
	);

	// for xmlrpc actions
	$rpcTimeOut = 5;			// in seconds
	$rpcLogCalls = false;
	$rpcLogFaults = true;

	// for php
	$phpUseGzip = false;
	$phpGzipLevel = 2;

	$schedule_rand = 10;			// rand for schedulers start, +0..X seconds

	$do_diagnostic = true;			// Diagnose ruTorrent. Recommended to keep enabled, unless otherwise required.
	$al_diagnostic = true;			// Diagnose auto-loader. Set to "false" to make composer plugins work.

	$log_file = '/config/log/rutorrent/rutorrent.log';		// path to log file (comment or leave blank to disable logging)

	$saveUploadedTorrents = true;		// Save uploaded torrents to profile/torrents directory or not
	$overwriteUploadedTorrents = false;	// Overwrite existing uploaded torrents in profile/torrents directory or make unique name

	$topDirectory = '/downloads';			// Upper available directory. Absolute path with trail slash.
	$forbidUserSettings = false;

	// $scgi_port = 5000;
	// $scgi_host = "127.0.0.1";

	// For web->rtorrent link through unix domain socket
	// (scgi_local in rtorrent conf file), change variables
	// above to something like this:
	//
	$scgi_port = 0;
	$scgi_host = "unix:////run/php/.rtorrent.sock";

	$XMLRPCMountPoint = "/RPC2";		// DO NOT DELETE THIS LINE!!! DO NOT COMMENT THIS LINE!!!

	$throttleMaxSpeed = 327625*1024;	// DO NOT EDIT THIS LINE!!! DO NOT COMMENT THIS LINE!!!
	// Can't be greater then 327625*1024 due to limitation in libtorrent ResourceManager::set_max_upload_unchoked function.

	$pathToExternals = array(
		"php"	=> '/usr/bin/php7',			// Something like /usr/bin/php. If empty, will be found in PATH.
		"curl"	=> '/usr/local/bin/curl',			// Something like /usr/bin/curl. If empty, will be found in PATH.
		"gzip"	=> '/usr/bin/gzip',			// Something like /usr/bin/gzip. If empty, will be found in PATH.
		"id"	=> '/usr/bin/id',			// Something like /usr/bin/id. If empty, will be found in PATH.
		"stat"	=> '/bin/stat',			// Something like /usr/bin/stat. If empty, will be found in PATH.
		"pgrep" => '/usr/bin/pgrep',
		"python" => '/usr/bin/python3',
	);

	$localHostedMode = true;		// Set to true if rTorrent is hosted on the SAME machine as ruTorrent

	$cachedPluginLoading = true;		// Set to true to enable rapid cached loading of ruTorrent plugins	
	$pluginJSCacheExpire = 3*60;		// Sets duration ruTorrent plugin javascript cache is valid for in minutes
						// Default is 3 hours which equals 3 hours * 60 minutes due to caching issues
						// Optionally raise this value and clear web browser cache when upgrading versions
						
	$miscCacheExpire = 3*60*24;		// Sets duration ruTorrent miscellaneous web browser cache is valid for in minutes
						// The goal here to avoid keeping stale content in the web browser
						// Default is 3 days which equals 3 days * 60 minutes * 24 hours

	$localhosts = array(			// list of local interfaces
		"127.0.0.1",
		"localhost",
	);

	$profilePath = '/config/rutorrent/profiles';		// Path to user profiles
	$profileMask = 0777;			// Mask for files and directory creation in user profiles.
						// Both Webserver and rtorrent users must have read-write access to it.
						// For example, if Webserver and rtorrent users are in the same group then the value may be 0770.

	$tempDirectory = '/config/rutorrent/profiles/tmp/';			// Temp directory. Absolute path with trail slash. If null, then autodetect will be used.

	$canUseXSendFile = false;		// If true then use X-Sendfile feature if it exist

	$locale = "UTF8";

	$enableCSRFCheck = false;		// If true then Origin and Referer will be checked
	$enabledOrigins = array();		// List of enabled domains for CSRF check (only hostnames, without protocols, port etc.).
						// If empty, then will retrieve domain from HTTP_HOST / HTTP_X_FORWARDED_HOST
