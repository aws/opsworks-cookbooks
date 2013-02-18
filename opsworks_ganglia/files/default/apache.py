"""
The MIT License

Copyright (c) 2009 Gilad Raphaelli <gilad@raphaelli.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
"""

__version__ = '0.1.1' # 2009-01-12

import urllib
import time

descriptors = []
apache_stats = {}
last_update = 0
status_url = 'http://localhost/server-status?auto'

def update_stats():
	global apache_stats
	global last_update
	global status_url

	if time.time() - last_update < 15:
		return True
	else:
		last_update = time.time()

	try:
		stats_txt = urllib.urlopen(status_url)
	except:
		return None

	for line in stats_txt:
		(k,v) = line.split(':', 1)
		k = "apache_" + k.replace(' ', '_').lower().strip()
		apache_stats[k] = v.strip()
		if 'per' in k or 'load' in k:
			apache_stats[k] = float(apache_stats[k])

	return True

def get_stat(name):
	global apache_stats

	ret = update_stats()

	if ret:
		return apache_stats[name]
	else:
		return 0

def metric_init(params):
	global descriptors
	global status_url

	status_url = params.get('status_url', status_url)

	apache_descriptions = dict(
		busyworkers = {
			'description': "Busy Workers",
			'units': "workers",
		},
		idleworkers = {
			'description': "Idle Workers",
			'units': "workers",
		},
		uptime = {
			'description': "The time the server has been running for",
			'units': "secs",
		},
		total_accesses = {
			'description': "Total Accesses",
			'units': "accesses/sec",
			'slope': "positive",
		},
		total_kbytes = {
			'description': "Total KBs",
			'units': "kb/sec",
			'slope': "positive",
		},
		cpuload = {
			'description': "CPU Load",
			'value_type': "float",
			'units': "load",
			'format': '%.3f',
		},
		bytespersec = {
			'description': "Bytes per second",
			'value_type': "float",
			'units': "bytes/sec",
			'format': '%.3f',
		},
		bytesperreq = {
			'description': "Bytes per request",
			'value_type': "float",
			'units': "bytes/req",
			'format': '%.3f',
		},
		reqpersec = {
			'description': "Requests per second",
			'value_type': "float",
			'units': "reqs/sec",
			'format': '%.3f',
		},
	)

	for label in apache_descriptions:
		d = {
			'name': 'apache_' + label,
			'call_back': get_stat,
			'time_max': 90,
			'value_type': "uint",
			'units': "",
			'slope': "both",
			'format': '%u',
			'description': "http://httpd.apache.org/docs/2.2/mod/mod_status.html",
			'groups': 'apache',
		}

		d.update(apache_descriptions[label])

		descriptors.append(d)
			
	return descriptors

def metric_cleanup():
	pass

if __name__ == '__main__':
	from optparse import OptionParser
	parser = OptionParser()
	parser.add_option("-u", "--url", dest="url", help="status url", default="http://localhost/server-status?auto")
	parser.add_option("-b", "--gmetric-bin", dest="gmetric_bin", help="path to gmetric binary", default="/usr/bin/gmetric")
	parser.add_option("-c", "--gmond-conf", dest="gmond_conf", help="path to gmond.conf", default="/etc/ganglia/gmond.conf")
	parser.add_option("-g", "--gmetric", dest="gmetric", help="submit via gmetric", action="store_true", default=False)
	parser.add_option("-q", "--quiet", dest="quiet", action="store_true", default=False)

	(options, args) = parser.parse_args()

	descriptors = metric_init({'status_url' : options.url})

	for d in descriptors:
		v = d['call_back'](d['name'])

		if not options.quiet:
			print ' %s: %s %s [%s]' % (d['name'], v, d['units'], d['description'])

		if options.gmetric:
			cmd = "%s --conf=%s --value='%s' --units='%s' --type='%s' --name='%s' --slope='%s'" % \
				(options.gmetric_bin, options.gmond_conf, v, d['units'], d['value_type'], d['name'], d['slope'])
			os.system(cmd)
