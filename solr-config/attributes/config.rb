default[:config]["staging"][:path] = "/opt/solr-5.2.1/server/"
default[:config]["staging"][:SOLR_MAX_MEM] = "20480"
default[:config]["staging"][:SOLR_MIN_MEM] = "512"


default[:config]["development"][:SOLR_MAX_MEM] = "20480"
default[:config]["development"][:SOLR_MIN_MEM] = "512"

default[:config]["production"][:SOLR_MAX_MEM] = "20480"
default[:config]["production"][:SOLR_MIN_MEM] = "512"

default[:default]["staging"][:SOLR_MAX_MEM] = "20480"
default[:default]["staging"][:SOLR_MIN_MEM] = "512"


default[:default]["development"][:SOLR_MAX_MEM] = "20480"
default[:default]["development"][:SOLR_MIN_MEM] = "512"

default[:default]["production"][:SOLR_MAX_MEM] = "20480"
default[:default]["production"][:SOLR_MIN_MEM] = "512"
