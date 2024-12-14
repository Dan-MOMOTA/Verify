class reg_apb_adapter extends uvm_reg_adapter;

    `uvm_object_utils(reg_apb_adapter)

    function new(string name = "reg_apb_adapter");
        super.new(name);
    endfunction

    function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        apb_transaction transfer;
        `uvm_info("adapter","rw",UVM_LOW)
        transfer = apb_transaction::type_id::create("transfer");
        transfer.randomize();
        transfer.paddr = rw.addr;
        transfer.pwrite = (rw.kind == UVM_READ) ? PREAD : PWRITE;
        transfer.pxdata = rw.data;
        return(transfer);      
    endfunction:reg2bus

    function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        apb_transaction transfer;
        if(!$cast(transfer, bus_item)) begin
            `uvm_fatal("NOT_REG_TYPE", "Provided bus_item is not of the correct type. Expecting apb_transaction")
            return;
        end
        rw.kind = (transfer.pwrite == PREAD) ? UVM_READ : UVM_WRITE;
        rw.addr = transfer.paddr;
        rw.data = transfer.pxdata;
        rw.status = UVM_IS_OK;      
    endfunction:bus2reg
        
endclass: reg_apb_adapter
