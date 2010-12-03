<?php

/* Pass in by reference! */
function graph_haproxy_requests_report ( &$rrdtool_graph ) {

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

    $rrdtool_graph['height'] += ($size == 'medium') ? 28 : 0;
    $title = 'HAProxy Requests';
    if ($context != 'host') {
       $rrdtool_graph['title'] = $title;
    } else {
       $rrdtool_graph['title'] = "$hostname $title last $range";
    }
    $rrdtool_graph['lower-limit']    = '0';
    $rrdtool_graph['vertical-label'] = 'Requests';
    $rrdtool_graph['extras']         = '--rigid';


    if ( file_exists("$rrd_dir/lb_total_current_sess.rrd")) {

      $series = "DEF:'haproxy_current_sessions'='${rrd_dir}/lb_total_current_sess.rrd':'sum':AVERAGE ";
      $series .="DEF:'haproxy_req_per_s'='${rrd_dir}/lb_total_req_per_s.rrd':'sum':AVERAGE ";
                                                                                          
      $series .="LINE2:'haproxy_req_per_s'#$cpu_num_color:'Requests/sec' ";  
      $series .="LINE2:'haproxy_current_sessions'#$proc_run_color:'Sessions' ";
      
    } else {
       # If there are no Passenger metrics put something so that the report doesn't barf
       $series  = "DEF:'cpu_num'='${rrd_dir}/cpu_num.rrd':'sum':AVERAGE ";
	     $series .= "LINE2:'cpu_num'#$mem_swapped_color:'HAProxy metrics not collected' ";
    }

    $rrdtool_graph['series'] = $series;

    return $rrdtool_graph;

}

?>
