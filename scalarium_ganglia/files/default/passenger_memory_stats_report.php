<?php

/* Pass in by reference! */
function graph_passenger_memory_stats_report ( &$rrdtool_graph ) {                               
                                                                                          
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
    $title = 'Passenger Memory Stats';                                                    
    if ($context != 'host') {                                                             
       $rrdtool_graph['title'] = $title;                                                  
    } else {                                                                              
       $rrdtool_graph['title'] = "$hostname $title last $range";                          
    }                                                                                     
    $rrdtool_graph['lower-limit']    = '0';                                               
    $rrdtool_graph['vertical-label'] = 'MB';                                              
    $rrdtool_graph['extras']         = '--base 1024 --rigid';                             
                                                                                          
                                                                                                 
     if ( file_exists("$rrd_dir/passenger_avg_memory.rrd")) {
       
         $series = "DEF:'passenger_avg_memory'='${rrd_dir}/passenger_avg_memory.rrd':'sum':AVERAGE "
                 ."DEF:'passenger_total_memory'='${rrd_dir}/passenger_total_memory.rrd':'sum':AVERAGE ";

         $series .="LINE2:'passenger_avg_memory'#$proc_run_color:'AVG Memory per Passenger' ";   
         $series .="LINE2:'passenger_total_memory'#$cpu_num_color:'Total Memory' ";
       
     } else {
         # If there are no Passenger metrics put something so that the report doesn't barf
         $series  = "DEF:'cpu_num'='${rrd_dir}/cpu_num.rrd':'sum':AVERAGE ";
 		     $series .= "LINE2:'cpu_num'#$mem_swapped_color:'Passenger metrics not collected' ";
       
     }
    
    $rrdtool_graph['series'] = $series;                                                                                                                                             
    return $rrdtool_graph;                                                                

}

?>
