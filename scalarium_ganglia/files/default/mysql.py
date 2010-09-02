"""
The MIT License

Copyright (c) 2008 Gilad Raphaelli <gilad@raphaelli.com>

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

__version__ = '0.1.2' # 2009-01-12

import sys
import time
import MySQLdb

from DBUtil import parse_innodb_status

import logging
logging.basicConfig(level=logging.ERROR, format="%(asctime)s - %(name)s - %(levelname)s - Thread-%(thread)d - %(message)s", filename='/tmp/mylog', filemode='w')
logging.warning('starting up')

last_update = 0
mysql_conn_opts = {}
mysql_stats = {}

REPORT_INNODB = True
REPORT_MASTER = True
REPORT_SLAVE  = True

def update_stats(get_innodb=True, get_master=True, get_slave=True):
	logging.warning('updating stats')
	global last_update
	global mysql_stats

	if time.time() - last_update < 15:
		return True
	else:
		last_update = time.time()

	logging.warning('refreshing stats')
	mysql_stats = {}

	# Get info from DB
	try:
		conn = MySQLdb.connect(**mysql_conn_opts)

		cursor = conn.cursor(MySQLdb.cursors.DictCursor)
		cursor.execute("SELECT GET_LOCK('gmetric-mysql', 0) as ok")
		lock_stat = cursor.fetchone()
		cursor.close()

		if lock_stat['ok'] == 0:
			return False

		cursor = conn.cursor(MySQLdb.cursors.Cursor)
		cursor.execute("SHOW VARIABLES")
		#variables = dict(((k.lower(), v) for (k,v) in cursor))
		variables = {}
		for (k,v) in cursor:
			variables[k.lower()] = v
		cursor.close()

		cursor = conn.cursor(MySQLdb.cursors.Cursor)
		cursor.execute("SHOW /*!50002 GLOBAL */ STATUS")
		#global_status = dict(((k.lower(), v) for (k,v) in cursor))
		global_status = {}
		for (k,v) in cursor:
			global_status[k.lower()] = v
		cursor.close()

		# try not to fail ?
		get_innodb = get_innodb and variables['have_innodb'].lower() == 'yes'
		get_master = get_master and variables['log_bin'].lower() == 'on'

		if get_innodb:
			cursor = conn.cursor(MySQLdb.cursors.Cursor)
			cursor.execute("SHOW /*!50000 ENGINE*/ INNODB STATUS")
			innodb_status = parse_innodb_status(cursor.fetchone()[2].split('\n'))
			cursor.close()

		if get_master:
			cursor = conn.cursor(MySQLdb.cursors.Cursor)
			cursor.execute("SHOW MASTER LOGS")
			master_logs = cursor.fetchall()
			cursor.close()

		if get_slave:
			cursor = conn.cursor(MySQLdb.cursors.DictCursor)
			cursor.execute("SHOW SLAVE STATUS")
			slave_status = {}
			res = cursor.fetchone()
			if res:
				for (k,v) in res.items():
					slave_status[k.lower()] = v
			else:
				get_slave = False
			cursor.close()

		cursor = conn.cursor(MySQLdb.cursors.DictCursor)
		cursor.execute("SELECT RELEASE_LOCK('gmetric-mysql') as ok")
		cursor.close()

		conn.close()
	except MySQLdb.OperationalError, (errno, errmsg):
		logging.warning('error refreshing stats')
		return False

	logging.warning('success refreshing stats')
	# process variables
	# http://dev.mysql.com/doc/refman/5.0/en/server-system-variables.html
	mysql_stats['version'] = variables['version']

	# process global status
	# http://dev.mysql.com/doc/refman/5.0/en/server-status-variables.html
	interesting_global_status_vars = (
		'aborted_clients',
		'aborted_connects',
		'binlog_cache_disk_use',
		'binlog_cache_use',
		'bytes_received',
		'bytes_sent',
		'com_delete',
		'com_delete_multi',
		'com_insert',
		'com_insert_select',
		'com_load',
		'com_replace',
		'com_replace_select',
		'com_select',
		'com_update',
		'com_update_multi',
		'connections',
		'created_tmp_disk_tables',
		'created_tmp_files',
		'created_tmp_tables',
		'key_reads',
		'key_read_requests',
		'key_writes',
		'key_write_requests',
		'max_used_connections',
		'open_files',
		'open_tables',
		'opened_tables',
		'qcache_free_blocks',
		'qcache_free_memory',
		'qcache_hits',
		'qcache_inserts',
		'qcache_lowmem_prunes',
		'qcache_not_cached',
		'qcache_queries_in_cache',
		'qcache_total_blocks',
		'questions',
		'select_full_join',
		'select_full_range_join',
		'select_range',
		'select_range_check',
		'select_scan',
		'slave_open_temp_tables',
		'slave_retried_transactions',
		'slow_launch_threads',
		'slow_queries',
		'sort_range',
		'sort_rows',
		'sort_scan',
		'table_locks_immediate',
		'table_locks_waited',
		'threads_cached',
		'threads_connected',
		'threads_created',
		'threads_running',
		'uptime',
	)

	# don't put all of global_status in mysql_stats b/c it's so big
	for key in interesting_global_status_vars:
		mysql_stats[key] = global_status[key]

	mysql_stats['open_files_used'] = int(global_status['open_files']) / int(variables['open_files_limit'])

	# process innodb status
	if get_innodb:
		for istat in innodb_status:
			mysql_stats['innodb_' + istat] = innodb_status[istat]

	# process master logs
	if get_master:
		mysql_stats['binlog_count'] = len(master_logs)
		mysql_stats['binlog_space_current'] = master_logs[-1][1]
		#mysql_stats['binlog_space_total'] = sum((long(s[1]) for s in master_logs))
		mysql_stats['binlog_space_total'] = 0
		for s in master_logs:
			mysql_stats['binlog_space_total'] += int(s[1])
		mysql_stats['binlog_space_used'] = float(master_logs[-1][1]) / float(variables['max_binlog_size']) * 100

	# process slave status
	if get_slave:
		mysql_stats['slave_exec_master_log_pos'] = slave_status['exec_master_log_pos']
		#mysql_stats['slave_io'] = 1 if slave_status['slave_io_running'].lower() == "yes" else 0
		if slave_status['slave_io_running'].lower() == "yes":
			mysql_stats['slave_io'] = 1
		else:
			mysql_stats['slave_io'] = 0
		#mysql_stats['slave_sql'] = 1 if slave_status['slave_sql_running'].lower() =="yes" else 0
		if slave_status['slave_sql_running'].lower() == "yes":
			mysql_stats['slave_sql'] = 1
		else:
			mysql_stats['slave_sql'] = 0
		mysql_stats['slave_lag'] = slave_status['seconds_behind_master']
		mysql_stats['slave_relay_log_pos'] = slave_status['relay_log_pos']
		mysql_stats['slave_relay_log_space'] = slave_status['relay_log_space']

def get_stat(name):
	logging.info("getting stat: %s" % name)
	global mysql_stats
	logging.warning(mysql_stats)

	global REPORT_INNODB
	global REPORT_MASTER
	global REPORT_SLAVE

	ret = update_stats(REPORT_INNODB, REPORT_MASTER, REPORT_SLAVE)

	if ret:
		if name.startswith('mysql_'):
			label = name[6:]
		else:
			label = name

		logging.warning("fetching %s" % name)
		try:
			return mysql_stats[label]
		except:
			logging.warning("failed to fetch %s" % name)
			return 0
	else:
		return 0

def metric_init(params):
	global descriptors
	global mysql_conn_opts
	global mysql_stats

	global REPORT_INNODB
	global REPORT_MASTER
	global REPORT_SLAVE

	REPORT_INNODB = str(params.get('get_innodb', True)) == "True"
	REPORT_MASTER = str(params.get('get_master', True)) == "True"
	REPORT_SLAVE  = str(params.get('get_slave', True)) == "True"

	logging.warning("init: " + str(params))

	mysql_conn_opts = dict(
		host = params.get('host', 'localhost'),
		user = params.get('user'),
		passwd = params.get('passwd'),
		port = params.get('port', 3306),
		connect_timeout = params.get('timeout', 30),
	)

	master_stats_descriptions = {}
	innodb_stats_descriptions = {}
	slave_stats_descriptions  = {}

	misc_stats_descriptions = dict(
		aborted_clients = {
			'description': 'The number of connections that were aborted because the client died without closing the connection properly',
			'units': 'clients',
		}, 

		aborted_connects = {
			'description': 'The number of failed attempts to connect to the MySQL server',
			'units': 'conns',
		}, 

		binlog_cache_disk_use = {
			'description': 'The number of transactions that used the temporary binary log cache but that exceeded the value of binlog_cache_size and used a temporary file to store statements from the transaction',
			'units': 'txns',
		}, 

		binlog_cache_use = {
			'description': ' The number of transactions that used the temporary binary log cache',
			'units': 'txns',
		}, 

		bytes_received = {
			'description': 'The number of bytes received from all clients',
			'units': 'bytes',
		}, 

		bytes_sent = {
			'description': ' The number of bytes sent to all clients',
			'units': 'bytes',
		}, 

		com_delete = {
			'description': 'The number of DELETE statements',
			'units': 'stmts',
		}, 

		com_delete_multi = {
			'description': 'The number of multi-table DELETE statements',
			'units': 'stmts',
		}, 

		com_insert = {
			'description': 'The number of INSERT statements',
			'units': 'stmts',
		}, 

		com_insert_select = {
			'description': 'The number of INSERT ... SELECT statements',
			'units': 'stmts',
		}, 

		com_load = {
			'description': 'The number of LOAD statements',
			'units': 'stmts',
		}, 

		com_replace = {
			'description': 'The number of REPLACE statements',
			'units': 'stmts',
		}, 

		com_replace_select = {
			'description': 'The number of REPLACE ... SELECT statements',
			'units': 'stmts',
		}, 

		com_select = {
			'description': 'The number of SELECT statements',
			'units': 'stmts',
		}, 

		com_update = {
			'description': 'The number of UPDATE statements',
			'units': 'stmts',
		}, 

		com_update_multi = {
			'description': 'The number of multi-table UPDATE statements',
			'units': 'stmts',
		}, 

		connections = {
			'description': 'The number of connection attempts (successful or not) to the MySQL server',
			'units': 'conns',
		}, 

		created_tmp_disk_tables = {
			'description': 'The number of temporary tables on disk created automatically by the server while executing statements',
			'units': 'tables',
		}, 

		created_tmp_files = {
			'description': 'The number of temporary files mysqld has created',
			'units': 'files',
		}, 

		created_tmp_tables = {
			'description': 'The number of in-memory temporary tables created automatically by the server while executing statement',
			'units': 'tables',
		}, 

		#TODO in graphs: key_read_cache_miss_rate = key_reads / key_read_requests

		key_read_requests = {
			'description': 'The number of requests to read a key block from the cache',
			'units': 'reqs',
		}, 

		key_reads = {
			'description': 'The number of physical reads of a key block from disk',
			'units': 'reads',
		}, 

		key_write_requests = {
			'description': 'The number of requests to write a key block to the cache',
			'units': 'reqs',
		}, 

		key_writes = {
			'description': 'The number of physical writes of a key block to disk',
			'units': 'writes',
		}, 

		max_used_connections = {
			'description': 'The maximum number of connections that have been in use simultaneously since the server started',
			'units': 'conns',
			'slope': 'both',
		}, 

		open_files = {
			'description': 'The number of files that are open',
			'units': 'files',
			'slope': 'both',
		}, 

		open_tables = {
			'description': 'The number of tables that are open',
			'units': 'tables',
			'slope': 'both',
		}, 

		# If Opened_tables is big, your table_cache value is probably too small. 
		opened_tables = {
			'description': 'The number of tables that have been opened',
			'units': 'tables',
		}, 

		qcache_free_blocks = {
			'description': 'The number of free memory blocks in the query cache',
			'units': 'blocks',
			'slope': 'both',
		}, 

		qcache_free_memory = {
			'description': 'The amount of free memory for the query cache',
			'units': 'bytes',
			'slope': 'both',
		}, 

		qcache_hits = {
			'description': 'The number of query cache hits',
			'units': 'hits',
		}, 

		qcache_inserts = {
			'description': 'The number of queries added to the query cache',
			'units': 'queries',
		}, 

		qcache_lowmem_prunes = {
			'description': 'The number of queries that were deleted from the query cache because of low memory',
			'units': 'queries',
		}, 

		qcache_not_cached = {
			'description': 'The number of non-cached queries (not cacheable, or not cached due to the query_cache_type setting)',
			'units': 'queries',
		}, 

		qcache_queries_in_cache = {
			'description': 'The number of queries registered in the query cache',
			'units': 'queries',
		}, 

		qcache_total_blocks = {
			'description': 'The total number of blocks in the query cache',
			'units': 'blocks',
		}, 

		questions = {
			'description': 'The number of statements that clients have sent to the server',
			'units': 'stmts',
		}, 

		# If this value is not 0, you should carefully check the indexes of your tables.
		select_full_join = {
			'description': 'The number of joins that perform table scans because they do not use indexes',
			'units': 'joins',
		}, 

		select_full_range_join = {
			'description': 'The number of joins that used a range search on a reference table',
			'units': 'joins',
		}, 

		select_range = {
			'description': 'The number of joins that used ranges on the first table',
			'units': 'joins',
		}, 

		# If this is not 0, you should carefully check the indexes of your tables.
		select_range_check = {
			'description': 'The number of joins without keys that check for key usage after each row',
			'units': 'joins',
		}, 

		select_scan = {
			'description': 'The number of joins that did a full scan of the first table',
			'units': 'joins',
		}, 

		slave_open_temp_tables = {
			'description': 'The number of temporary tables that the slave SQL thread currently has open',
			'units': 'tables',
			'slope': 'both',
		}, 

		slave_retried_transactions = {
			'description': 'The total number of times since startup that the replication slave SQL thread has retried transactions',
			'units': 'count',
		}, 

		slow_launch_threads = {
			'description': 'The number of threads that have taken more than slow_launch_time seconds to create',
			'units': 'threads',
		}, 

		slow_queries = {
			'description': 'The number of queries that have taken more than long_query_time seconds',
			'units': 'queries',
		}, 

		sort_range = {
			'description': 'The number of sorts that were done using ranges',
			'units': 'sorts',
		}, 

		sort_rows = {
			'description': 'The number of sorted rows',
			'units': 'rows',
		}, 

		sort_scan = {
			'description': 'The number of sorts that were done by scanning the table',
			'units': 'sorts',
		}, 

		table_locks_immediate = {
			'description': 'The number of times that a request for a table lock could be granted immediately',
			'units': 'count',
		}, 

		# If this is high and you have performance problems, you should first optimize your queries, and then either split your table or tables or use replication.
		table_locks_waited = {
			'description': 'The number of times that a request for a table lock could not be granted immediately and a wait was needed',
			'units': 'count',
		}, 

		threads_cached = {
			'description': 'The number of threads in the thread cache',
			'units': 'threads',
			'slope': 'both',
		}, 

		threads_connected = {
			'description': 'The number of currently open connections',
			'units': 'threads',
			'slope': 'both',
		}, 

		#TODO in graphs: The cache miss rate can be calculated as Threads_created/Connections

		# Threads_created is big, you may want to increase the thread_cache_size value. 
		threads_created = {
			'description': 'The number of threads created to handle connections',
			'units': 'threads',
		}, 

		threads_running = {
			'description': 'The number of threads that are not sleeping',
			'units': 'threads',
			'slope': 'both',
		}, 

		uptime = {
			'description': 'The number of seconds that the server has been up',
			'units': 'secs',
			'slope': 'both',
		}, 

		version = {
			'description': "MySQL Version",
			'value_type': 'string',
		},
	)

	if REPORT_MASTER:
		master_stats_descriptions = dict(
			binlog_count = {
				'description': "Number of binary logs",
				'units': 'logs',
				'slope': 'both',
			},

			binlog_space_current = {
				'description': "Size of current binary log",
				'units': 'bytes',
				'slope': 'both',
			},

			binlog_space_total = {
				'description': "Total space used by binary logs",
				'units': 'bytes',
				'slope': 'both',
			},

			binlog_space_used = {
				'description': "Current binary log size / max_binlog_size",
				'value_type': 'float',
				'units': 'percent',
				'slope': 'both',
			},
		)

	if REPORT_SLAVE:
		slave_stats_descriptions = dict(
			slave_exec_master_log_pos = {
				'description': "The position of the last event executed by the SQL thread from the master's binary log",
				'units': 'bytes',
				'slope': 'both',
			},

			slave_io = {
				'description': "Whether the I/O thread is started and has connected successfully to the master",
				'value_type': 'uint8',
				'units': 'True/False',
				'slope': 'both',
			},

			slave_lag = {
				'description': "Replication Lag",
				'units': 'secs',
				'slope': 'both',
			},

			slave_relay_log_pos = {
				'description': "The position up to which the SQL thread has read and executed in the current relay log",
				'units': 'bytes',
				'slope': 'both',
			},

			slave_sql = {
				'description': "Slave SQL Running",
				'value_type': 'uint8',
				'units': 'True/False',
				'slope': 'both',
			},
		)

	if REPORT_INNODB:
		innodb_stats_descriptions = dict(
			innodb_active_transactions = {
				'description': "Active InnoDB transactions",
				'value_type':'uint',
				'units': 'txns',
				'slope': 'both',
			},

			innodb_current_transactions = {
				'description': "Current InnoDB transactions",
				'value_type':'uint',
				'units': 'txns',
				'slope': 'both',
			},

			innodb_buffer_pool_pages_data = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'pages',
			},

			innodb_data_fsyncs = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'fsyncs',
			},

			innodb_data_reads = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'reads',
			},

			innodb_data_writes = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'writes',
			},

			innodb_buffer_pool_pages_free = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'pages',
				'slope': 'both',
			},

			innodb_history_list = {
				'description': "InnoDB",
				'units': 'length',
				'slope': 'both',
			},

			innodb_ibuf_inserts = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'inserts',
			},

			innodb_ibuf_merged = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'recs',
			},

			innodb_ibuf_merges = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'merges',
			},

			innodb_log_bytes_flushed = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'bytes',
			},

			innodb_log_bytes_unflushed = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'bytes',
				'slope': 'both',
			},

			innodb_log_bytes_written = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'bytes',
			},

			innodb_log_writes = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'writes',
			},

			innodb_buffer_pool_pages_dirty = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'pages',
				'slope': 'both',
			},

			innodb_os_waits = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'waits',
			},

			innodb_pages_created = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'pages',
			},

			innodb_pages_read = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'pages',
			},

			innodb_pages_written = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'pages',
			},

			innodb_pending_aio_log_ios = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'ops',
			},

			innodb_pending_aio_sync_ios = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'ops',
			},

			innodb_pending_buffer_pool_flushes = {
				'description': "The number of pending buffer pool page-flush requests",
				'value_type':'uint',
				'units': 'reqs',
				'slope': 'both',
			},

			innodb_pending_chkp_writes = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'writes',
			},

			innodb_pending_ibuf_aio_reads = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'reads',
			},

			innodb_pending_log_flushes = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'reqs',
			},

			innodb_pending_log_writes = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'writes',
			},

			innodb_pending_normal_aio_reads = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'reads',
			},

			innodb_pending_normal_aio_writes = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'writes',
			},

			innodb_buffer_pool_pages_total = {
				'description': "The total size of buffer pool, in pages",
				'value_type':'uint',
				'units': 'pages',
				'slope': 'both',
			},

			innodb_queries_inside = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'queries',
			},

			innodb_queries_queued = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'queries',
				'slope': 'both',
			},

			innodb_read_views = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'views',
			},

			innodb_rows_deleted = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'rows',
			},

			innodb_rows_inserted = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'rows',
			},

			innodb_rows_read = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'rows',
			},

			innodb_rows_updated = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'rows',
			},

			innodb_spin_rounds = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'spins',
				'slope': 'both',
			},

			innodb_spin_waits = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'spins',
				'slope': 'both',
			},

			innodb_transactions = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'txns',
			},

			innodb_transactions_purged = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'txns',
			},

			innodb_transactions_unpurged = {
				'description': "InnoDB",
				'value_type':'uint',
				'units': 'txns',
			},
		)

	descriptors = []

	update_stats(REPORT_INNODB, REPORT_MASTER, REPORT_SLAVE)

	for stats_descriptions in (innodb_stats_descriptions, master_stats_descriptions, misc_stats_descriptions, slave_stats_descriptions):
		for label in stats_descriptions:
			if mysql_stats.has_key(label):

				d = {
					'name': 'mysql_' + label,
					'call_back': get_stat,
					'time_max': 90,
					'value_type': "uint",
					'units': "",
					'slope': "positive",
					'format': '%u',
					'description': "http://search.mysql.com/search?q=" + label,
					'groups': 'mysql',
				}

				d.update(stats_descriptions[label])

				descriptors.append(d)

			else:
				logging.error("skipped " + label)

	logging.warning(str(descriptors))
	return descriptors

def metric_cleanup():
	logging.shutdown()
	# pass

if __name__ == '__main__':
	from optparse import OptionParser
	import os

	logging.warning('running from cmd line')
	parser = OptionParser()
	parser.add_option("-H", "--Host", dest="host", help="Host running mysql", default="localhost")
	parser.add_option("-u", "--user", dest="user", help="user to connect as", default="")
	parser.add_option("-p", "--password", dest="passwd", help="password", default="")
	parser.add_option("-P", "--port", dest="port", help="port", default=3306, type="int")
	parser.add_option("--no-innodb", dest="get_innodb", action="store_false", default=True)
	parser.add_option("--no-master", dest="get_master", action="store_false", default=True)
	parser.add_option("--no-slave", dest="get_slave", action="store_false", default=True)
	parser.add_option("-b", "--gmetric-bin", dest="gmetric_bin", help="path to gmetric binary", default="/usr/bin/gmetric")
	parser.add_option("-c", "--gmond-conf", dest="gmond_conf", help="path to gmond.conf", default="/etc/ganglia/gmond.conf")
	parser.add_option("-g", "--gmetric", dest="gmetric", help="submit via gmetric", action="store_true", default=False)
	parser.add_option("-q", "--quiet", dest="quiet", action="store_true", default=False)

	(options, args) = parser.parse_args()

	metric_init({
		'host': options.host,
		'passwd': options.passwd,
		'user': options.user,
		'port': options.port,
		'get_innodb': options.get_innodb,
		'get_master': options.get_master,
		'get_slave': options.get_slave,
	})

	for d in descriptors:
		v = d['call_back'](d['name'])
		if not options.quiet:
			print ' %s: %s %s [%s]' % (d['name'], v, d['units'], d['description'])

		if options.gmetric:
			cmd = "%s --conf=%s --value='%s' --units='%s' --type='%s' --name='%s' --slope='%s'" % \
				(options.gmetric_bin, options.gmond_conf, v, d['units'], d['value_type'], d['name'], d['slope'])
			os.system(cmd)
