if 0 {
Copyright (C) 2017 Maximilian Diedrich

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.


PR magic project
Usage:
Run in vivado project directory in project mode.
Requiures vhdlExtract.jar to be in the same directory or in the PATH.
For further details regarding usage, constraints and syntax visit github.com/diedricm/prMagicVivado
}

#________________________helper functions______________________________

proc prm_get_partition_modules {partition} {
	set allmodules [get_reconfig_modules]
	set result {}
	for {set i 0} {$i < [llength $allmodules]} {incr i} {
		set currentmodule [lindex $allmodules $i]
		set currentmodulespart [get_property PARTITION_DEF $currentmodule]
		
		if {[string match $currentmodulespart $partition]} {
			lappend result $currentmodule
		}
	}
	return $result
}

#ownership: glenn jackman https://stackoverflow.com/questions/1621166/tk-tcl-exec-stderr-stdout-separately
proc prm_run_parse {params} {
	set top_entity [lindex [find_top] 0]
	set modules [get_files]
	set command "java -jar vhdlExtract.jar ${top_entity} ${modules}"
	set pipe [open "| $command" w+]
	puts $pipe $params
	flush $pipe
	set standard_output [read -nonewline $pipe]
	set exit_status 0
	if {[catch {close $pipe} standard_error] != 0} {
		global errorCode
		if {"CHILDSTATUS" == [lindex $errorCode 0]} {
			set exit_status [lindex $errorCode 2]
		}
	}
	return [list $exit_status $standard_output $standard_error]
}

#______________________remove functions______________________________

proc prm_is_partition_removed {newstate oldpartition} {
	set removed 1
	for {set i 0} {$i < [llength $newstate]} {incr i} {
		if {[string match [lindex [lindex $newstate $i] 0] $oldpartition]} {
			set removed 0
		}
	}
	return $removed
}

proc prm_is_module_removed {newstate oldmodule} {
	set oldmodulepartition [get_property PARTITION_DEF [get_reconfig_module $oldmodule]]
	set removed 1
	for {set i 0} {$i < [llength $newstate]} {incr i} {
		if {[string match [lindex [lindex $newstate $i] 0] $oldmodulepartition]} {
			set modulelist [lindex [lindex $newstate $i] 1]
			for {set j 0} {$j < [llength $modulelist]} {incr j} {
				if {[string match [lindex $modulelist $j] $oldmodule]} {
					set removed 0
				}
			}
		}
	}
	return $removed
}

proc prm_remove_unused_partitions {newstate} {
	#get old partitions
	set oldpartitions [get_partition_defs]
	set removelist {}
	
	#check if a previously defined partition is no longer needed
	for {set i 0} {$i < [llength $oldpartitions]} {incr i} {
		if {[prm_is_partition_removed $newstate [lindex $oldpartitions $i]]} {
			delete_reconfig_modules -merge sources_1 [prm_get_partition_modules [lindex $oldpartitions $i]]
			lappend removelist [lindex $oldpartitions $i]
		}
	}
	
	if {[llength $removelist] != 0} {
		delete_partition_defs $removelist
	}
}

proc prm_remove_all {} {
	#get old partitions
	set oldpartitions [get_partition_defs]
	set removelist {}
	
	#check if a previously defined partition is no longer needed
	for {set i 0} {$i < [llength $oldpartitions]} {incr i} {
		lappend removelist [lindex $oldpartitions $i]
		
		set oldmodules [prm_get_partition_modules [lindex $oldpartitions $i]]
		if {[llength $oldmodules] != 0} {
			delete_reconfig_modules -merge sources_1 $oldmodules
		}
	}
	
	if {[llength $removelist] != 0} {
		delete_partition_defs $removelist
	}
	
	set prm_configs [get_pr_configurations prm_config_*]
	if {[llength $prm_configs] != 0} {
		delete_pr_configurations $prm_configs
	}
}

proc prm_remove_unused_modules {newstate} {
	#get old modules
	set oldmodules [get_reconfig_modules]
	
	#check if a previously defined module is no longer needed
	for {set j 0} {$j < [llength $oldmodules]} {incr j} {
		if {[prm_is_module_removed $newstate [lindex $oldmodules $j]]} {
			delete_reconfig_modules -merge sources_1 [lindex $oldmodules $j]
		}
	}
}

#__________________________add functions____________________________

proc prm_update_partition {newstatepart} {
	set oldpartitions [get_partition_defs]
	set newpartition [lindex $newstatepart 0]
	set newmodules [lindex $newstatepart 1]
	set new 1
	for {set i 0} {$i < [llength $oldpartitions]} {incr i} {
		if {[string match [lindex $oldpartitions $i] $newpartition]} {
			set new 0
		}
	}
	if {$new} {
		create_partition_def -name $newpartition -module [lindex $newmodules 0]
	}
}

proc prm_update_partitions_simple {newstate} {
	for {set j 0} {$j < [llength $newstate]} {incr j} {
		set newstatepart [lindex $newstate $j]
		set newpartition [lindex $newstatepart 0]
		set newmodules [lindex $newstatepart 1]
		
		create_partition_def -name $newpartition -module [lindex $newmodules 0]
	}
}

proc prm_update_module_list {newstatepart} {
	set newpartition [lindex $newstatepart 0]
	set newmodules [lindex $newstatepart 1]
	set oldmodules [prm_get_partition_modules $newpartition]
	
	for {set i 0} {$i < [llength $newmodules]} {incr i} {
		set new 1
		for {set j 0} {$j < [llength $oldmodules]} {incr j} {
			if {[string match [lindex $newmodules $i] [lindex $oldmodules $j]]} {
				set new 0
			}
		}
		if {$new} {
			create_reconfig_module -name [lindex $newmodules $i] -partition_def $newpartition -define_from [lindex $newmodules $i]
		}
	}
}

proc prm_update_modules_simple {newstate} {
	for {set i 0} {$i < [llength $newstate]} {incr i} {
		set newstatepart [lindex $newstate $i]
		set newpartition [lindex $newstatepart 0]
		set newmodules [lindex $newstatepart 1]
		
		for {set j 0} {$j < [llength $newmodules]} {incr j} {
			create_reconfig_module -name [lindex $newmodules $j] -partition_def $newpartition -define_from [lindex $newmodules $j]
		}
	}
}

proc prm_update_modules {newstate} {
	for {set i 0} {$i < [llength $newstate]} {incr i} {
		#puts "prm_update_modules ${i}"
		#puts [lindex $newstate $i]
		prm_update_module_list [lindex $newstate $i]
	}
}

proc prm_update_partitions {newstate} {
	for {set i 0} {$i < [llength $newstate]} {incr i} {
		prm_update_partition [lindex $newstate $i]
	}
}

#______________________config functions___________________________

proc prm_is_module_configured {partition module} {
	set conflist [get_pr_configurations]
	
	set configured 0
	for {set i 0} {$i < [llength $conflist]} {incr i} {
		set tmpconf [lindex $conflist $i]
		set partlist [get_property PARTITION_CELL_RMS $tmpconf]
		for {set j 0} {$j < [llength $partlist]} {incr j} {
			set moduleparttuple [split [lindex $partlist $j] :]
			set confpartition [lindex moduleparttuple 0]
			set confmodule [lindex moduleparttuple 1]
			if {[string match $confpartition $partition] && [string match $confmodule $module]} {
				set configured 1
			}
		}
	}
	
	return $configured
}

proc prm_insert_module_in_greybox {partition module} {
	set conflist [get_pr_configurations prm_config_*]
	
	for {set i 0} {$i < [llength $conflist]} {incr i} {
		set tmpconf [lindex $conflist $i]
		set partlist [get_property PARTITION_CELL_RMS $tmpconf]
		set greybox [get_property GREYBOX_CELLS $tmpconf]
		for {set j 0} {$j < [llength $greybox]} {incr j} {
			if {[string match [lindex $greybox $j] $partition]} {
				set matchpos [lsearch $greybox $partition]
				set_property GREYBOX_CELLS [lreplace $greybox $matchpos $matchpos] $tmpconf
				set newtuple "${partition}:${module}"
				set tuplelist [concat $partlist $newtuple]
				set_property PARTITION_CELL_RMS $tuplelist $tmpconf
				return 1
			}
		}
	}
	
	return 0
}

proc prm_create_greybox_conf {newstate} {
	set partitionlist {}
	for {set i 0} {$i < [llength $newstate]} {incr i} {
		lappend partitionlist [lindex [lindex $newstate $i] 0]
	}
	
	set j 1
	while {0 != [llength [get_pr_configurations "prm_config_${j}"]]} {
		incr j
	}
	
	create_pr_configuration -name "prm_config_${j}" -greyboxes $partitionlist
}

proc prm_remove_unused_config {newstate} {
	set conflist [get_pr_configurations prm_config_*]
	for {set i 0} {$i < [llength $conflist]} {incr i} {
		set contains_partition 0
		for {set j 0} {$j < [llength $newstate]} {incr j} {
			if {![string match [lindex $newstate $j] [lindex $conflist $i]]} {
				set contains_partition 1
			}
		}
		
		if {!$contains_partition} {
			delete_pr_configurations [lindex $conflist $i]
		}
	}
}

proc prm_update_config {newstate} {
	for {set i 0} {$i < [llength $newstate]} {incr i} {
		set partmodlist [lindex $newstate $i]
		set partition [lindex $partmodlist 0]
		set modulelist [lindex $partmodlist 1]
		for {set j 0} {$j < [llength $modulelist]} {incr j} {
			set module [lindex $modulelist $j]
			if {![prm_is_module_configured $partition $module]} {
				if {![prm_insert_module_in_greybox $partition $module]} {
					prm_create_greybox_conf $newstate
					prm_insert_module_in_greybox $partition $module
				}
			}
		}
	}
	
	prm_remove_unused_config $newstate
}

#______________________run functions___________________________

proc update_runs {} {
	set conflist [get_pr_configurations prm_config_*]
	set runlist [get_runs -quiet prm_*]
	
	if {[llength $conflist] == 0} {
		set_property PR_CONFIGURATION {} [get_runs impl_1]
		return
	} else {
		set_property PR_CONFIGURATION prm_config_1 [get_runs impl_1]
	}
	
	if {[llength $runlist] != 0} {
		delete_runs $runlist
	}
	
	set flowtype [get_property FLOW [get_runs impl_1]]
	
	for {set i 2} {$i <= [llength $conflist]} {incr i} {
		create_run "prm_child_${i}_impl_1" -parent_run impl_1 -flow $flowtype -pr_config "prm_config_${i}"
	}
}

#_________________________main____________________________________

proc prm_update {newstate} {
	prm_update_partitions_simple $newstate
	prm_update_modules_simple $newstate
	prm_update_config $newstate
	update_runs
}

proc prm_main {} {
	set_property PR_FLOW 1 [get_projects]

	prm_remove_all
	
	set execsres [prm_run_parse {}]

	#print stderr if parsing failed
	if {[lindex $execsres 0] != 0} {
		puts stderr [lindex $execsres 2]
		puts stderr {\nParsing failed.\nAborting.}
		return 1
	}

	#layout: { {<partition> {<module0> ...}} ...}
	set newstate [lindex [lindex $execsres 1] 0]
	
	prm_update $newstate
}