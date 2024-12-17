// =================================================================
// Copyright (C) 2024 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :custom_function.sv
// Creater     :Dan
// Create Date :2024-8-28
// Modification History:
// 
// Description:
//             1. add add_space function
//             2. add gen_date function
//=================================================================

function automatic string add_space(int space_num);
    string s0    = ""  ;
    string space = " " ;

    for(int i = 0; i < space_num; i++) begin
        $sformat(s0, "%s%s", s0, space);
    end
    return s0;
endfunction:add_space

function int unsigned gen_date();
    int unsigned date;
    integer      fp  ;

    void'($system("date > tmp"));
    fp = $fopen("tmp", "r");
    $fread(date, fp);
    $fclose(fp);
    void'($system("rm tmp"));
    $display("Today is %0s.",date);

    return date;
endfunction:gen_date
