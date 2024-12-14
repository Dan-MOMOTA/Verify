#!/home/ICer/anaconda3/bin/python
# -*- coding: UTF-8 -*-
import os
import re
import sys
import time
import random

run_time = 30
sim = "make sim"
cmd = ""
run_times =[]
test_cases = []
regress_list = [
                "tc1,TC=tc_sanity cfg=default,run_times=run_time",
                "tc2,TC=tc_sanity cfg=coin_len_3,run_times=10",
                "tc3,TC=tc_sanity cfg=coin_len_4,run_times=10"
               ]

for i in range(len(regress_list)):
    tmp = regress_list[i].split(",")
    run_times.append(tmp[2]);
    regress_list[i]=tmp[1];
    test_cases.append(tmp[0]);

def test_case(tc_seed=""):
    if tc_seed != "":
        tc = re.split(r'\s+',tc_seed)[0]
        tmp_seed = re.split(r'\s+',tc_seed)[1]
        if tc in test_cases:
            for i in range(len(test_cases)):
                if tc == test_cases[i]:
                    if tmp_seed == "rand":
                        tmp_seed = int(time.strftime('%m%d%H%M%S'))
                    seed = int(tmp_seed)
                    val = os.system("{} {} seed={} COV_EN=0 SVA_EN=0 WAV_EN=1".format(sim,regress_list[i],seed))
        else:
            print(f"This testcase:{tc} invalid ...")
    else:
        print("Choose testcase as follow:")
        print(str(test_cases))

def regression():
    for i in range(len(run_times)):
        tmp = run_times[i].split("=")
        if(re.match('\d',tmp[-1])):
            run_times[i] = int(tmp[-1])
        elif(tmp[-1] == 'run_time'):
            run_times[i] = run_time
    if run_time <= 5:
        wav_en = 1
    else:
        wav_en = 0

    for i in range(len(regress_list)):
        for k in range(0,run_times[i]):
            seed = int(time.strftime('%m%d%H%M%S'))
            val = os.system("{} {} seed={} COV_EN=1 SVA_EN=1 WAV_EN={}".format(sim,regress_list[i],seed,wav_en))

def analysis_log():
    passed_count = 0
    failed_count = 0
    new_content = ''

    val = os.system("echo '===========================================' > regress.log")
    val = os.system("echo '-------------  Regression Log -------------' >> regress.log")
    val = os.system("echo '    Creator     : Dan' >> regress.log")
    val = os.system('echo "    Create Date : $(date +\%m\%H\%d\%M\%S)" >> regress.log')
    val = os.system("echo '    Describe    : ' >> regress.log")
    val = os.system("echo '===========================================' >> regress.log")
    val = os.system("echo '\n\n---------- Search for Simulation ----------' >> regress.log")
    val = os.system("grep 'Simulation Result' -R ./log/*.log >> regress.log")
    val = os.system("echo '\n\n---------- Search for Checking model error ----------' >> regress.log")
    val = os.system("grep 'ERROR! Timing Violation' -R ./log/*.log >> regress.log")
    val = os.system("echo '\n\n---------- Search for Checking assertion offending ----------' >> regress.log")
    val = os.system("grep 'Offending' -R ./log/*.log >> regress.log")

    with open("regress.log", "r") as file:
        lines = file.readlines()

    # 遍历每一行，判断是否包含PASSED或FAILED，并相应地增加计数
    for line in lines:
        if "PASSED" in line:
            passed_count += 1
        elif "FAILED" in line:
            failed_count += 1

    new_content = "\n\n========================"
    new_content = new_content + f"\n      Number of PASSED lines: {passed_count}"
    new_content = new_content + f"\n      Number of FAILED lines: {failed_count}"
    new_content = new_content + "\n========================"

    # 以读模式打开文件，读取现有内容
    with open("regress.log", 'r') as file:
        existing_content = file.read()

    # 分割日志文件的段落
    paragraphs = existing_content.split('\n\n')

    # 确保至少有一个段落
    if len(paragraphs) > 0:
        # 第二个段落后面添加新内容
        paragraphs[1] += new_content

    # 将修改后的内容写回文件
    with open("regress.log", 'w') as file:
        file.write('\n\n'.join(paragraphs))
    
    print('Complete Regression !!!')

def my_main(task=''):
    global run_time
    global cmd
    if task =='tc':
        cmp_sel = input("Whether need compile(y/n): ")
        if cmd == '':
            cmd = input("Select you tc and seed: ")
        if cmp_sel == 'y' or cmp_sel == '':
            val = os.system("make cmp")
        test_case(cmd)
    elif task == 'rg':
        cmp_sel = input("Whether need compile(y/n): ")
        #tmp_run_time = input("How many time you want(default 30): ")
        #if tmp_run_time != "":
        #    run_time = int(tmp_run_time)
        if cmp_sel == 'y' or cmp_sel == '':
            val = os.system("make cmp")
        regression()
        analysis_log()
    elif task == 'log':
        analysis_log()
    else:
        print("Invalid command ...")
        print("tc/rg/log,you need to choose one !!!")

### main function ###
if __name__ == '__main__':
    if len(sys.argv) > 1:
        if sys.argv[1] == 'tc' and len(sys.argv) > 3:
            cmd = str(sys.argv[2])+' '+str(sys.argv[3])
        if sys.argv[1] == 'rg' and len(sys.argv) > 2:
            run_time = int(sys.argv[2])
        my_main(task=sys.argv[1])
    else:
        print("Error,Check you command ...")
        print("tc/rg/log,you need to choose one !!!")

