//命令：ralgen -t SPI -uvm -b spi.ralf 生成该文件

//寄存器class
//    ......

class ral_block_SPI extends uvm_reg_block;
//rand 寄存器class
    rand ral_reg_CTRL_REG CTRL_REG;
endclass