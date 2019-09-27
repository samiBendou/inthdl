#
##
##
set command_log_file		"./synth/command.log"
set view_command_log_file	"./synth/view_command.log"
set designer  			"SAMI DAHOUX"
set company  			"ensmse cmp-gc"

##
##
#/* Owner: austriamicrosystems AG  HIT-Kit: Digital */
set AMS_DIR "/soft/AMS_400_CDS"
set SYNOPSYS "/soft/SYNOPSYS/INSTALL/synthesis"
set search_path	 [list "." "$AMS_DIR/synopsys/c35_3.3V" "$SYNOPSYS/libraries/syn" "$SYNOPSYS/dw/sim_ver"]

set symbol_library [list c35_CORELIB.sdb c35_IOLIB_4M.sdb c35_IOLIBV5_4M.sdb]
set target_library [list c35_CORELIB.db c35_IOLIB_4M.db c35_IOLIBV5_4M.db]


set synthetic_library [list standard.sldb dw_foundation.sldb dft_lbist.sldb dft_mbist.sldb]
set link_library [concat "*" $target_library $synthetic_library]

#definition des chemins pour bibliotheque de compilation a la sytnthese

define_design_lib lib_synth -path ./synth/lib/lib_synth
define_design_lib lib_rtl -path ./synth/lib/lib_rtl

set verilogout_equation	 		"false"
set verilogout_no_tri	 		"true" 
set write_name_nets_same_as_ports	"true"
set verilogout_single_bit		"false"
set hdlout_internal_busses		"true"
#set bus_inference_style			"%s[%d]"
set sdfout_no_edge			"true"
echo "Please use: set_fix_multiple_port_nets -all"
set high_fanout_net_threshold "6000"


#if not aldready defined
set PROJECT_ROOT ".."
set SYNTH_DIR "$PROJECT_ROOT/synth"
set RTL_DIR "$PROJECT_ROOT/src/rtl"
set GATES_DIR "$PROJECT_ROOT/src/gates"
set TOP_NAME "full_adder"
#set clock_name "clock_i"

#liste des fichiers � analyser dans l'ordre


set rtl_list [ list \
		   $RTL_DIR/half_adder.vhd\
		   $RTL_DIR/full_adder.vhd\
		  ]
#analyse des fichiers
analyze -library lib_rtl  -format vhdl $rtl_list

#elaboration des fichiers analys�es
elaborate $TOP_NAME -architecture ${TOP_NAME}_arch -library lib_rtl

#sauvegarde apr�s analyse et elaboration
write -format ddc -hierarchy -output $SYNTH_DIR/ddc/${TOP_NAME}_elab.ddc

#contraintes
set_operating_conditions -library c35_CORELIB nom_pvt
set_wire_load_model -name 10k -library c35_CORELIB
#set cycleTime 20 
#create_clock -name "clock" -period $cycleTime -waveform { 10 20  } $clock_name
#sauvegarde apr�s analyse et elaboration
write -format ddc -hierarchy -output $SYNTH_DIR/ddc/${TOP_NAME}_const.ddc

#synth�se
compile -map_effort high -area_effort medium -incremental_mapping

#sauvegarde apr�s analyse et elaboration
write -format ddc -hierarchy -output $SYNTH_DIR/ddc/${TOP_NAME}_synth.ddc

#generation du code vhdl
change_names -rules vhdl -verbose -hierarchy -log_changes $SYNTH_DIR/rpt/${TOP_NAME}_rename_vhdl.txt
write -format vhdl -hierarchy -output $GATES_DIR/${TOP_NAME}_synth.vhd

#generation du code verilog
change_names -rules verilog -verbose -hierarchy -log_changes $SYNTH_DIR/rpt/${TOP_NAME}_rename_verilog.txt

write -format verilog -hierarchy -output $GATES_DIR/${TOP_NAME}_synth.v
#generation du fichier sdf

write_sdf -version 2.1 $SYNTH_DIR/sdf/${TOP_NAME}_synth.sdf

#generation des rapports
report_design -nosplit  > $SYNTH_DIR/rpt/${TOP_NAME}_report_design.txt

report_hierarchy  > $SYNTH_DIR/rpt/${TOP_NAME}_report_hierarchy.txt

report_reference -hierarchy -nosplit > $SYNTH_DIR/rpt/${TOP_NAME}_report_reference.txt

report_port -nosplit -verbose >  $SYNTH_DIR/rpt/${TOP_NAME}_report_port.txt

report_area -nosplit -hierarchy >  $SYNTH_DIR/rpt/${TOP_NAME}_report_area.txt

#report_clock -nosplit >  $SYNTH_DIR/rpt/${TOP_NAME}_report_clock.txt

report_qor >  $SYNTH_DIR/rpt/${TOP_NAME}_report_qor.txt


# a completer

