redisio CHANGE LOG
===

1.4.2 - 
---
  - Strips leading directory from downloaded tarball, and extracts into a newly created directory.  This allows more versatility for where the package can be installed from (Github / BitBucket)

1.4.1 - Released 2/27/2013
---
  - Removes left over debugging statement

1.4.0 - Released 2/27/2013
---
  - ACTUALLY fixes the use of upstart and redis.  Redis no longer daemonizes itself when using job_control type upstart and allows upstart to handle this
  - Adds dependency on the ulimit cookbook and allows you to set the ulimits for the redis instance users.
  - Adds associated node attribute for the ulimit.  It defaults to the special value 0, which causes the cookbook to use maxclients + 32.  32 is the number of file descriptors redis needs itself
  - You can disable the use of the ulimits by setting the node attribute for it to "false" or "nil"
  - Comments out the start on by default in the upstart script.  This will get uncommented by the upstart provider when the :enable action is called on it

1.3.2 - Released 2/26/2013
---
  - Changes calls to Chef::ShellOut to Mixlib::ShellOut

1.3.1 - Released 2/26/2013
---
  - Fixes bug in upstart script to create pid directory if it does not exist

1.3.0 - Released 2/20/2013 
---
  - Adds upstart support.  This was a much requested feature. 
  - Fixes bug in uninstall resource that would have prevented it from uninstalling named servers.  
  - Reworks the init script to take into account the IP redis is listening on, and if it is listening on a socket.
  - Adds an attribute called "shutdown_save" which will explicitly call save on redis shutdown 
  - Updates the README.md with a shorter and hopefully equally as useful usage section
  - maxmemory attribute now allows the use of percentages.  You must include a % sign after the value.
  - Bumps default version of redis to install to the current stable, 2.6.10

1.2.0 - Released 2/6/2013
---
  - Fixes bug related to where the template source resides when using the LWRP outside of the redisio cookbook
  - Fixes bug where the version method was not properly parsing version strings in redis 2.6.x, as the version string from redis-server -v changed
  - Fixes bug in default attributes for fedora default redis data directory
  - Now uses chefs service resource for each redis instance instead of using a custom redisio_service resource.  This cleans up many issues, including a lack of updated_by_last_action
  - The use of the redisio_service resource is deprecated.  Use the redis<port_number> instead. 
  - The default version of redis has been bumped to the current stable, which is 2.6.9
  - Adds metadata.json to the gitignore file so that the cookbook can be submoduled.
  - Adds the ability to handle non standard bind address in the init scripts stop command
  - Adds attributes to allow redis to listen on a socket 
  - Adds an attribute to allow redis service accounts to be created as system users, defaults this to true
  - Adds a per server "name" attribute that allows a server to use that instead of the port for its configuration files, service resource, and init script.
  - Shifts the responsbility for handling the case of default redis instances into the install recipe due to the behavior of arrays and deep merge

1.1.0 - Released 8/21/2012
---
  ! Warning breaking change !: The redis pidfile directory by default has changed, if you do not STOP redis before upgrading to the new version
                               of this cookbook, it will not be able to stop your instance properly via the redis service provider, or the init script.
                               If this happens to you, you can always log into the server and manually send a SIGTERM to redis

  - Changed the init script to run redis as the specified redis user
  - Updated the default version of redis to 2.4.16
  - Setup a new directory structure for redis pid files.  The install provider will now nest its pid directories in base_piddir/<port number>/redis_<port>.pid.
  - Added a RedisioHelper module in libraries.  The recipe_eval method inside is used to wrap nested resources to allow for the proper resource update propigation.  The install provider uses this.
  - The init script now properly respects the configdir attribute
  - Changed the redis data directories to be 775 instead of 755 (this allows multiple instances with different owners to write their data to the same shared dir so long as they are in a common group)
  - Changed default for maxclients to be 10000 instead of 0.  This is to account for the fact that maxclients no longer supports 0 as 'unlimited' in the 2.6 series
  - Added logic to replace hash-max-ziplist-entries, hash-max-ziplist-value with  hash-max-zipmap-entires, hash-max-zipmap-value when using 2.6 series 
  - Added the ability to log to any file, not just syslog.  Please do make sure after you set your file with the logfile attribute you also set syslogenabled to 'no'

1.0.3 - Released 5/2/2012
---

  - Added changelog.md
  - Added a bunch more configuration options that were left out (default values left as they were before):  
      - databases
      - slaveservestaledata
      - replpingslaveperiod
      - repltimeout
      - maxmemorysamples
      - noappendfsynconwrite
      - aofrewritepercentage
      - aofrewriteminsize
      
      It is worth nothing that since there is a configurable option for conf include files, and the fact that redis uses the most recently read configuration option... even if a new option where to show up, or and old one was not included they could be added using that pattern.
      

1.0.2 - Released 4/25/2012
---

 - Merged in pull request from meskyanichi which improved the README.md and added a .gitignore
 - Added a "safe_install" node attribute which will prevent redis from installing anything if it exists already.  Defaults to true.
 - Addedd a "redis_gem" recipe which will install the redis gem from ruby gems, added associated attributes.  See README for me

1.0.1 - Released 4/8/2012
---

 - Added some prequisite checks for RHEL based distributions
 - Minor typos and formatting fixes in metadata.rb and README.md

1.0.0 - Released 4/8/2012
---

 - Initial Release
