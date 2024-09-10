//-timescale=1ns/1ns/1n

+incdir+../env
+incdir+../vip/ahbl_mst
+incdir+../vip/apb_slv
+incdir+./opt/Synopsys/VCS2018/vcs/O-2018.09-SP2/etc/uvm-1.2

//Source file
../../rtl/cmsdk_ahb_to_apb.v
../vip/ahbl_mst/ahbl_if.sv
../vip/ahbl_mst/ahbl_mst_enum.svh
../vip/ahbl_mst/ahbl_trans.svh
../vip/ahbl_mst/ahbl_mst_drv.svh
../vip/ahbl_mst/ahbl_mst_sqr.svh
../vip/ahbl_mst/ahbl_mst_mon.svh
../vip/ahbl_mst/ahbl_mst_agt.svh
../vip/ahbl_mst/ahbl_mst_pkg.svh
../vip/apb_slv/apb_if.sv
../vip/apb_slv/apb_slv_enum.svh
../vip/apb_slv/apb_mem.svh
../vip/apb_slv/apb_trans.svh
../vip/apb_slv/apb_slv_drv.svh
../vip/apb_slv/apb_slv_sqr.svh
../vip/apb_slv/apb_slv_mon.svh
../vip/apb_slv/apb_slv_agt.svh
../vip/apb_slv/apb_slv_pkg.svh
../env/func_cov.sv
../env/ahb2apb_scb.svh
../env/ahb2apb_env.sv
../env/ahb2apb_pkg.sv
../env/ahb2apb_base_test.sv
../tb/reset_if.sv
../seqlib/ahbl_mst_seqlib.sv
../seqlib/apb_slv_seqlib.sv
-f ../flist/tc.f
../tb/ahb2apb_tb.sv

