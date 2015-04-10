default.elasticsearch[:logging]['action'] = 'DEBUG'
default.elasticsearch[:logging]['com.amazonaws'] = 'WARN'
default.elasticsearch[:logging]['index.search.slowlog'] = 'TRACE, index_search_slow_log_file'
default.elasticsearch[:logging]['index.indexing.slowlog'] = 'TRACE, index_indexing_slow_log_file'

# --------------------------------------------
# NOTE: Setting the attributes for logging.yml
# --------------------------------------------
#
# The template iterates over all values set in the `node.elasticsearch.logging`
# namespace and prints all settings which have been configured;
# this file only configures the minimal default set.
#
# To configure logging, simply set the corresponding attribute, eg.:
#
#     node.elasticsearch.logging['discovery'] = 'TRACE'
#
# Use the same notation for deeply nested attributes:
#
#     node.elasticsearch.logging['index.search.slowlog'] = 'DEBUG, index_search_slow_log_file'
#
