ECCE=bin/ecce_cli
test: $(ECCE)
	$(ECCE) ecce_examples/mymember.pl -pe "main(T)" -dot ~/Desktop/out.dot
$(ECCE): ecce_source/*.pl
	make -C ecce_source/