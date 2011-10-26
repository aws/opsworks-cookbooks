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

if using < python2.5, http://code.activestate.com/recipes/523034/ works as a
pure python collections.defaultdict substitute
"""

from collections import defaultdict
import MySQLdb

def longish(x):
	if len(x):
		try:
			try:
				return long(x)
			except ValueError:
				return longish(x[:-1])
		except:
			return int(x, 16)
	else:
		raise ValueError

def parse_innodb_status(innodb_status_raw):
	def sumof(status):
		def new(*idxs):
			return sum(map(lambda x: longish(status[x]), idxs))
		#new.func_name = 'sumof'  #not ok in py2.3
		return new

	innodb_status = defaultdict(int)
	innodb_status['active_transactions']

	for line in innodb_status_raw:
		istatus = line.split()

		isum = sumof(istatus)

		# SEMAPHORES
		if "Mutex spin waits" in line:
			innodb_status['spin_waits'] += longish(istatus[3])
			innodb_status['spin_rounds'] += longish(istatus[5])
			innodb_status['os_waits'] += longish(istatus[8])

		elif "RW-shared spins" in line:
			innodb_status['spin_waits'] += isum(2,8)
			innodb_status['os_waits'] += isum(5,11)

		# TRANSACTIONS
		elif "Trx id counter" in line:
			try:
				innodb_status['transactions'] += isum(3,4)
			except:
				innodb_status['transactions'] += longish(istatus[3])

		elif "Purge done for trx" in line:
			try:
				innodb_status['transactions_purged'] += isum(6,7)
			except:
				innodb_status['transactions_purged'] += longish(istatus[6])

		elif "History list length" in line:
			innodb_status['history_list'] = longish(istatus[3])

		elif "---TRANSACTION" in line and innodb_status['transactions']:
			innodb_status['current_transactions'] += 1
			if "ACTIVE" in line:
				innodb_status['active_transactions'] += 1

		elif "LOCK WAIT" in line and innodb_status['transactions']:
			innodb_status['locked_transactions'] += 1

		elif 'read views open inside' in line:
			innodb_status['read_views'] = longish(istatus[0])

		# FILE I/O
		elif 'OS file reads' in line:
			innodb_status['data_reads'] = longish(istatus[0])
			innodb_status['data_writes'] = longish(istatus[4])
			innodb_status['data_fsyncs'] = longish(istatus[8])

		elif 'Pending normal aio' in line:
			innodb_status['pending_normal_aio_reads'] = longish(istatus[4])
			innodb_status['pending_normal_aio_writes'] = longish(istatus[7])

		elif 'ibuf aio reads' in line:
			innodb_status['pending_ibuf_aio_reads'] = longish(istatus[3])
			innodb_status['pending_aio_log_ios'] = longish(istatus[6])
			innodb_status['pending_aio_sync_ios'] = longish(istatus[9])

		elif 'Pending flushes (fsync)' in line:
			innodb_status['pending_log_flushes'] = longish(istatus[4])
			innodb_status['pending_buffer_pool_flushes'] = longish(istatus[7])

		# INSERT BUFFER AND ADAPTIVE HASH INDEX
		elif 'merged recs' in line:
			innodb_status['ibuf_inserts'] = longish(istatus[0])
			innodb_status['ibuf_merged'] = longish(istatus[2])
			innodb_status['ibuf_merges'] = longish(istatus[5])

		# LOG
		elif "log i/o's done" in line:
			innodb_status['log_writes'] = longish(istatus[0])

		elif "pending log writes" in line:
			innodb_status['pending_log_writes'] = longish(istatus[0])
			innodb_status['pending_chkp_writes'] = longish(istatus[4])
		
		elif "Log sequence number" in line:
			try:
				innodb_status['log_bytes_written'] = isum(3,4)
			except:
				innodb_status['log_bytes_written'] = longish(istatus[3])
		
		elif "Log flushed up to" in line:
			try:
				innodb_status['log_bytes_flushed'] = isum(4,5)
			except:
				innodb_status['log_bytes_flushed'] = longish(istatus[4])

		# BUFFER POOL AND MEMORY
		elif ("Buffer pool size" in line) and not ("Buffer pool size, bytes" in line):
			innodb_status['buffer_pool_pages_total'] = longish(istatus[3])
		
		elif "Free buffers" in line:
			innodb_status['buffer_pool_pages_free'] = longish(istatus[2])
		
		elif "Database pages" in line:
			innodb_status['buffer_pool_pages_data'] = longish(istatus[2])
		
		elif "Modified db pages" in line:
			innodb_status['buffer_pool_pages_dirty'] = longish(istatus[3])
		
		elif ("Pages read" in line) and not ("Pages read ahead " in line):
			innodb_status['pages_read'] = longish(istatus[2])
			innodb_status['pages_created'] = longish(istatus[4])
			innodb_status['pages_written'] = longish(istatus[6])

		# ROW OPERATIONS
		elif 'Number of rows inserted' in line:
			innodb_status['rows_inserted'] = longish(istatus[4])
			innodb_status['rows_updated'] = longish(istatus[6])
			innodb_status['rows_deleted'] = longish(istatus[8])
			innodb_status['rows_read'] = longish(istatus[10])
		
		elif "queries inside InnoDB" in line:
			innodb_status['queries_inside'] = longish(istatus[0])
			innodb_status['queries_queued'] = longish(istatus[4])

	# Some more stats
	innodb_status['transactions_unpurged'] = innodb_status['transactions'] - innodb_status['transactions_purged']
	innodb_status['log_bytes_unflushed'] = innodb_status['log_bytes_written'] - innodb_status['log_bytes_flushed']

	return innodb_status
	
if __name__ == '__main__':
	from optparse import OptionParser

	parser = OptionParser()
	parser.add_option("-H", "--Host", dest="host", help="Host running mysql", default="localhost")
	parser.add_option("-u", "--user", dest="user", help="user to connect as", default="")
	parser.add_option("-p", "--password", dest="passwd", help="password", default="")
	(options, args) = parser.parse_args()

	try:
		conn = MySQLdb.connect(user=options.user, host=options.host, passwd=options.passwd)

		cursor = conn.cursor(MySQLdb.cursors.Cursor)
		cursor.execute("SHOW /*!50000 ENGINE*/ INNODB STATUS")
		innodb_status = parse_innodb_status(cursor.fetchone()[2].split('\n'))
		cursor.close()

		conn.close()
	except MySQLdb.OperationalError, (errno, errmsg):
		raise
