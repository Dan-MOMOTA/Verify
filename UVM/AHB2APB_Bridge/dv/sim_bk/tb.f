//-timescale=1ns/1ns/1n

+incdir+../env
+incdir+../vip/ahbl_mst
+incdir+../vip/apb_slv

//Source file
../../rtl/cmsdk_ahb_to_apb.v
../vip/ahbl_mst/ahbl_mst_pkg.svh
../vip/apb_slv/apb_slv_pkg.svh
../env/ahb2apb_pkg.sv
../env/ahb2apb_base_test.sv
../tb/reset_if.sv
../seqlib/ahbl_mst_seqlib.sv
../seqlib/apb_slv_seqlib.sv
-f ../sim_bk/tc.f
../tb/ahb2apb_tb.sv




