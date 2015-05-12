default[:search][:staging][:core_name] = "search"
default[:search][:staging][:deltaImportQuery] = ""
default[:search][:staging][:deltaQuery] = ""
default[:search][:staging][:url] = "jdbc:mysql://dev.virtualshelf.net/estantevirtual"
default[:search][:staging][:user] = "ev-search"
default[:search][:staging][:query] = "SELECT  c.rec_id, c.user_id, c.autor, c.titulo, c.idioma, LTRIM_JUNK(lower(c.editora), 1,1,1,1) editora, c.descr, c.capa, c.tipo, c.estado estado_livro, c.capa, c.peso, c.peso_est, c.preco, DATEDIFF(NOW(), c.data_reg) reg_dias_atras, UNIX_TIMESTAMP(c.data_reg) data_reg, u.estado, LTRIM_JUNK(lower(u.cidade), 1, 1, 1) cidade, c.estante, c.ano, u.nomeabrev, u.username, u.ativo usuario_ativo, c.ativo catalogo_ativo, bc.idioma titulo_idioma, cdna.preco_externo preco_externo, cdna.capa_dna capa_dna, br.dna_nvends_ativos FROM catalogo c INNER JOIN usuarios u ON (u.user_id = c.user_id) LEFT JOIN catalogo_dna_nova2 cdna ON ( c.rec_id = cdna.rec_id ) LEFT JOIN booktree_20150407.booktree_radicais br on (cdna.dna_crc = br.radical_crc ) LEFT JOIN booktree_20150407.booktree_crawl bc on (br.radical_id = bc.radical_id ) WHERE c.ativo IN (1,11) AND u.ativo IN (1,11) limit 5000"

default[:search][:staging][:deltaImportQuery] = "SELECT  c.rec_id, c.user_id, c.autor, c.titulo, c.idioma, LTRIM_JUNK(lower(c.editora), 1,1,1,1) editora, c.descr, c.capa, c.tipo, c.estado estado_livro, c.capa, c.peso, c.peso_est, c.preco, DATEDIFF(NOW(), c.data_reg) reg_dias_atras, UNIX_TIMESTAMP(c.data_reg) data_reg, u.estado, LTRIM_JUNK(lower(u.cidade), 1, 1, 1) cidade, c.estante, c.ano, u.nomeabrev, u.username, u.ativo usuario_ativo, c.ativo catalogo_ativo, bc.idioma titulo_idioma, cdna.preco_externo preco_externo, cdna.capa_dna capa_dna, br.dna_nvends_ativos FROM catalogo c INNER JOIN usuarios u ON (u.user_id = c.user_id) LEFT JOIN catalogo_dna_nova2 cdna ON ( c.rec_id = cdna.rec_id ) LEFT JOIN booktree_20150407.booktree_radicais br on (cdna.dna_crc = br.radical_crc ) LEFT JOIN booktree_20150407.booktree_crawl bc on (br.radical_id = bc.radical_id ) WHERE c.ativo IN (1,11) AND u.ativo IN (1,11) AND ( c.data_reg &gt; '${dih.last_index_time}' or c.data_alt &gt; '${dih.last_index_time}' ) limit 5000"

default[:search][:staging][:deltaQuery] = "select c.rec_id FROM catalogo c INNER JOIN usuarios u ON (u.user_id = c.user_id) LEFT JOIN catalogo_dna_nova2 cdna ON ( c.rec_id = cdna.rec_id ) LEFT JOIN booktree_20150407.booktree_radicais br on (cdna.dna_crc = br.radical_crc ) LEFT JOIN booktree_20150407.booktree_crawl bc on (br.radical_id = bc.radical_id ) WHERE c.ativo IN (1,11) AND u.ativo IN (1,11) AND ( c.data_reg &gt; '${dih.last_index_time}' or c.data_alt &gt; '${dih.last_index_time}' ) limit 5000"


default[:search][:staging][:password] = "123mudar"
default[:search][:staging][:drive] = "com.mysql.jdbc.Driver"

default[:search][:production][:core_name] = "search"
default[:search][:production][:deltaImportQuery] = ""
default[:search][:production][:deltaQuery] = ""
default[:search][:production][:url] = "jdbc:mysql://dev.virtualshelf.net/estantevirtual"
default[:search][:production][:user] = "ev-search"
default[:search][:production][:query] = "select autor, titulo, editora, ano, data_reg, rec_id as id, user_id, preco, descr, tipo, estado from catalogo limit 1000;"
default[:search][:production][:password] = "123mudar"
default[:search][:production][:drive] = "com.mysql.jdbc.Driver"
