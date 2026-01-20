#!/bin/csh -f
set noglob
set timestamp = `date -d "now" +%s`

######echo $YRUN_FLOW_ROOT/flow_main.py $* -chdir $timestamp
python3 $YRUN_FLOW_ROOT/flow_main.py $* -chdir $timestamp
if(-e $YRUN_TRUNK_ROOT/work/$timestamp.txt) then
    set path_dir = `cat $YRUN_TRUNK_ROOT/work/$timestamp.txt`
    rm -f $YRUN_TRUNK_ROOT/work/$timestamp.txt
    cd $path_dir
else

endif
unset noglob
