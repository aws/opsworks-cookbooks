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

function graph_apache_worker_report( &$rrdtool_graph ) {

    global $context, 
           $hostname,
           $cpu_idle_color,
           $cpu_user_color,
           $rrd_dir,
           $size;

    $rrdtool_graph['title']  = 'Apache Worker Report';
    $rrdtool_graph['vertical-label'] = 'Workers';
    $rrdtool_graph['height']        += $size == 'medium' ? 28 : 0 ;   // Fudge to account for number of lines in the chart legend
    $rrdtool_graph['lower-limit']    = '0';
    $rrdtool_graph['extras']         = '--rigid';

	$series =
		  "DEF:'idle'='${rrd_dir}/apache_idleworkers.rrd':'sum':AVERAGE "
		. "DEF:'busy'='${rrd_dir}/apache_busyworkers.rrd':'sum':AVERAGE "
		. "CDEF:'total'=idle,busy,+ "
		. "AREA:'busy'#$cpu_user_color:'Busy Workers' "
		. "STACK:'idle'#$cpu_idle_color:'Idle Workers' "
		. "LINE2:'total'#000000:'Total Workers' ";

    $rrdtool_graph['series'] = $series;

    return $rrdtool_graph;
}

?>
