<?php

/* Pass in by reference! */
function graph_apache_response_time_report( &$rrdtool_graph ) {

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
    $title = 'Apache Resp Times';
    if ($context != 'host') {
       $rrdtool_graph['title'] = $title;
    } else {
       $rrdtool_graph['title'] = "$hostname $title last $range";
    }
    $rrdtool_graph['lower-limit']    = '0';
    $rrdtool_graph['vertical-label'] = 'seconds';
    $rrdtool_graph['extras']         = '--rigid';


    if ( file_exists("$rrd_dir/apache_90th_dur.rrd")) {

      $series = "DEF:'apache_90th_dur'='${rrd_dir}/apache_90th_dur.rrd':'sum':AVERAGE ";
      $series .="DEF:'apache_avg_dur'='${rrd_dir}/apache_avg_dur.rrd':'sum':AVERAGE ";

      $series .="LINE2:'apache_90th_dur'#$cpu_num_color:'90th duration' ";
      $series .="LINE2:'apache_avg_dur'#$proc_run_color:'AVG duration' ";

    } else {
       # If there are no Apache metrics put something so that the report doesn't barf
       $series  = "DEF:'cpu_num'='${rrd_dir}/cpu_num.rrd':'sum':AVERAGE ";
       $series .= "LINE2:'cpu_num'#$mem_swapped_color:'Apache metrics not collected' ";
    }

    $rrdtool_graph['series'] = $series;

    return $rrdtool_graph;

}

?>