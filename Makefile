berlin-moves-data.dat: berlin-moves-data.csv
	@awk -F'";"' '{print $$1 "  " $$2 "  " $$3 "  " $$2-$$3}' $< | \
	 sed -e 's/"//g' \
	     -e '1d' > $@

berlin-moves-data.json: berlin-moves-data.csv
	@sed -e '1i{' \
	     -e '1d' \
	     -e 's/;/ : [ /' \
	     -e 's/"//3g' \
	     -e 's/;/, /' \
	     -e 's/$$/ ]/' \
	     -e '$$!s/]/],/' \
	     -e '$$a}' $< > $@

berlin-moves-data.csv: to-berlin.csv from-berlin.csv
	@pr -m -t -s\; to-berlin.csv from-berlin.csv | \
	 awk -F';' '{ print $$1";"$$2";"$$4 }' > $@
	@sed -i '1i"year";"to";"from"' $@
	@rm to-berlin.csv from-berlin.csv berlin-moves-dirty.csv

to-berlin.csv: berlin-moves-dirty.csv
	@sed -n 11,27p berlin-moves-dirty.csv | \
	 sed -e 's/\([0-9]\{4\}\)/\"\1\"/g' \
	     -e 's/\([0-9]\{3\}\),\([0-9]\{,3\}\)/\1.\2/g' \
	     -e 's/,//g' \
	     -e 's/\"\"/\";\"/g' > $@

from-berlin.csv: berlin-moves-dirty.csv
	@sed -n 37,53p $< | \
	 sed -e 's/\([0-9]\{4\}\)/\"\1\"/g' \
	     -e 's/\([0-9]\{3\}\),\([0-9]\{,3\}\)/\1.\2/g' \
	     -e 's/,//g' \
	     -e 's/\"\"/\";\"/g' > $@

berlin-moves-dirty.csv: berlin-moves-data.xls
	@libreoffice --headless --invisible --convert-to csv berlin-moves-data.xls &>/dev/null || true
	@mv berlin-moves-data.csv $@
	# alternative: xls2csv -f -x $< -c $@ - based on perl's excel module

berlin-moves-data.xls:
	@wget http://www.berlin.de/imperia/md/content/sen-wirtschaft/konjunkturdaten/metadaten/e2_wander.xls \
		    -O berlin-moves-data.xls 2>/dev/null || true

clean:
	rm -f berlin-moves-data*
	rm -f to-berlin.csv
	rm -f from-berlin.csv
