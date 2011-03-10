<?php

/* Pass in by reference! */
function graph_nginx_status_report ( &$rrdtool_graph ) {

    global $context,
           $cpu_num_color,
           $cpu_user_color,
           $hostname,
           $load_one_color,
           $num_nodes_color,
           $proc_run_color,
           $mem_swapped_color,
           $range,
           $rrd_dir,
           $size,
           $strip_domainname;

    if ($strip_domainname) {
       $hostname = strip_domainname($hostname);
    }

    $rrdtool_graph['height'] += ($size == 'medium') ? 14 : 0;
    $title = 'Nginx Connections';
    if ($context != 'host') {
       $rrdtool_graph['title'] = $title;
    } else {
       $rrdtool_graph['title'] = "$hostname $title last $range";
    }
    $rrdtool_graph['lower-limit']    = '0';
    $rrdtool_graph['vertical-label'] = 'Connections';
    $rrdtool_graph['extras']         = '--rigid';


    if ( file_exists("$rrd_dir/nginx_active_connections.rrd")) {

      $series = "DEF:'nginx_active_connections'='${rrd_dir}/nginx_active_connections.rrd':'sum':AVERAGE ";
      $series .="DEF:'nginx_reading'='${rrd_dir}/nginx_reading.rrd':'sum':AVERAGE ";
      $series .="DEF:'nginx_writing'='${rrd_dir}/nginx_writing.rrd':'sum':AVERAGE ";
      $series .="DEF:'nginx_waiting'='${rrd_dir}/nginx_waiting.rrd':'sum':AVERAGE ";
                                                                                          
      $series .="LINE2:'nginx_active_connections'#$cpu_num_color:'Active Connections' ";  
      $series .="LINE2:'nginx_reading'#$proc_run_color:'Reading Connections' ";
      $series .="LINE2:'nginx_writing'#33FF11:'Writing Connections' ";
      $series .="LINE2:'nginx_waiting'#$load_one_color:'Waiting Connections' ";
      
    } else {
       # If there are no Nginx metrics put something so that the report doesn't barf
       $series  = "DEF:'cpu_num'='${rrd_dir}/cpu_num.rrd':'sum':AVERAGE ";
	     $series .= "LINE2:'cpu_num'#$mem_swapped_color:'Nginx metrics not collected' ";
    }

    $rrdtool_graph['series'] = $series;

    return $rrdtool_graph;

}

?>