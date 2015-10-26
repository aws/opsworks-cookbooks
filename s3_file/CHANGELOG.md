2015-06-03 version 2.5.4
======================
  * Adds version constraint on rest-client to 1.7.3.
  * Adds a cookbook attribute for overwriting the rest-client gem version.

2015-03-20 version 2.5.3
========================
  * Fix deprecated digest call.
  * Merged https://github.com/adamsb6/s3_file/pull/41. README enhancements. @eherot
  * Merged https://github.com/adamsb6/s3_file/pull/43. Performance fix for rest client install. @scottymarshall

  *version 2.5.2*

  * Add retries for downloads

2014-12-09 version 2.5.1
========================
  * Merged https://github.com/adamsb6/s3_file/pull/36. Fix compatibility with Chef 12.

2014-10-01  version 2.5.0
=========================
  * Merged https://github.com/adamsb6/s3_file/pull/31.  This provides an optional s3_url value for a recipe to use S3 buckets other than US based ones.
  * Merged https://github.com/adamsb6/s3_file/pull/29.  Add ChefSpec matcher for testing.

2014-04-17  version 2.4.0
=========================
* Merged pull request https://github.com/adamsb6/s3_file/pull/25.  This provides new functionality to automatically decrypt an encrypted file uploaded to S3.

2014-03-18  version 2.3.3
=========================
* Merged pull request https://github.com/adamsb6/s3_file/pull/24.  This corrects documentation for use of X-Amz-Meta-Digest to identify md5 in multi-part uploads.

2014-02-20  version 2.3.2
=========================
* Added documentation for multi-part ETag/MD5 issue.
* Added changelog, backdated to 2014-02-14.

2014-02-14  version 2.3.1
=========================
* Merged pull request https://github.com/adamsb6/s3_file/pull/22.  This fixes an issue in which an :immediately arg to notify would trigger the notified resource before file permissions had been set.
