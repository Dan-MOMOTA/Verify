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
//=================================================================

function automatic string add_space(int space_num);
    string s0    = ""  ;
    string space = " " ;

    for(int i = 0; i < space_num; i++) begin
        $sformat(s0, "%s%s", s0, space);
    end
    return s0;
endfunction
