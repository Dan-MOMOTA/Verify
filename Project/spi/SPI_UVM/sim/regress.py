#!/home/ICer/anaconda3/bin/python
# -*- coding: UTF-8 -*-
import os
import re
import sys
import random

run_times =[]
regress_list = [
                "tc=tc_sanity cfg=default,runtimes=10",
                "tc=tc_sanity cfg=coin_len_3,runtimes=10",
                "tc=tc_sanity cfg=coin_len_4,runtimes=10",
                "tc=tc_sanity cfg=coin_len_5,runtimes=10",
                "tc=tc_sanity cfg=send_delay_min,runtimes=10",
                "tc=tc_sanity cfg=send_delay_max,runtimes=10",
                "tc=tc_sanity cfg=send_num_max,runtimes=10",
                 "tc=tc_cancel cfg=default,runtimes=10",
                "tc=tc_cancel cfg=coin_len_3,runtimes=10",
                "tc=tc_cancel cfg=coin_len_4,runtimes=10",
                "tc=tc_cancel cfg=coin_len_5,runtimes=10",
                "tc=tc_cancel cfg=send_delay_min,runtimes=10",
                "tc=tc_cancel cfg=send_delay_max,runtimes=10",
                "tc=tc_cancel cfg=send_num_max,runtimes=10"
               ]
for i in range(len(regress_list)):
    tmp= regress_list[i].split(",")
    run_times.append(tmp[1]);
    regress_list[i]=tmp[0];
#print(run_times)
#print(regress_list)

for i in range(len(run_times)):
    tmp=run_times[i].split("=")
    run_times[i]=int(tmp[-1])

cmd = "make nrun"
val = os.system("rm -rf ./rgr_log_dir/*.log")
val = os.system("make cmp cov=on mode=regress")

for i in range(len(regress_list)):
    for k in range(run_times[i]):
        tmp_seed = ""
        for j in range(8):
            tmp_seed = (tmp_seed + str(random.randint(0,9)))
        seed = int(tmp_seed)
        val = os.system("{} {} seed={} cov=on wave=off mode=regress".format(cmd,regress_list[i],seed))
    #print(val)

val = os.system("grep 'Simulation Result' -R ./rgr_log_dir/*.log >regress.log")
#print(val)



#自己添加
# 执行grep命令，将包含"Simulation Result"的行写入regress.log文件
os.system("grep 'Simulation Result' -R ./rgr_log_dir/*.log >regress.log")

# 读取regress.log文件
with open("regress.log", "r") as file:
    lines = file.readlines()

# 初始化PASSED和FAILED的行数为0
passed_count = 0
failed_count = 0

# 遍历每一行，判断是否包含PASSED或FAILED，并相应地增加计数
for line in lines:
    if "PASSED" in line:
        passed_count += 1
    elif "FAILED" in line:
        failed_count += 1

# 在regress.log文件中打印两行分隔线
with open("regress.log", "a") as file:
    file.write(f"=====================\nNumber of PASSED lines: {passed_count}\n")
    file.write(f"=====================\nNumber of FAILED lines: {failed_count}\n")

