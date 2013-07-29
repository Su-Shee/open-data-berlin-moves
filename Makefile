berlin-moves-data.csv: berlin-moves.temp
	@tr ' ' ';' < $< | \
	 sed -e '1i"year";"to";"from"' > $@
	@rm -f $<

berlin-moves-data.json: berlin-moves.temp
	@sed -e '1i{' \
	     -e '$$a}' \
			 -e 's/ /, /2' \
	     -e 's/ / : [ /' \
	     -e 's/$$/ ]/' \
			 -e '$$!s/]$$/],/' \
			 -e 's/\([0-9]\{4\}\)/\"\1\"/' $< > $@

berlin-moves-data.dat: berlin-moves.temp
	@awk '{print $$0 " " $$2-$$3}' < $< > $@

berlin-moves.temp: to-berlin.csv from-berlin.csv
	@join to-berlin.csv from-berlin.csv > $@
	@rm to-berlin.csv from-berlin.csv berlin-moves-dirty.csv

to-berlin.csv: berlin-moves-dirty.csv
	@sed -n 11,27p $< | \
	 cut -d ',' -f4,7 --output-delimiter=' ' > $@

from-berlin.csv: berlin-moves-dirty.csv
	@sed -n 37,53p $< | \
	 cut -d ',' -f4,7 --output-delimiter=' ' > $@

berlin-moves-dirty.csv: berlin-moves-data.xls
	@xls2csv -f -x $< -c $@

berlin-moves-data.xls:
	@wget http://www.berlin.de/imperia/md/content/sen-wirtschaft/konjunkturdaten/metadaten/e2_wander.xls \
		    -O berlin-moves-data.xls 2>/dev/null || true

clean:
	rm -f berlin-moves-data.xls
	rm -f berlin-moves-data.csv
	rm -f to-berlin.csv
	rm -f from-berlin.csv
	rm -f *.temp
