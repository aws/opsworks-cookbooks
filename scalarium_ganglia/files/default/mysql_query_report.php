<?php
/*
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
*/

function graph_mysql_query_report( &$rrdtool_graph ) {

    global $context, 
           $hostname,
           $rrd_dir,
           $size;

    $rrdtool_graph['title']  = 'MySQL Query Report';
    $rrdtool_graph['vertical-label'] = 'Queries';
    $rrdtool_graph['height']        += $size == 'medium' ? 28 : 0 ;   // Fudge to account for number of lines in the chart legend
    $rrdtool_graph['lower-limit']    = '0';
    $rrdtool_graph['extras']         = '--rigid';

	$series =
		  "DEF:'select'='${rrd_dir}/mysql_com_select.rrd':'sum':AVERAGE "
		. "DEF:'insert'='${rrd_dir}/mysql_com_insert.rrd':'sum':AVERAGE "
		. "DEF:'update'='${rrd_dir}/mysql_com_update.rrd':'sum':AVERAGE "
		. "DEF:'delete'='${rrd_dir}/mysql_com_delete.rrd':'sum':AVERAGE "
		. "LINE2:'select'#2EB800:'Selects' "
		. "LINE2:'insert'#3366FF:'Inserts' "
		. "LINE2:'update'#8A00B8:'Updates' "
		. "LINE2:'delete'#FF0000:'Deletes' ";

    $rrdtool_graph['series'] = $series;

    return $rrdtool_graph;
}

?>
