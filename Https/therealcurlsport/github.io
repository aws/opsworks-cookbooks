travis_fold:start:worker_info
[0K[33;1mWorker information[0m
hostname: b17f9074-0aa0-434d-af4a-734a94b23635@1.production-1-worker-org-a-2-gce
version: v3.5.0 https://github.com/travis-ci/worker/tree/77dbc57c72d00592aeb754773b712da843c7e00d
instance: travis-job-485aa97b-c8ca-4ade-a403-5e0b194160ce travis-ci-garnet-trusty-1512502259-986baf0 (via amqp)
startup: 21.208033088s
travis_fold:end:worker_info
[0Kmode of â€˜/usr/local/clang-5.0.0/binâ€™ changed from 0777 (rwxrwxrwx) to 0775 (rwxrwxr-x)
travis_fold:start:system_info
[0K[33;1mBuild system information[0m
Build language: ruby
Build group: stable
Build dist: trusty
Build id: 343704298
Job id: 343704299
Runtime kernel version: 4.4.0-101-generic
travis-build version: 86020898a
[34m[1mBuild image provisioning date and time[0m
Tue Dec  5 19:58:13 UTC 2017
[34m[1mOperating System Details[0m
Distributor ID:	Ubuntu
Description:	Ubuntu 14.04.5 LTS
Release:	14.04
Codename:	trusty
[34m[1mCookbooks Version[0m
7c2c6a6 https://github.com/travis-ci/travis-cookbooks/tree/7c2c6a6
[34m[1mgit version[0m
git version 2.15.1
[34m[1mbash version[0m
GNU bash, version 4.3.11(1)-release (x86_64-pc-linux-gnu)
[34m[1mgcc version[0m
gcc (Ubuntu 4.8.4-2ubuntu1~14.04.3) 4.8.4
Copyright (C) 2013 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

[34m[1mdocker version[0m
Client:
 Version:      17.09.0-ce
 API version:  1.32
 Go version:   go1.8.3
 Git commit:   afdb6d4
 Built:        Tue Sep 26 22:42:38 2017
 OS/Arch:      linux/amd64

Server:
 Version:      17.09.0-ce
 API version:  1.32 (minimum version 1.12)
 Go version:   go1.8.3
 Git commit:   afdb6d4
 Built:        Tue Sep 26 22:41:20 2017
 OS/Arch:      linux/amd64
 Experimental: false
[34m[1mclang version[0m
clang version 5.0.0 (tags/RELEASE_500/final)
Target: x86_64-unknown-linux-gnu
Thread model: posix
InstalledDir: /usr/local/clang-5.0.0/bin
[34m[1mjq version[0m
jq-1.5
[34m[1mbats version[0m
Bats 0.4.0
[34m[1mshellcheck version[0m
0.4.6
[34m[1mshfmt version[0m
v2.0.0
[34m[1mccache version[0m
ccache version 3.1.9

Copyright (C) 2002-2007 Andrew Tridgell
Copyright (C) 2009-2011 Joel Rosdahl

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 3 of the License, or (at your option) any later
version.
[34m[1mcmake version[0m
cmake version 3.9.2

CMake suite maintained and supported by Kitware (kitware.com/cmake).
[34m[1mheroku version[0m
heroku-cli/6.14.39-addc925 (linux-x64) node-v9.2.0
[34m[1mimagemagick version[0m
Version: ImageMagick 6.7.7-10 2017-07-31 Q16 http://www.imagemagick.org
[34m[1mmd5deep version[0m
4.2
[34m[1mmercurial version[0m
Mercurial Distributed SCM (version 4.2.2)
(see https://mercurial-scm.org for more information)

Copyright (C) 2005-2017 Matt Mackall and others
This is free software; see the source for copying conditions. There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
[34m[1mmysql version[0m
mysql  Ver 14.14 Distrib 5.6.33, for debian-linux-gnu (x86_64) using  EditLine wrapper
[34m[1mopenssl version[0m
OpenSSL 1.0.1f 6 Jan 2014
[34m[1mpacker version[0m
Packer v1.0.2

Your version of Packer is out of date! The latest version
is 1.1.2. You can update by downloading from www.packer.io
[34m[1mpostgresql client version[0m
psql (PostgreSQL) 9.6.6
[34m[1mragel version[0m
Ragel State Machine Compiler version 6.8 Feb 2013
Copyright (c) 2001-2009 by Adrian Thurston
[34m[1msubversion version[0m
svn, version 1.8.8 (r1568071)
   compiled Aug 10 2017, 17:20:39 on x86_64-pc-linux-gnu

Copyright (C) 2013 The Apache Software Foundation.
This software consists of contributions made by many people;
see the NOTICE file for more information.
Subversion is open source software, see http://subversion.apache.org/

The following repository access (RA) modules are available:

* ra_svn : Module for accessing a repository using the svn network protocol.
  - with Cyrus SASL authentication
  - handles 'svn' scheme
* ra_local : Module for accessing a repository on local disk.
  - handles 'file' scheme
* ra_serf : Module for accessing a repository via WebDAV protocol using serf.
  - using serf 1.3.3
  - handles 'http' scheme
  - handles 'https' scheme

[34m[1msudo version[0m
Sudo version 1.8.9p5
Configure options: --prefix=/usr -v --with-all-insults --with-pam --with-fqdn --with-logging=syslog --with-logfac=authpriv --with-env-editor --with-editor=/usr/bin/editor --with-timeout=15 --with-password-timeout=0 --with-passprompt=[sudo] password for %p:  --without-lecture --with-tty-tickets --disable-root-mailer --enable-admin-flag --with-sendmail=/usr/sbin/sendmail --with-timedir=/var/lib/sudo --mandir=/usr/share/man --libexecdir=/usr/lib/sudo --with-sssd --with-sssd-lib=/usr/lib/x86_64-linux-gnu --with-selinux
Sudoers policy plugin version 1.8.9p5
Sudoers file grammar version 43

Sudoers path: /etc/sudoers
Authentication methods: 'pam'
Syslog facility if syslog is being used for logging: authpriv
Syslog priority to use when user authenticates successfully: notice
Syslog priority to use when user authenticates unsuccessfully: alert
Send mail if the user is not in sudoers
Use a separate timestamp for each user/tty combo
Lecture user the first time they run sudo
Root may run sudo
Allow some information gathering to give useful error messages
Require fully-qualified hostnames in the sudoers file
Visudo will honor the EDITOR environment variable
Set the LOGNAME and USER environment variables
Length at which to wrap log file lines (0 for no wrap): 80
Authentication timestamp timeout: 15.0 minutes
Password prompt timeout: 0.0 minutes
Number of tries to enter a password: 3
Umask to use or 0777 to use user's: 022
Path to mail program: /usr/sbin/sendmail
Flags for mail program: -t
Address to send mail to: root
Subject line for mail messages: *** SECURITY information for %h ***
Incorrect password message: Sorry, try again.
Path to authentication timestamp dir: /var/lib/sudo
Default password prompt: [sudo] password for %p: 
Default user to run commands as: root
Value to override user's $PATH with: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
Path to the editor for use by visudo: /usr/bin/editor
When to require a password for 'list' pseudocommand: any
When to require a password for 'verify' pseudocommand: all
File descriptors >= 3 will be closed before executing a command
Environment variables to check for sanity:
	TZ
	TERM
	LINGUAS
	LC_*
	LANGUAGE
	LANG
	COLORTERM
Environment variables to remove:
	RUBYOPT
	RUBYLIB
	PYTHONUSERBASE
	PYTHONINSPECT
	PYTHONPATH
	PYTHONHOME
	TMPPREFIX
	ZDOTDIR
	READNULLCMD
	NULLCMD
	FPATH
	PERL5DB
	PERL5OPT
	PERL5LIB
	PERLLIB
	PERLIO_DEBUG 
	JAVA_TOOL_OPTIONS
	SHELLOPTS
	GLOBIGNORE
	PS4
	BASH_ENV
	ENV
	TERMCAP
	TERMPATH
	TERMINFO_DIRS
	TERMINFO
	_RLD*
	LD_*
	PATH_LOCALE
	NLSPATH
	HOSTALIASES
	RES_OPTIONS
	LOCALDOMAIN
	CDPATH
	IFS
Environment variables to preserve:
	JAVA_HOME
	TRAVIS
	CI
	DEBIAN_FRONTEND
	XAUTHORIZATION
	XAUTHORITY
	PS2
	PS1
	PATH
	LS_COLORS
	KRB5CCNAME
	HOSTNAME
	HOME
	DISPLAY
	COLORS
Locale to use while parsing sudoers: C
Directory in which to store input/output logs: /var/log/sudo-io
File in which to store the input/output log: %{seq}
Add an entry to the utmp/utmpx file when allocating a pty
PAM service name to use
PAM service name to use for login shells
Create a new PAM session for the command to run in
Maximum I/O log sequence number: 0

Local IP address and netmask pairs:
	10.240.0.28/255.255.255.255
	172.17.0.1/255.255.0.0

Sudoers I/O plugin version 1.8.9p5
[34m[1mgzip version[0m
gzip 1.6
Copyright (C) 2007, 2010, 2011 Free Software Foundation, Inc.
Copyright (C) 1993 Jean-loup Gailly.
This is free software.  You may redistribute copies of it under the terms of
the GNU General Public License <http://www.gnu.org/licenses/gpl.html>.
There is NO WARRANTY, to the extent permitted by law.

Written by Jean-loup Gailly.
[34m[1mzip version[0m
Copyright (c) 1990-2008 Info-ZIP - Type 'zip "-L"' for software license.
This is Zip 3.0 (July 5th 2008), by Info-ZIP.
Currently maintained by E. Gordon.  Please send bug reports to
the authors using the web page at www.info-zip.org; see README for details.

Latest sources and executables are at ftp://ftp.info-zip.org/pub/infozip,
as of above date; see http://www.info-zip.org/ for other sites.

Compiled with gcc 4.8.2 for Unix (Linux ELF) on Oct 21 2013.

Zip special compilation options:
	USE_EF_UT_TIME       (store Universal Time)
	BZIP2_SUPPORT        (bzip2 library version 1.0.6, 6-Sept-2010)
	    bzip2 code and library copyright (c) Julian R Seward
	    (See the bzip2 license for terms of use)
	SYMLINK_SUPPORT      (symbolic links supported)
	LARGE_FILE_SUPPORT   (can read and write large files on file system)
	ZIP64_SUPPORT        (use Zip64 to store large files in archives)
	UNICODE_SUPPORT      (store and read UTF-8 Unicode paths)
	STORE_UNIX_UIDs_GIDs (store UID/GID sizes/values using new extra field)
	UIDGID_NOT_16BIT     (old Unix 16-bit UID/GID extra field not used)
	[encryption, version 2.91 of 05 Jan 2007] (modified for Zip 3)

Encryption notice:
	The encryption code of this program is not copyrighted and is
	put in the public domain.  It was originally written in Europe
	and, to the best of our knowledge, can be freely distributed
	in both source and object forms from any country, including
	the USA under License Exception TSU of the U.S. Export
	Administration Regulations (section 740.13(e)) of 6 June 2002.

Zip environment options:
             ZIP:  [none]
          ZIPOPT:  [none]
[34m[1mvim version[0m
VIM - Vi IMproved 7.4 (2013 Aug 10, compiled Nov 24 2016 16:43:18)
Included patches: 1-52
Extra patches: 8.0.0056
Modified by pkg-vim-maintainers@lists.alioth.debian.org
Compiled by buildd@
Huge version without GUI.  Features included (+) or not (-):
+acl             +farsi           +mouse_netterm   +syntax
+arabic          +file_in_path    +mouse_sgr       +tag_binary
+autocmd         +find_in_path    -mouse_sysmouse  +tag_old_static
-balloon_eval    +float           +mouse_urxvt     -tag_any_white
-browse          +folding         +mouse_xterm     -tcl
++builtin_terms  -footer          +multi_byte      +terminfo
+byte_offset     +fork()          +multi_lang      +termresponse
+cindent         +gettext         -mzscheme        +textobjects
-clientserver    -hangul_input    +netbeans_intg   +title
-clipboard       +iconv           +path_extra      -toolbar
+cmdline_compl   +insert_expand   -perl            +user_commands
+cmdline_hist    +jumplist        +persistent_undo +vertsplit
+cmdline_info    +keymap          +postscript      +virtualedit
+comments        +langmap         +printer         +visual
+conceal         +libcall         +profile         +visualextra
+cryptv          +linebreak       +python          +viminfo
+cscope          +lispindent      -python3         +vreplace
+cursorbind      +listcmds        +quickfix        +wildignore
+cursorshape     +localmap        +reltime         +wildmenu
+dialog_con      -lua             +rightleft       +windows
+diff            +menu            -ruby            +writebackup
+digraphs        +mksession       +scrollbind      -X11
-dnd             +modify_fname    +signs           -xfontset
-ebcdic          +mouse           +smartindent     -xim
+emacs_tags      -mouseshape      -sniff           -xsmp
+eval            +mouse_dec       +startuptime     -xterm_clipboard
+ex_extra        +mouse_gpm       +statusline      -xterm_save
+extra_search    -mouse_jsbterm   -sun_workshop    -xpm
   system vimrc file: "$VIM/vimrc"
     user vimrc file: "$HOME/.vimrc"
 2nd user vimrc file: "~/.vim/vimrc"
      user exrc file: "$HOME/.exrc"
  fall-back for $VIM: "/usr/share/vim"
Compilation: gcc -c -I. -Iproto -DHAVE_CONFIG_H     -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1      
Linking: gcc   -Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed -o vim        -lm -ltinfo -lnsl  -lselinux  -lacl -lattr -lgpm -ldl    -L/usr/lib/python2.7/config-x86_64-linux-gnu -lpython2.7 -lpthread -ldl -lutil -lm -Xlinker -export-dynamic -Wl,-O1 -Wl,-Bsymbolic-functions      
[34m[1miptables version[0m
iptables v1.4.21
[34m[1mcurl version[0m
curl 7.35.0 (x86_64-pc-linux-gnu) libcurl/7.35.0 OpenSSL/1.0.1f zlib/1.2.8 libidn/1.28 librtmp/2.3
[34m[1mwget version[0m
GNU Wget 1.15 built on linux-gnu.
[34m[1mrsync version[0m
rsync  version 3.1.0  protocol version 31
[34m[1mgimme version[0m
v1.2.0
[34m[1mnvm version[0m
0.33.6
[34m[1mperlbrew version[0m
/home/travis/perl5/perlbrew/bin/perlbrew  - App::perlbrew/0.80
[34m[1mphpenv version[0m
rbenv 1.1.1-25-g6aa70b6
[34m[1mrvm version[0m
rvm 1.29.3 (latest) by Michal Papis, Piotr Kuczynski, Wayne E. Seguin [https://rvm.io]
[34m[1mdefault ruby version[0m
ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]
[34m[1mCouchDB version[0m
couchdb 1.6.1
[34m[1mElasticSearch version[0m
5.5.0
[34m[1mInstalled Firefox version[0m
firefox 56.0.2
[34m[1mMongoDB version[0m
MongoDB 3.4.10
[34m[1mPhantomJS version[0m
2.1.1
[34m[1mPre-installed PostgreSQL versions[0m
9.2.24
9.3.20
9.4.15
9.5.10
9.6.6
[34m[1mRabbitMQ Version[0m
3.6.14
[34m[1mRedis version[0m
redis-server 4.0.6
[34m[1mriak version[0m
2.2.3
[34m[1mPre-installed Go versions[0m
1.7.4
[34m[1mant version[0m
Apache Ant(TM) version 1.9.3 compiled on April 8 2014
[34m[1mmvn version[0m
Apache Maven 3.5.2 (138edd61fd100ec658bfa2d307c43b76940a5d7d; 2017-10-18T07:58:13Z)
Maven home: /usr/local/maven-3.5.2
Java version: 1.8.0_151, vendor: Oracle Corporation
Java home: /usr/lib/jvm/java-8-oracle/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "4.4.0-98-generic", arch: "amd64", family: "unix"
[34m[1mgradle version[0m

------------------------------------------------------------
Gradle 4.0.1
------------------------------------------------------------

Build time:   2017-07-07 14:02:41 UTC
Revision:     38e5dc0f772daecca1d2681885d3d85414eb6826

Groovy:       2.4.11
Ant:          Apache Ant(TM) version 1.9.6 compiled on June 29 2015
JVM:          1.8.0_151 (Oracle Corporation 25.151-b12)
OS:           Linux 4.4.0-98-generic amd64

[34m[1mlein version[0m
Leiningen 2.8.1 on Java 1.8.0_151 Java HotSpot(TM) 64-Bit Server VM
[34m[1mPre-installed Node.js versions[0m
v4.8.6
v6.12.0
v6.12.1
v8.9
v8.9.1
[34m[1mphpenv versions[0m
  system
  5.6
* 5.6.32 (set by /home/travis/.phpenv/version)
  7.0
  7.0.25
  7.1
  7.1.11
  hhvm
  hhvm-stable
[34m[1mcomposer --version[0m
Composer version 1.5.2 2017-09-11 16:59:25
[34m[1mPre-installed Ruby versions[0m
ruby-2.2.7
ruby-2.3.4
ruby-2.4.1
travis_fold:end:system_info
[0K
removed â€˜/etc/apt/sources.list.d/basho_riak.listâ€™
W: http://ppa.launchpad.net/couchdb/stable/ubuntu/dists/trusty/Release.gpg: Signature by key 15866BAFD9BCC4F3C1E0DFC7D69548E1C17EAB57 uses weak digest algorithm (SHA1)

127.0.0.1 localhost nettuno travis vagrant
127.0.1.1 travis-job-485aa97b-c8ca-4ade-a403-5e0b194160ce travis-job-485aa97b-c8ca-4ade-a403-5e0b194160ce ip4-loopback trusty64

travis_fold:start:git.checkout
[0Ktravis_time:start:0616f94a
[0K$ git clone --depth=50 --branch=develop https://github.com/Madmous/madClones.git Madmous/madClones
Cloning into 'Madmous/madClones'...
remote: Counting objects: 1274, done.[K
remote: Compressing objects:   0% (1/692)   [K
remote: Compressing objects:   1% (7/692)   [K
remote: Compressing objects:   2% (14/692)   [K
remote: Compressing objects:   3% (21/692)   [K
remote: Compressing objects:   4% (28/692)   [K
remote: Compressing objects:   5% (35/692)   [K
remote: Compressing objects:   6% (42/692)   [K
remote: Compressing objects:   7% (49/692)   [K
remote: Compressing objects:   8% (56/692)   [K
remote: Compressing objects:   9% (63/692)   [K
remote: Compressing objects:  10% (70/692)   [K
remote: Compressing objects:  11% (77/692)   [K
remote: Compressing objects:  12% (84/692)   [K
remote: Compressing objects:  13% (90/692)   [K
remote: Compressing objects:  14% (97/692)   [K
remote: Compressing objects:  15% (104/692)   [K
remote: Compressing objects:  16% (111/692)   [K
remote: Compressing objects:  17% (118/692)   [K
remote: Compressing objects:  18% (125/692)   [K
remote: Compressing objects:  19% (132/692)   [K
remote: Compressing objects:  20% (139/692)   [K
remote: Compressing objects:  21% (146/692)   [K
remote: Compressing objects:  22% (153/692)   [K
remote: Compressing objects:  23% (160/692)   [K
remote: Compressing objects:  24% (167/692)   [K
remote: Compressing objects:  25% (173/692)   [K
remote: Compressing objects:  26% (180/692)   [K
remote: Compressing objects:  27% (187/692)   [K
remote: Compressing objects:  28% (194/692)   [K
remote: Compressing objects:  29% (201/692)   [K
remote: Compressing objects:  30% (208/692)   [K
remote: Compressing objects:  31% (215/692)   [K
remote: Compressing objects:  32% (222/692)   [K
remote: Compressing objects:  33% (229/692)   [K
remote: Compressing objects:  34% (236/692)   [K
remote: Compressing objects:  35% (243/692)   [K
remote: Compressing objects:  36% (250/692)   [K
remote: Compressing objects:  37% (257/692)   [K
remote: Compressing objects:  38% (263/692)   [K
remote: Compressing objects:  39% (270/692)   [K
remote: Compressing objects:  40% (277/692)   [K
remote: Compressing objects:  41% (284/692)   [K
remote: Compressing objects:  42% (291/692)   [K
remote: Compressing objects:  43% (298/692)   [K
remote: Compressing objects:  44% (305/692)   [K
remote: Compressing objects:  45% (312/692)   [K
remote: Compressing objects:  46% (319/692)   [K
remote: Compressing objects:  47% (326/692)   [K
remote: Compressing objects:  48% (333/692)   [K
remote: Compressing objects:  49% (340/692)   [K
remote: Compressing objects:  50% (346/692)   [K
remote: Compressing objects:  51% (353/692)   [K
remote: Compressing objects:  52% (360/692)   [K
remote: Compressing objects:  53% (367/692)   [K
remote: Compressing objects:  54% (374/692)   [K
remote: Compressing objects:  55% (381/692)   [K
remote: Compressing objects:  56% (388/692)   [K
remote: Compressing objects:  57% (395/692)   [K
remote: Compressing objects:  58% (402/692)   [K
remote: Compressing objects:  59% (409/692)   [K
remote: Compressing objects:  60% (416/692)   [K
remote: Compressing objects:  61% (423/692)   [K
remote: Compressing objects:  62% (430/692)   [K
remote: Compressing objects:  63% (436/692)   [K
remote: Compressing objects:  64% (443/692)   [K
remote: Compressing objects:  65% (450/692)   [K
remote: Compressing objects:  66% (457/692)   [K
remote: Compressing objects:  67% (464/692)   [K
remote: Compressing objects:  68% (471/692)   [K
remote: Compressing objects:  69% (478/692)   [K
remote: Compressing objects:  70% (485/692)   [K
remote: Compressing objects:  71% (492/692)   [K
remote: Compressing objects:  72% (499/692)   [K
remote: Compressing objects:  73% (506/692)   [K
remote: Compressing objects:  74% (513/692)   [K
remote: Compressing objects:  75% (519/692)   [K
remote: Compressing objects:  76% (526/692)   [K
remote: Compressing objects:  77% (533/692)   [K
remote: Compressing objects:  78% (540/692)   [K
remote: Compressing objects:  79% (547/692)   [K
remote: Compressing objects:  80% (554/692)   [K
remote: Compressing objects:  81% (561/692)   [K
remote: Compressing objects:  82% (568/692)   [K
remote: Compressing objects:  83% (575/692)   [K
remote: Compressing objects:  84% (582/692)   [K
remote: Compressing objects:  85% (589/692)   [K
remote: Compressing objects:  86% (596/692)   [K
remote: Compressing objects:  87% (603/692)   [K
remote: Compressing objects:  88% (609/692)   [K
remote: Compressing objects:  89% (616/692)   [K
remote: Compressing objects:  90% (623/692)   [K
remote: Compressing objects:  91% (630/692)   [K
remote: Compressing objects:  92% (637/692)   [K
remote: Compressing objects:  93% (644/692)   [K
remote: Compressing objects:  94% (651/692)   [K
remote: Compressing objects:  95% (658/692)   [K
remote: Compressing objects:  96% (665/692)   [K
remote: Compressing objects:  97% (672/692)   [K
remote: Compressing objects:  98% (679/692)   [K
remote: Compressing objects:  99% (686/692)   [K
remote: Compressing objects: 100% (692/692)   [K
remote: Compressing objects: 100% (692/692), done.[K
Receiving objects:   0% (1/1274)   
Receiving objects:   1% (13/1274)   
Receiving objects:   2% (26/1274)   
Receiving objects:   3% (39/1274)   
Receiving objects:   4% (51/1274)   
Receiving objects:   5% (64/1274)   
Receiving objects:   6% (77/1274)   
Receiving objects:   7% (90/1274)   
Receiving objects:   8% (102/1274)   
Receiving objects:   9% (115/1274)   
Receiving objects:  10% (128/1274)   
Receiving objects:  11% (141/1274)   
Receiving objects:  12% (153/1274)   
Receiving objects:  13% (166/1274)   
Receiving objects:  14% (179/1274)   
Receiving objects:  15% (192/1274)   
Receiving objects:  16% (204/1274)   
Receiving objects:  17% (217/1274)   
Receiving objects:  18% (230/1274)   
Receiving objects:  19% (243/1274)   
Receiving objects:  20% (255/1274)   
Receiving objects:  21% (268/1274)   
Receiving objects:  22% (281/1274)   
Receiving objects:  23% (294/1274)   
Receiving objects:  24% (306/1274)   
Receiving objects:  25% (319/1274)   
Receiving objects:  26% (332/1274)   
Receiving objects:  27% (344/1274)   
Receiving objects:  28% (357/1274)   
Receiving objects:  29% (370/1274)   
Receiving objects:  30% (383/1274)   
Receiving objects:  31% (395/1274)   
Receiving objects:  32% (408/1274)   
Receiving objects:  33% (421/1274)   
Receiving objects:  34% (434/1274)   
Receiving objects:  35% (446/1274)   
Receiving objects:  36% (459/1274)   
Receiving objects:  37% (472/1274)   
Receiving objects:  38% (485/1274)   
Receiving objects:  39% (497/1274)   
Receiving objects:  40% (510/1274)   
Receiving objects:  41% (523/1274)   
Receiving objects:  42% (536/1274)   
Receiving objects:  43% (548/1274)   
Receiving objects:  44% (561/1274)   
Receiving objects:  45% (574/1274)   
Receiving objects:  46% (587/1274)   
Receiving objects:  47% (599/1274)   
Receiving objects:  48% (612/1274)   
Receiving objects:  49% (625/1274)   
Receiving objects:  50% (637/1274)   
Receiving objects:  51% (650/1274)   
Receiving objects:  52% (663/1274)   
Receiving objects:  53% (676/1274)   
Receiving objects:  54% (688/1274)   
Receiving objects:  55% (701/1274)   
Receiving objects:  56% (714/1274)   
Receiving objects:  57% (727/1274)   
Receiving objects:  58% (739/1274)   
Receiving objects:  59% (752/1274)   
Receiving objects:  60% (765/1274)   
Receiving objects:  61% (778/1274)   
Receiving objects:  62% (790/1274)   
Receiving objects:  63% (803/1274)   
Receiving objects:  64% (816/1274)   
Receiving objects:  65% (829/1274)   
Receiving objects:  66% (841/1274)   
Receiving objects:  67% (854/1274)   
Receiving objects:  68% (867/1274)   
Receiving objects:  69% (880/1274)   
Receiving objects:  70% (892/1274)   
Receiving objects:  71% (905/1274)   
Receiving objects:  72% (918/1274)   
Receiving objects:  73% (931/1274)   
Receiving objects:  74% (943/1274)   
Receiving objects:  75% (956/1274)   
Receiving objects:  76% (969/1274)   
Receiving objects:  77% (981/1274)   
Receiving objects:  78% (994/1274)   
Receiving objects:  79% (1007/1274)   
Receiving objects:  80% (1020/1274)   
Receiving objects:  81% (1032/1274)   
remote: Total 1274 (delta 600), reused 1037 (delta 517), pack-reused 0[K
Receiving objects:  82% (1045/1274)   
Receiving objects:  83% (1058/1274)   
Receiving objects:  84% (1071/1274)   
Receiving objects:  85% (1083/1274)   
Receiving objects:  86% (1096/1274)   
Receiving objects:  87% (1109/1274)   
Receiving objects:  88% (1122/1274)   
Receiving objects:  89% (1134/1274)   
Receiving objects:  90% (1147/1274)   
Receiving objects:  91% (1160/1274)   
Receiving objects:  92% (1173/1274)   
Receiving objects:  93% (1185/1274)   
Receiving objects:  94% (1198/1274)   
Receiving objects:  95% (1211/1274)   
Receiving objects:  96% (1224/1274)   
Receiving objects:  97% (1236/1274)   
Receiving objects:  98% (1249/1274)   
Receiving objects:  99% (1262/1274)   
Receiving objects: 100% (1274/1274)   
Receiving objects: 100% (1274/1274), 419.79 KiB | 5.25 MiB/s, done.
Resolving deltas:   0% (0/600)   
Resolving deltas:   1% (8/600)   
Resolving deltas:   3% (19/600)   
Resolving deltas:   4% (24/600)   
Resolving deltas:   5% (32/600)   
Resolving deltas:   6% (37/600)   
Resolving deltas:   8% (49/600)   
Resolving deltas:   9% (55/600)   
Resolving deltas:  12% (75/600)   
Resolving deltas:  14% (84/600)   
Resolving deltas:  16% (96/600)   
Resolving deltas:  17% (103/600)   
Resolving deltas:  18% (112/600)   
Resolving deltas:  22% (135/600)   
Resolving deltas:  23% (138/600)   
Resolving deltas:  25% (154/600)   
Resolving deltas:  37% (222/600)   
Resolving deltas:  40% (240/600)   
Resolving deltas:  41% (247/600)   
Resolving deltas:  42% (252/600)   
Resolving deltas:  43% (259/600)   
Resolving deltas:  44% (264/600)   
Resolving deltas:  45% (270/600)   
Resolving deltas:  46% (276/600)   
Resolving deltas:  47% (287/600)   
Resolving deltas:  48% (290/600)   
Resolving deltas:  49% (294/600)   
Resolving deltas:  50% (304/600)   
Resolving deltas:  51% (310/600)   
Resolving deltas:  52% (315/600)   
Resolving deltas:  53% (322/600)   
Resolving deltas:  54% (324/600)   
Resolving deltas:  55% (333/600)   
Resolving deltas:  56% (338/600)   
Resolving deltas:  57% (342/600)   
Resolving deltas:  58% (349/600)   
Resolving deltas:  59% (357/600)   
Resolving deltas:  60% (361/600)   
Resolving deltas:  61% (366/600)   
Resolving deltas:  62% (372/600)   
Resolving deltas:  63% (381/600)   
Resolving deltas:  64% (384/600)   
Resolving deltas:  65% (393/600)   
Resolving deltas:  66% (396/600)   
Resolving deltas:  67% (402/600)   
Resolving deltas:  68% (409/600)   
Resolving deltas:  69% (414/600)   
Resolving deltas:  70% (424/600)   
Resolving deltas:  71% (426/600)   
Resolving deltas:  72% (436/600)   
Resolving deltas:  73% (440/600)   
Resolving deltas:  74% (444/600)   
Resolving deltas:  77% (467/600)   
Resolving deltas:  78% (471/600)   
Resolving deltas:  79% (478/600)   
Resolving deltas:  80% (481/600)   
Resolving deltas:  82% (497/600)   
Resolving deltas:  84% (508/600)   
Resolving deltas:  85% (511/600)   
Resolving deltas:  86% (518/600)   
Resolving deltas:  89% (534/600)   
Resolving deltas:  91% (547/600)   
Resolving deltas:  92% (556/600)   
Resolving deltas:  93% (559/600)   
Resolving deltas:  95% (570/600)   
Resolving deltas:  96% (577/600)   
Resolving deltas:  97% (582/600)   
Resolving deltas:  98% (593/600)   
Resolving deltas:  99% (594/600)   
Resolving deltas: 100% (600/600)   
Resolving deltas: 100% (600/600), done.

travis_time:end:0616f94a:start=1519110505851918935,finish=1519110506534877505,duration=682958570
[0K$ cd Madmous/madClones
$ git checkout -qf 29f4a82afc650b430a9a785feb49f006366f9d67
travis_fold:end:git.checkout
[0Ktravis_fold:start:services
[0Ktravis_time:start:15842f34
[0K$ sudo service docker start
start: Job is already running: docker

travis_time:end:15842f34:start=1519110506564858119,finish=1519110506584008690,duration=19150571
[0Ktravis_fold:end:services
[0K
[33;1mSetting environment variables from .travis.yml[0m
$ export DOCKER_COMPOSE_VERSION=1.13.0

[33;1mDisabling Gradle daemon[0m
travis_time:start:1af6732a
[0K$ mkdir -p ~/.gradle && echo "org.gradle.daemon=false" >> ~/.gradle/gradle.properties

travis_time:end:1af6732a:start=1519110509600176141,finish=1519110509610399161,duration=10223020
[0Ktravis_fold:start:rvm
[0Ktravis_time:start:0bbf79fa
[0K$ rvm use default
[32mUsing /home/travis/.rvm/gems/ruby-2.4.1[0m

** Updating RubyGems to the latest version for security reasons. **
** If you need an older version, you can downgrade with 'gem update --system OLD_VERSION'. **

Updating rubygems-update
Fetching: rubygems-update-2.7.6.gem
Fetching: rubygems-update-2.7.6.gem (  1%)
Fetching: rubygems-update-2.7.6.gem (  2%)
Fetching: rubygems-update-2.7.6.gem (  3%)
Fetching: rubygems-update-2.7.6.gem (  4%)
Fetching: rubygems-update-2.7.6.gem (  5%)
Fetching: rubygems-update-2.7.6.gem (  7%)
Fetching: rubygems-update-2.7.6.gem (  9%)
Fetching: rubygems-update-2.7.6.gem ( 11%)
Fetching: rubygems-update-2.7.6.gem ( 13%)
Fetching: rubygems-update-2.7.6.gem ( 15%)
Fetching: rubygems-update-2.7.6.gem ( 17%)
Fetching: rubygems-update-2.7.6.gem ( 19%)
Fetching: rubygems-update-2.7.6.gem ( 21%)
Fetching: rubygems-update-2.7.6.gem ( 23%)
Fetching: rubygems-update-2.7.6.gem ( 25%)
Fetching: rubygems-update-2.7.6.gem ( 27%)
Fetching: rubygems-update-2.7.6.gem ( 29%)
Fetching: rubygems-update-2.7.6.gem ( 30%)
Fetching: rubygems-update-2.7.6.gem ( 32%)
Fetching: rubygems-update-2.7.6.gem ( 34%)
Fetching: rubygems-update-2.7.6.gem ( 36%)
Fetching: rubygems-update-2.7.6.gem ( 38%)
Fetching: rubygems-update-2.7.6.gem ( 40%)
Fetching: rubygems-update-2.7.6.gem ( 42%)
Fetching: rubygems-update-2.7.6.gem ( 44%)
Fetching: rubygems-update-2.7.6.gem ( 46%)
Fetching: rubygems-update-2.7.6.gem ( 48%)
Fetching: rubygems-update-2.7.6.gem ( 50%)
Fetching: rubygems-update-2.7.6.gem ( 52%)
Fetching: rubygems-update-2.7.6.gem ( 54%)
Fetching: rubygems-update-2.7.6.gem ( 56%)
Fetching: rubygems-update-2.7.6.gem ( 58%)
Fetching: rubygems-update-2.7.6.gem ( 60%)
Fetching: rubygems-update-2.7.6.gem ( 62%)
Fetching: rubygems-update-2.7.6.gem ( 64%)
Fetching: rubygems-update-2.7.6.gem ( 66%)
Fetching: rubygems-update-2.7.6.gem ( 68%)
Fetching: rubygems-update-2.7.6.gem ( 69%)
Fetching: rubygems-update-2.7.6.gem ( 71%)
Fetching: rubygems-update-2.7.6.gem ( 73%)
Fetching: rubygems-update-2.7.6.gem ( 75%)
Fetching: rubygems-update-2.7.6.gem ( 77%)
Fetching: rubygems-update-2.7.6.gem ( 79%)
Fetching: rubygems-update-2.7.6.gem ( 81%)
Fetching: rubygems-update-2.7.6.gem ( 83%)
Fetching: rubygems-update-2.7.6.gem ( 85%)
Fetching: rubygems-update-2.7.6.gem ( 87%)
Fetching: rubygems-update-2.7.6.gem ( 89%)
Fetching: rubygems-update-2.7.6.gem ( 91%)
Fetching: rubygems-update-2.7.6.gem ( 93%)
Fetching: rubygems-update-2.7.6.gem ( 95%)
Fetching: rubygems-update-2.7.6.gem ( 96%)
Fetching: rubygems-update-2.7.6.gem ( 98%)
Fetching: rubygems-update-2.7.6.gem (100%)
Fetching: rubygems-update-2.7.6.gem (100%)
Successfully installed rubygems-update-2.7.6
Installing RubyGems 2.7.6
Bundler 1.16.1 installed
RubyGems 2.7.6 installed
Regenerating binstubs

=== 2.7.6 / 2018-02-16

Security fixes:

* Prevent path traversal when writing to a symlinked basedir outside of the root.
  Discovered by nmalkin, fixed by Jonathan Claudius and Samuel Giddins.
* Fix possible Unsafe Object Deserialization Vulnerability in gem owner.
  Fixed by Jonathan Claudius.
* Strictly interpret octal fields in tar headers.
  Discoved by plover, fixed by Samuel Giddins.
* Raise a security error when there are duplicate files in a package.
  Discovered by plover, fixed by Samuel Giddins.
* Enforce URL validation on spec homepage attribute.
  Discovered by Yasin Soliman, fixed by Jonathan Claudius.
* Mitigate XSS vulnerability in homepage attribute when displayed via `gem server`.
  Discovered by Yasin Soliman, fixed by Jonathan Claudius.
* Prevent Path Traversal issue during gem installation.
  Discovered by nmalkin.

=== 2.7.4

Bug fixes:

* Fixed leaked FDs. Pull request #2127 by Nobuyoshi Nakada.
* Avoid to warnings about gemspec loadings in rubygems tests. Pull request
  #2125 by SHIBATA Hiroshi.
* Fix updater with rubygems-2.7.3 Pull request #2124 by SHIBATA Hiroshi.
* Handle environment that does not have `flock` system call. Pull request
  #2107 by SHIBATA Hiroshi.

=== 2.7.3

Minor enhancements:

* Removed needless version lock. Pull request #2074 by SHIBATA Hiroshi.
* Add --[no-]check-development option to cleanup command. Pull request
  #2061 by Lin Jen-Shin (godfat).
* Merge glob pattern using braces. Pull request #2072 by Kazuhiro
  NISHIYAMA.
* Removed warnings of unused variables. Pull request #2084 by SHIBATA
  Hiroshi.
* Call SPDX.org using HTTPS. Pull request #2102 by Olle Jonsson.
* Remove multi load warning from plugins documentation. Pull request #2103
  by Thibault Jouan.

Bug fixes:

* Fix test failure on Alpine Linux. Pull request #2079 by Ellen Marie
  Dash.
* Avoid encoding issues by using binread in setup. Pull request #2089 by
  Mauro Morales.
* Fix rake install_test_deps once the rake clean_env does not exist. Pull
  request #2090 by Lucas Oliveira.
* Prevent to delete to "bundler-" prefix gem like bundler-audit. Pull
  request #2086 by SHIBATA Hiroshi.
* Generate .bat files on Windows platform. Pull request #2094 by SHIBATA
  Hiroshi.
* Workaround common options mutation in Gem::Command test. Pull request
  #2098 by Thibault Jouan.
* Check gems dir existence before removing bundler. Pull request #2104 by
  Thibault Jouan.
* Use setup command --regenerate-binstubs option flag. Pull request #2099
  by Thibault Jouan.

=== 2.7.2

Bug fixes:

* Added template files to vendoerd bundler. Pull request #2065 by SHIBATA
  Hiroshi.
* Added workaround for non-git environment. Pull request #2066 by SHIBATA
  Hiroshi.

=== 2.7.1 (2017-11-03)

Bug fixes:

* Fix `gem update --system` with RubyGems 2.7+. Pull request #2054 by
  Samuel Giddins.

=== 2.7.0 (2017-11-02)

Major enhancements:

* Update vendored bundler-1.16.0. Pull request #2051 by Samuel Giddins.
* Use Bundler for Gem.use_gemdeps. Pull request #1674 by Samuel Giddins.
* Add command `signin` to `gem` CLI. Pull request #1944 by Shiva Bhusal.
* Add Logout feature to CLI. Pull request #1938 by Shiva Bhusal.

Minor enhancements:

* Added message to uninstall command for gem that is not installed. Pull
  request #1979 by anant anil kolvankar.
* Add --trust-policy option to unpack command. Pull request #1718 by
  Nobuyoshi Nakada.
* Show default gems for all platforms. Pull request #1685 by Konstantin
  Shabanov.
* Add Travis and Appveyor build status to README. Pull request #1918 by
  Jun Aruga.
* Remove warning `no email specified` when no email. Pull request #1675 by
  Leigh McCulloch.
* Improve -rubygems performance. Pull request #1801 by Samuel Giddins.
* Improve the performance of Kernel#require. Pull request #1678 by Samuel
  Giddins.
* Improve user-facing messages by consistent casing of Ruby/RubyGems. Pull
  request #1771 by John Labovitz.
* Improve error message when Gem::RuntimeRequirementNotMetError is raised.
  Pull request #1789 by Luis Sagastume.
* Code Improvement: Inheritance corrected. Pull request #1942 by Shiva
  Bhusal.
* [Source] Autoload fileutils. Pull request #1906 by Samuel Giddins.
* Use Hash#fetch instead of if/else in Gem::ConfigFile. Pull request #1824
  by Daniel Berger.
* Require digest when it is used. Pull request #2006 by Samuel Giddins.
* Do not index the doc folder in the `update_manifest` task. Pull request
  #2031 by Colby Swandale.
* Don't use two postfix conditionals on one line. Pull request #2038 by
  Ellen Marie Dash.
* [SafeYAML] Avoid warning when Gem::Deprecate.skip is set. Pull request
  #2034 by Samuel Giddins.
* Update gem yank description. Pull request #2009 by David Radcliffe.
* Fix formatting of installation instructions in README. Pull request
  #2018 by Jordan Danford.
* Do not use #quick_spec internally. Pull request #1733 by Jon Moss.
* Switch from docs to guides reference. Pull request #1886 by Jonathan
  Claudius.
* Happier message when latest version is already installed. Pull request
  #1956 by Jared Beck.
* Update specification reference docs. Pull request #1960 by Grey Baker.
* Allow Gem.finish_resolve to respect already-activated specs. Pull
  request #1910 by Samuel Giddins.
* Update cryptography for Gem::Security. Pull request #1691 by Sylvain
  Daubert.
* Don't output mkmf.log message if compilation didn't fail. Pull request
  #1808 by Jeremy Evans.
* Matches_for_glob - remove root path. Pull request #2010 by ahorek.
* Gem::Resolver#search_for update for reliable searching/sorting. Pull
  request #1993 by MSP-Greg.
* Allow local installs with transitive prerelease requirements. Pull
  request #1990 by Samuel Giddins.
* Small style fixes to Installer Set. Pull request #1985 by Arthur
  Marzinkovskiy.
* Setup cmd: Avoid terminating option string w/ dot. Pull request #1825 by
  Olle Jonsson.
* Warn when no files are set. Pull request #1773 by Aidan Coyle.
* Ensure `to_spec` falls back on prerelease specs. Pull request #1755 by
  AndrÃ© Arko.
* [Specification] Eval setting default attributes in #initialize. Pull
  request #1739 by Samuel Giddins.
* Sort ordering of sources is preserved. Pull request #1633 by Nathan
  Ladd.
* Retry with :prerelease when no suggestions are found. Pull request #1696
  by Aditya Prakash.
* [Rakefile] Run `git submodule update --init` in `rake newb`. Pull
  request #1694 by Samuel Giddins.
* [TestCase] Address comments around ui changes. Pull request #1677 by
  Samuel Giddins.
* Eagerly resolve in activate_bin_path. Pull request #1666 by Samuel
  Giddins.
* [Version] Make hash based upon canonical segments. Pull request #1659 by
  Samuel Giddins.
* Add Ruby Together CTA, rearrange README a bit. Pull request #1775 by
  Michael Bernstein.
* Update Contributing.rdoc with new label usage. Pull request #1716 by
  Lynn Cyrin.
* Add --host sample to help. Pull request #1709 by Code Ahss.
* Add a helpful suggestion when `gem install` fails due to required_rubâ€¦.
  Pull request #1697 by Samuel Giddins.
* Add cert expiration length flag. Pull request #1725 by Luis Sagastume.
* Add submodule instructions to manual install. Pull request #1727 by
  Joseph Frazier.
* Allow usage of multiple `--version` operators. Pull request #1546 by
  James Wen.
* Warn when requiring deprecated files. Pull request #1939 by Ellen Marie
  Dash.

Compatibility changes:

* Use `-rrubygems` instead of `-rubygems.rb`. Because ubygems.rb is
  unavailable on Ruby 2.5. Pull request #2028 #2027 #2029
  by SHIBATA Hiroshi.
* Deprecate Gem::InstallerTestCase#util_gem_bindir and
  Gem::InstallerTestCase#util_gem_dir. Pull request #1729 by Jon Moss.
* Deprecate passing options to Gem::GemRunner. Pull request #1730 by Jon
  Moss.
* Add deprecation for Gem#datadir. Pull request #1732 by Jon Moss.
* Add deprecation warning for Gem::DependencyInstaller#gems_to_install.
  Pull request #1731 by Jon Moss.
* Update Code of Conduct to Contributor Covenant v1.4.0. Pull request
  #1796 by Matej.

Bug fixes:

* Fix issue for MinGW / MSYS2 builds and testing. Pull request #1876 by
  MSP-Greg.
* Fixed broken links and overzealous URL encoding in gem server. Pull
  request #1809 by Nicole Orchard.
* Fix a typo. Pull request #1722 by Koichi ITO.
* Fix error message Gem::Security::Policy. Pull request #1724 by Nobuyoshi
  Nakada.
* Fixing links markdown formatting in README. Pull request #1791 by Piotr
  Kuczynski.
* Fix failing Bundler 1.8.7 CI builds. Pull request #1820 by Samuel
  Giddins.
* Fixed test broken on ruby-head . Pull request #1842 by SHIBATA Hiroshi.
* Fix typos with misspell. Pull request #1846 by SHIBATA Hiroshi.
* Fix gem open to open highest version number rather than lowest. Pull
  request #1877 by Tim Pope.
* Fix test_self_find_files_with_gemfile to sort expected files. Pull
  request #1878 by Kazuaki Matsuo.
* Fix typos in CONTRIBUTING.rdoc. Pull request #1909 by Mark Sayson.
* Fix some small documentation issues in installer. Pull request #1972 by
  Colby Swandale.
* Fix links in Policies document. Pull request #1964 by Alyssa Ross.
* Fix NoMethodError on bundler/inline environment. Pull request #2042 by
  SHIBATA Hiroshi.
* Correct comments for Gem::InstallerTestCase#setup. Pull request #1741 by
  MSP-Greg.
* Use File.expand_path for certification and key location. Pull request
  #1987 by SHIBATA Hiroshi.
* Rescue EROFS. Pull request #1417 by Nobuyoshi Nakada.
* Fix spelling of 'vulnerability'. Pull request #2022 by Philip Arndt.
* Fix metadata link key names. Pull request #1896 by Aditya Prakash.
* Fix a typo in uninstall_command.rb. Pull request #1934 by Yasuhiro
  Horimoto.
* Gem::Requirement.create treat arguments as variable-length. Pull request
  #1830 by Toru YAGI.
* Display an explanation when rake encounters an ontological problem. Pull
  request #1982 by Wilson Bilkovich.
* [Server] Handle gems with names ending in `-\d`. Pull request #1926 by
  Samuel Giddins.
* [InstallerSet] Avoid reloading _all_ local gems multiple times during
  dependency resolution. Pull request #1925 by Samuel Giddins.
* Modify the return value of Gem::Version.correct?. Pull request #1916 by
  Tsukuru Tanimichi.
* Validate metadata link keys. Pull request #1834 by Aditya Prakash.
* Add changelog to metadata validation. Pull request #1885 by Aditya
  Prakash.
* Replace socket error text message. Pull request #1823 by Daniel Berger.
* Raise error if the email is invalid when building cert. Pull request
  #1779 by Luis Sagastume.
* [StubSpecification] Donâ€™t iterate through all loaded specs in #to_spec.
  Pull request #1738 by Samuel Giddins.

=== 2.6.14 / 2017-10-09

Security fixes:

* Whitelist classes and symbols that are in loaded YAML.
  See CVE-2017-0903 for full details.
  Fix by Aaron Patterson.

=== 2.6.13 / 2017-08-27

Security fixes:

* Fix a DNS request hijacking vulnerability. (CVE-2017-0902)
  Discovered by Jonathan Claudius, fix by Samuel Giddins.
* Fix an ANSI escape sequence vulnerability. (CVE-2017-0899)
  Discovered by Yusuke Endoh, fix by Evan Phoenix.
* Fix a DOS vulnerability in the `query` command. (CVE-2017-0900)
  Discovered by Yusuke Endoh, fix by Samuel Giddins.
* Fix a vulnerability in the gem installer that allowed a malicious gem
  to overwrite arbitrary files. (CVE-2017-0901)
  Discovered by Yusuke Endoh, fix by Samuel Giddins.

=== 2.6.12 / 2017-04-30

Bug fixes:

* Fix test_self_find_files_with_gemfile to sort expected files. Pull
  request #1880 by Kazuaki Matsuo.
* Fix issue for MinGW / MSYS2 builds and testing. Pull request #1879 by
  MSP-Greg.
* Fix gem open to open highest version number rather than lowest. Pull
  request #1877 by Tim Pope.
* Add a test for requiring a default spec as installed by the ruby
  installer. Pull request #1899 by Samuel Giddins.
* Fix broken --exact parameter to gem command. Pull request #1873 by Jason
  Frey.
* [Installer] Generate backwards-compatible binstubs. Pull request #1904
  by Samuel Giddins.
* Fix pre-existing source recognition on add action. Pull request #1883 by
  Jonathan Claudius.
* Prevent negative IDs in output of #inspect. Pull request #1908 by VÃ­t
  Ondruch.
* Allow Gem.finish_resolve to respect already-activated specs. Pull
  request #1910 by Samuel Giddins.


------------------------------------------------------------------------------

RubyGems installed the following executables:
	/home/travis/.rvm/rubies/ruby-2.4.1/bin/gem
	/home/travis/.rvm/rubies/ruby-2.4.1/bin/bundle

RubyGems system software updated

travis_time:end:0bbf79fa:start=1519110509620824360,finish=1519110514337960827,duration=4717136467
[0Ktravis_fold:end:rvm
[0K$ ruby --version
ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]
$ rvm --version
rvm 1.29.3 (latest) by Michal Papis, Piotr Kuczynski, Wayne E. Seguin [https://rvm.io]
$ bundle --version
Bundler version 1.16.1
$ gem --version
2.7.6
travis_fold:start:before_install.1
[0Ktravis_time:start:1162c9bc
[0K$ sudo apt-get update

0% [Working]
            
Ign:1 http://us-central1.gce.archive.ubuntu.com/ubuntu trusty InRelease

0% [Connecting to security.ubuntu.com (91.189.91.23)] [Connecting to www.apache
                                                                               
Hit:2 http://us-central1.gce.archive.ubuntu.com/ubuntu trusty-updates InRelease

0% [Connecting to security.ubuntu.com (91.189.91.23)] [Connecting to www.apache
                                                                               
Hit:3 http://us-central1.gce.archive.ubuntu.com/ubuntu trusty-backports InRelease

0% [Connecting to security.ubuntu.com (91.189.91.23)] [Connecting to www.apache
0% [2 InRelease gpgv 65.9 kB] [Waiting for headers] [Connecting to security.ubu
                                                                               
Hit:4 http://us-central1.gce.archive.ubuntu.com/ubuntu trusty Release

0% [2 InRelease gpgv 65.9 kB] [Connecting to security.ubuntu.com (91.189.91.23)
                                                                               
Ign:5 http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 InRelease

0% [2 InRelease gpgv 65.9 kB] [Waiting for headers] [Connecting to www.apache.o
                                                                               
Hit:6 http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 Release

0% [2 InRelease gpgv 65.9 kB] [Waiting for headers] [Waiting for headers] [Conn
                                                                               
Hit:7 http://security.ubuntu.com/ubuntu trusty-security InRelease

0% [2 InRelease gpgv 65.9 kB] [Waiting for headers] [Connecting to ppa.launchpa
                                                                               
Hit:8 http://apt.postgresql.org/pub/repos/apt trusty-pgdg InRelease

0% [2 InRelease gpgv 65.9 kB] [Waiting for headers] [Connecting to ppa.launchpa
                                                                               
Ign:9 http://dl.google.com/linux/chrome/deb stable InRelease

0% [2 InRelease gpgv 65.9 kB] [Waiting for headers] [Connecting to ppa.launchpa
0% [2 InRelease gpgv 65.9 kB] [Connecting to ppa.launchpad.net (91.189.95.83)] 
                                                                               
Hit:12 http://dl.google.com/linux/chrome/deb stable Release

0% [Connecting to heroku-toolbelt.s3.amazonaws.com] [2 InRelease gpgv 65.9 kB] 
                                                                               
Ign:10 http://toolbelt.heroku.com/ubuntu ./ InRelease

                                                                               
0% [Waiting for headers] [2 InRelease gpgv 65.9 kB] [Waiting for headers]
                                                                         
0% [Waiting for headers] [Waiting for headers] [Waiting for headers]
0% [Waiting for headers] [3 InRelease gpgv 65.9 kB] [Waiting for headers] [Wait
                                                                               
0% [Waiting for headers] [3 InRelease gpgv 65.9 kB] [Waiting for headers]
                                                                         
Get:11 http://dl.bintray.com/apache/cassandra 39x InRelease [3,168 B]

0% [Waiting for headers] [3 InRelease gpgv 65.9 kB] [Waiting for headers]
                                                                         
Hit:14 http://ppa.launchpad.net/chris-lea/redis-server/ubuntu trusty InRelease

0% [Waiting for headers] [3 InRelease gpgv 65.9 kB] [Connecting to ppa.launchpa
                                                                               
Hit:13 http://toolbelt.heroku.com/ubuntu ./ Release

                                                                               
0% [3 InRelease gpgv 65.9 kB] [Connecting to ppa.launchpad.net (91.189.95.83)]
                                                                              
0% [Connecting to ppa.launchpad.net (91.189.95.83)]
0% [Release.gpg gpgv 58.5 kB] [Connecting to ppa.launchpad.net (91.189.95.83)]
                                                                              
0% [Waiting for headers]
0% [Release.gpg gpgv 2,495 B] [Waiting for headers]
                                                   
Hit:16 https://download.docker.com/linux/ubuntu trusty InRelease

0% [Release.gpg gpgv 2,495 B] [Waiting for headers]
                                                   
Hit:17 https://dl.hhvm.com/ubuntu trusty InRelease

0% [Release.gpg gpgv 2,495 B] [Waiting for headers]
                                                   
0% [Waiting for headers]
0% [7 InRelease gpgv 65.9 kB] [Waiting for headers]
                                                   
Ign:19 http://ppa.launchpad.net/couchdb/stable/ubuntu trusty InRelease

0% [7 InRelease gpgv 65.9 kB] [Connecting to ppa.launchpad.net (91.189.95.83)]
                                                                              
0% [Connecting to ppa.launchpad.net (91.189.95.83)]
0% [8 InRelease gpgv 56.4 kB] [Connecting to ppa.launchpad.net (91.189.95.83)]
                                                                              
0% [Waiting for headers]
0% [Release.gpg gpgv 1,189 B] [Waiting for headers]
                                                   
0% [Waiting for headers]
0% [11 InRelease gpgv 3,168 B] [Waiting for headers]
                                                    
Hit:21 http://ppa.launchpad.net/git-core/ppa/ubuntu trusty InRelease

                                                    
0% [11 InRelease gpgv 3,168 B]
0% [Connecting to ppa.launchpad.net (91.189.95.83)]
0% [14 InRelease gpgv 15.4 kB] [Connecting to ppa.launchpad.net (91.189.95.83)]
                                                                               
0% [Waiting for headers]
0% [Release.gpg gpgv 1,609 B] [Waiting for headers]
                                                   
0% [Waiting for headers]
0% [16 InRelease gpgv 26.5 kB] [Waiting for headers]
                                                    
Hit:23 http://ppa.launchpad.net/openjdk-r/ppa/ubuntu trusty InRelease

                                                    
0% [16 InRelease gpgv 26.5 kB]
0% [Connecting to ppa.launchpad.net (91.189.95.83)]
0% [17 InRelease gpgv 2,411 B] [Connecting to ppa.launchpad.net (91.189.95.83)]
                                                                               
0% [Connecting to ppa.launchpad.net (91.189.95.83)]
0% [21 InRelease gpgv 15.4 kB] [Connecting to ppa.launchpad.net (91.189.95.83)]
                                                                               
Hit:24 https://packagecloud.io/computology/apt-backport/ubuntu trusty InRelease

                                                                               
0% [21 InRelease gpgv 15.4 kB] [Waiting for headers]
                                                    
0% [Waiting for headers]
0% [23 InRelease gpgv 15.5 kB] [Waiting for headers]
                                                    
0% [Waiting for headers]
0% [24 InRelease gpgv 23.7 kB] [Waiting for headers]
                                                    
Hit:25 http://ppa.launchpad.net/pollinate/ppa/ubuntu trusty InRelease

                                                    
0% [24 InRelease gpgv 23.7 kB]
                              
Hit:26 https://packagecloud.io/github/git-lfs/ubuntu trusty InRelease

0% [24 InRelease gpgv 23.7 kB] [Connecting to ppa.launchpad.net (91.189.95.83)]
                                                                               
0% [Connecting to ppa.launchpad.net (91.189.95.83)]
0% [25 InRelease gpgv 15.4 kB] [Connecting to ppa.launchpad.net (91.189.95.83)]
                                                                               
0% [Connecting to ppa.launchpad.net (91.189.95.83)]
0% [26 InRelease gpgv 23.2 kB] [Connecting to ppa.launchpad.net (91.189.95.83)]
                                                                               
0% [Waiting for headers]
                        
Hit:27 https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu trusty InRelease

0% [Waiting for headers]
0% [27 InRelease gpgv 23.7 kB] [Waiting for headers]
                                                    
Hit:28 http://ppa.launchpad.net/webupd8team/java/ubuntu trusty InRelease

0% [27 InRelease gpgv 23.7 kB] [Connecting to ppa.launchpad.net (91.189.95.83)]
                                                                               
0% [Connecting to ppa.launchpad.net (91.189.95.83)]
0% [28 InRelease gpgv 15.5 kB] [Connecting to ppa.launchpad.net (91.189.95.83)]
                                                                               
0% [Connecting to ppa.launchpad.net (91.189.95.83)]
                                                   
Hit:29 http://ppa.launchpad.net/couchdb/stable/ubuntu trusty Release

                                                   
99% [Working]
99% [Release.gpg gpgv 15.1 kB]
                              
100% [Working]
              
Fetched 3,168 B in 1s (2,145 B/s)

Reading package lists... 0%

Reading package lists... 0%

Reading package lists... 1%

Reading package lists... 6%

Reading package lists... 6%

Reading package lists... 12%

Reading package lists... 12%

Reading package lists... 12%

Reading package lists... 12%

Reading package lists... 12%

Reading package lists... 12%

Reading package lists... 36%

Reading package lists... 36%

Reading package lists... 38%

Reading package lists... 60%

Reading package lists... 60%

Reading package lists... 60%

Reading package lists... 60%

Reading package lists... 61%

Reading package lists... 61%

Reading package lists... 66%

Reading package lists... 66%

Reading package lists... 71%

Reading package lists... 71%

Reading package lists... 77%

Reading package lists... 77%

Reading package lists... 77%

Reading package lists... 77%

Reading package lists... 77%

Reading package lists... 77%

Reading package lists... 77%

Reading package lists... 77%

Reading package lists... 79%

Reading package lists... 79%

Reading package lists... 81%

Reading package lists... 81%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 82%

Reading package lists... 83%

Reading package lists... 83%

Reading package lists... 83%

Reading package lists... 83%

Reading package lists... 83%

Reading package lists... 83%

Reading package lists... 83%

Reading package lists... 83%

Reading package lists... 83%

Reading package lists... 83%

Reading package lists... 86%

Reading package lists... 86%

Reading package lists... 89%

Reading package lists... 90%

Reading package lists... 90%

Reading package lists... 95%

Reading package lists... 95%

Reading package lists... 95%

Reading package lists... 95%

Reading package lists... 95%

Reading package lists... 95%

Reading package lists... 95%

Reading package lists... 95%

Reading package lists... 96%

Reading package lists... 96%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 97%

Reading package lists... 98%

Reading package lists... 98%

Reading package lists... 98%

Reading package lists... 98%

Reading package lists... 98%

Reading package lists... 98%

Reading package lists... 98%

Reading package lists... 98%

Reading package lists... 98%

Reading package lists... 98%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... 99%

Reading package lists... Done

W: http://ppa.launchpad.net/couchdb/stable/ubuntu/dists/trusty/Release.gpg: Signature by key 15866BAFD9BCC4F3C1E0DFC7D69548E1C17EAB57 uses weak digest algorithm (SHA1)

travis_time:end:1162c9bc:start=1519110514790660172,finish=1519110518090861324,duration=3300201152
[0Ktravis_fold:end:before_install.1
[0Ktravis_fold:start:before_install.2
[0Ktravis_time:start:2846a7bc
[0K$ sudo apt-get install -o Dpkg::Options::="--force-confold" --force-yes -y docker-engine

Reading package lists... 0%

Reading package lists... 100%

Reading package lists... Done


Building dependency tree... 0%

Building dependency tree... 0%

Building dependency tree... 50%

Building dependency tree... 50%

Building dependency tree       


Reading state information... 0%

Reading state information... 0%

Reading state information... Done

Package docker-engine is not available, but is referred to by another package.
This may mean that the package is missing, has been obsoleted, or
is only available from another source
However the following packages replace it:
  docker-ce

E: Package 'docker-engine' has no installation candidate

travis_time:end:2846a7bc:start=1519110518096667299,finish=1519110518527723642,duration=431056343
[0K
[31;1mThe command "sudo apt-get install -o Dpkg::Options::="--force-confold" --force-yes -y docker-engine" failed and exited with 100 during .[0m

Your build has been stopped.
