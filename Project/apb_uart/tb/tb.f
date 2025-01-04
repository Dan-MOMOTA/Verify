+incdir+${APB_UART_HOME}/env
+incdir+${APB_UART_HOME}/env/apb
+incdir+${APB_UART_HOME}/env/uart
+incdir+${APB_UART_HOME}/env/ral
+incdir+${APB_UART_HOME}/tc
+incdir+${APB_UART_HOME}/tc/seq
+incdir+${APB_UART_HOME}/tb
+incdir+${APB_UART_HOME}/rtl

-f ${APB_UART_HOME}/rtl/rtl.f

${APB_UART_HOME}/tb/apb_uart_define.sv
${APB_UART_HOME}/tb/apb_uart_enum.sv
${APB_UART_HOME}/tb/plus.sv
-f ${APB_UART_HOME}/env/apb/apb.f
-f ${APB_UART_HOME}/env/uart/uart.f
-f ${APB_UART_HOME}/env/blk.f
-f ${APB_UART_HOME}/tc/seq/seq.f
-f ${APB_UART_HOME}/tc/tc.f

${APB_UART_HOME}/tb/test_top.sv





////////////////// PKG WAY \\\\\\\\\\\\\\\\\\\\
//${APB_UART_HOME}/tb/tb_pkg.sv
//${APB_UART_HOME}/env/apb/apb_pkg.sv
//${APB_UART_HOME}/env/uart/uart_pkg.sv
//${APB_UART_HOME}/env/blk_pkg.sv

//${APB_UART_HOME}/uvm_tb/register_model/uart_reg_pkg.sv
//${APB_UART_HOME}/uvm_tb/virtual_sequences/all_vseq_pkg.sv
//${APB_UART_HOME}/tc/seq/seq_pkg.sv
//${APB_UART_HOME}/tc/tc_pkg.sv

//${APB_UART_HOME}/protocol_monitor/apb_protocol_monitor.svh
//${APB_UART_HOME}/uvm_tb/tb/interrupt_if.svh
