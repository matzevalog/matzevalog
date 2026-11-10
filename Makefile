R_OPTS = --vanilla

.DEFAULT_GOAL: all
.PHONY: all

all: compile

compile_no_quiet: generate_qmds
	quarto render --no-clean
	Rscript -e "beepr::beep(10)"

compile: generate_qmds
	quarto render --no-clean --quiet
	Rscript -e "beepr::beep(10)"
	
generate_qmds: generate_data
	Rscript scripts/generate_qmds.R
generate_data:
	Rscript scripts/merge_data.R
test:
	Rscript scripts/test_and_write_logs.R
