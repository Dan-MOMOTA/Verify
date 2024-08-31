all:clean elab run

elab:
	vcs -full64 -debug_acc+all -sverilog -l comp.log \
	-f ./files.f \
	-timescale=1ns/1ps

run:
	./simv -l run.log

verdi:
	verdi -f ./files.f -ssf ./test.fsdb &

clean:
	rm -rf AN.DB DVEfiles csrc simv.* *simv inter.vpd ucli.key *.log novas* *fsdb verdiLog