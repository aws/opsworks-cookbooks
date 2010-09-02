<?php


/* Pass in by reference! */
function graph_apache_report ( &$rrdtool_graph ) {

   global $context, 
           $cpu_idle_color,
           $cpu_nice_color, 
           $cpu_system_color, 
           $cpu_user_color,
           $cpu_wio_color,
	   $mem_swapped_color,
           $hostname,
           $range,
           $rrd_dir,
           $size;

    $title = 'Apache Report';
    if ($context != 'host') {
       $rrdtool_graph['title'] = $title;
    } else {
       $rrdtool_graph['title'] = "$hostname $title last $range";

    }

    $rrdtool_graph['lower-limit']    = '0';
    $rrdtool_graph['vertical-label'] = 'req_per_sec';
    $rrdtool_graph['extras']         = '--rigid';
    $rrdtool_graph['height']        += $size == 'medium' ? 28 : 0 ;   // Fudge to account for number of lines in the chart legend
 
    if($context != "host" )
                {
                   /* If we are not in a host context, then we need to calculate the average */
                    $rrdtool_graph['series'] =
                   "DEF:'num_nodes'='${rrd_dir}/apache_200.rrd':'num':AVERAGE "
                   ."DEF:'apache_200'='${rrd_dir}/apache_200.rrd':'sum':AVERAGE "
                   ."CDEF:'capache_200'=apache_200,num_nodes,/ "
                   ."DEF:'apache_300'='${rrd_dir}/apache_300.rrd':'sum':AVERAGE "
                   ."CDEF:'capache_300'=apache_300,num_nodes,/ "
                   ."DEF:'apache_400'='${rrd_dir}/apache_400.rrd':'sum':AVERAGE "
                   ."CDEF:'capache_400'=apache_400,num_nodes,/ "
                   ."DEF:'apache_500'='${rrd_dir}/apache_500.rrd':'sum':AVERAGE "
                   ."CDEF:'capache_500'=apache_500,num_nodes,/ "
                   ."AREA:'apache_200'#$cpu_user_color:'200' "
                   ."STACK:'apache_300'#$cpu_nice_color:'300' "
                   ."STACK:'apache_400'#$cpu_system_color:'400' "
                   ."STACK:'apache_500'#$cpu_wio_color:'500' ";

                }
     else
                {
                    $rrdtool_graph['series'] ="DEF:'apache_200'='${rrd_dir}/apache_200.rrd':'sum':AVERAGE "
                   ."DEF:'apache_300'='${rrd_dir}/apache_300.rrd':'sum':AVERAGE "
                   ."DEF:'apache_400'='${rrd_dir}/apache_400.rrd':'sum':AVERAGE "
                   ."DEF:'apache_500'='${rrd_dir}/apache_500.rrd':'sum':AVERAGE "
                   ."AREA:'apache_200'#$cpu_user_color:'200' "
                   ."STACK:'apache_300'#$cpu_nice_color:'300' "
                   ."STACK:'apache_400'#$cpu_system_color:'400' "
                   ."STACK:'apache_500'#$cpu_wio_color:'500' ";
                }

     #################################################################################
     # If there are no Apache metrics put something so that the report doesn't barf
     # I am using the CPU number metric since that one should always be there.
     #################################################################################
     if ( !file_exists("$rrd_dir/apache_200.rrd")) {
		$rrdtool_graph['series'] =  "DEF:'cpu_num'='${rrd_dir}/cpu_num.rrd':'sum':AVERAGE "
		   ."LINE2:'cpu_num'#$mem_swapped_color:'Apache metrics not collected' ";
     }

return $rrdtool_graph;
}


?>