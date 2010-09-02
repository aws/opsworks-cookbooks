<?php

/* Pass in by reference! */
function graph_passenger_status_report ( &$rrdtool_graph ) {

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
    $title = 'Passenger Processes';
    if ($context != 'host') {
       $rrdtool_graph['title'] = $title;
    } else {
       $rrdtool_graph['title'] = "$hostname $title last $range";
    }
    $rrdtool_graph['lower-limit']    = '0';
    $rrdtool_graph['vertical-label'] = 'Processes';
    $rrdtool_graph['extras']         = '--rigid';


    if ( file_exists("$rrd_dir/passenger_avg_memory.rrd")) {

      $series = "DEF:'passenger_max_processes'='${rrd_dir}/passenger_max_processes.rrd':'sum':AVERAGE ";
      $series .="DEF:'passenger_current_processes'='${rrd_dir}/passenger_current_processes.rrd':'sum':AVERAGE ";
      $series .="DEF:'passenger_active_processes'='${rrd_dir}/passenger_active_processes.rrd':'sum':AVERAGE ";
      $series .="DEF:'passenger_inactive_processes'='${rrd_dir}/passenger_inactive_processes.rrd':'sum':AVERAGE ";
      $series .="DEF:'passenger_waiting_processes'='${rrd_dir}/passenger_waiting_processes.rrd':'sum':AVERAGE ";
      $series .="DEF:'passenger_sessions'='${rrd_dir}/passenger_sessions.rrd':'sum':AVERAGE ";
                                                                                          
      $series .="LINE2:'passenger_max_processes'#$cpu_num_color:'Max Passenger Processes' ";  
      $series .="LINE2:'passenger_current_processes'#$proc_run_color:'Current' ";
      $series .="LINE2:'passenger_active_processes'#33FF11:'Active' ";
      $series .="LINE2:'passenger_inactive_processes'#$load_one_color:'Inactive' ";
      $series .="LINE2:'passenger_waiting_processes'#FF7700:'Waiting' ";
      $series .="LINE2:'passenger_sessions'#FF00FF:'Sessions' ";
      
    } else {
       # If there are no Passenger metrics put something so that the report doesn't barf
       $series  = "DEF:'cpu_num'='${rrd_dir}/cpu_num.rrd':'sum':AVERAGE ";
	     $series .= "LINE2:'cpu_num'#$mem_swapped_color:'Passenger metrics not collected' ";
    }

    $rrdtool_graph['series'] = $series;

    return $rrdtool_graph;

}

?>
