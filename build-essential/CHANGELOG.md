build-essential Cookbook CHANGELOG
==================================
This file is used to list changes made in each version of the build-essential cookbook.

v2.1.3 (2014-11-18)
-------------------
* Update metadata for supported versions of OS X (10.7+) as noted from
  v2.0.0 previously (#38)
* Clarify requirement to have apt package cache updated in README. (#41)
* Fix Xcode CLI installation on OS X (#50)

v2.1.2 (2014-10-14)
-------------------
* Mac OS X 10.10 Yosemite support

v2.1.0 (2014-10-14)
-------------------
* Use fully-qualified names when installing FreeBSD package

v2.0.6 (2014-08-11)
-------------------
* Use the resource form of `remote_file` to prevent context issues

v2.0.4 (2014-06-06)
-------------------
* [COOK-4661] added patch package to _rhel recipe


v2.0.2 (2014-05-02)
-------------------
- Updated documentation about older Chef versions
- Added new SVG badges to the README
- Fix a bug where `potentially_at_compile_time` fails on non-resources

v2.0.0 (2014-03-13)
-------------------
- Updated tested harnesses to use latest ecosystem tools
- Added support for FreeBSD
- Added support for installing XCode Command Line Tools on OSX (10.7, 10.8, 10.9)
- Created a DSL method for wrapping compile_time vs runtime execution
- Install additional developement tools on some platforms
- Add nicer log and warning messages with helpful information

**Potentially Breaking Changes**

- Dropped support for OSX 10.6
- OSX no longer downloads OSX GCC and uses XCode CLI tools instead
- `build_essential` -> `build-essential` in node attributes
- `compiletime` -> `compile_time` in node attributes
- Cookbook version 2.x no longer supports Chef 10.x

v1.4.4 (2014-02-27)
-------------------
- [COOK-4245] Wrong package name used for developer tools on OS X 10.9

v1.4.2
------
### Bug
- **[COOK-3318](https://tickets.opscode.com/browse/COOK-3318)** - Use Mixlib::ShellOut instead of Chef::ShellOut

### New Feature
- **[COOK-3093](https://tickets.opscode.com/browse/COOK-3093)** - Add OmniOS support

### Improvement
- **[COOK-3024](https://tickets.opscode.com/browse/COOK-3024)** - Use newer package on SmartOS

v1.4.0
------
This version splits up the default recipe into recipes included based on the node's platform_family.

- [COOK-2505] - backport omnibus builder improvements

v1.3.4
------
- [COOK-2272] - Complete `platform_family` conversion in build-essential

v1.3.2
------
- [COOK-2069] - build-essential will install osx-gcc-installer when XCode is present

v1.3.0
------
- [COOK-1895] - support smartos

v1.2.0
------
- Add test-kitchen support (source repo only)
- [COOK-1677] - build-essential cookbook support for OpenSuse and SLES
- [COOK-1718] - build-essential cookbook metadata should include scientific
- [COOK-1768] - The apt-get update in build-essentials needs to be renamed

v1.1.2
------
- [COOK-1620] - support OS X 10.8

v1.1.0
------
- [COOK-1098] - support amazon linux
- [COOK-1149] - support Mac OS X
- [COOK-1296] - allow for compile-time installation of packages through an attribute (see README)

v1.0.2
------
- [COOK-1098] - Add Amazon Linux platform support
- [COOK-1149] - Add OS X platform support
