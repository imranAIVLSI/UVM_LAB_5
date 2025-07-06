// 64 bit option for AWS labs
-64

-uvmhome /home/cc/mnt/XCELIUM2309/tools/methodology/UVM/CDNS-1.1d
-timescale 1ns/1ns
// include directories
//*** add incdir include directories here
// -uvmhome $UVMHOME

-incdir .
-incdir ./YAPP/sv
-incdir ./channel/sv
-incdir ./clock_and_reset/sv
-incdir ./hbus/sv
// -incdir ./task1_mcseq/tb
-incdir ./task2_scb1/sv
-incdir ./task2_scb1/tb
// compile files

./YAPP/sv/yapp_pkg.sv
./channel/sv/channel_pkg.sv
./clock_and_reset/sv/clock_and_reset_pkg.sv
./hbus/sv/hbus_pkg.sv

// ../sv/yapp_packet.sv
./channel/sv/channel_if.sv
./YAPP/sv/yapp_if.sv
./clock_and_reset/sv/clock_and_reset_if.sv
./hbus/sv/hbus_if.sv

./task2_scb1/tb/clkgen.sv
./router_rtl/yapp_router.sv
./task2_scb1/tb/hw_top_no_dut.sv
./task2_scb1/tb/tb_top.sv
+UVM_TESTNAME=new_test_multi
+UVM_VERBOSITY=UVM_HIGH
+SVSEED=1
//*** add compile files here

