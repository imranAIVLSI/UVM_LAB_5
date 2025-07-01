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
-incdir ./task1_mcseq/tb
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

./task1_mcseq/tb/clkgen.sv
./router_rtl/yapp_router.sv
./task1_mcseq/tb/hw_top_no_dut.sv
./task1_mcseq/tb/tb_top.sv
+UVM_TESTNAME=test_uvc_integration
+UVM_VERBOSITY=UVM_HIGH
+SVSEED=random
//*** add compile files here

