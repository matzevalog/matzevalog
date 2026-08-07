R_OPTS = --vanilla

.DEFAULT_GOAL: all
.PHONY: all

all: compile

compile_no_quiet: generate_qmds
	quarto render tombstones/QBA001* --no-clean
	quarto render tombstones/QBA002* --no-clean
	quarto render tombstones/QBA003* --no-clean
	quarto render tombstones/QBA004* --no-clean
	quarto render tombstones/QBA005* --no-clean
	quarto render tombstones/QBA006* --no-clean
	quarto render tombstones/QBA007* --no-clean
	quarto render tombstones/QBA008* --no-clean
	quarto render tombstones/QBA009* --no-clean
	quarto render tombstones/QBA010* --no-clean
	quarto render tombstones/QBA011* --no-clean
	quarto render tombstones/QBA012* --no-clean
	quarto render tombstones/QBA013* --no-clean
	quarto render tombstones/QBA014* --no-clean
	quarto render tombstones/QBA015* --no-clean
	quarto render tombstones/QBA016* --no-clean
	quarto render tombstones/QBA017* --no-clean
	quarto render tombstones/QBA018* --no-clean
	quarto render tombstones/QBA019* --no-clean
	quarto render tombstones/QBA020* --no-clean
	quarto render tombstones/QBA021* --no-clean
	quarto render tombstones/QBA022* --no-clean
	quarto render tombstones/QBA023* --no-clean
	quarto render tombstones/QBA024* --no-clean
	quarto render tombstones/QBA025* --no-clean
	quarto render tombstones/QBA026* --no-clean
	quarto render tombstones/QBA027* --no-clean
	quarto render tombstones/QBA028* --no-clean
	quarto render tombstones/QBA029* --no-clean
	quarto render tombstones/QBA030* --no-clean
	quarto render tombstones/QBA031* --no-clean
	quarto render tombstones/QBA032* --no-clean
	quarto render tombstones/QBA033* --no-clean
	quarto render tombstones/QBA034* --no-clean
	quarto render tombstones/QBA035* --no-clean
	quarto render tombstones/QBA036* --no-clean
	quarto render tombstones/QBA037* --no-clean
	quarto render tombstones/QBA038* --no-clean
	quarto render tombstones/QBA039* --no-clean
	quarto render tombstones/QBA040* --no-clean
	quarto render tombstones/QBA041* --no-clean
	quarto render tombstones/QBA042* --no-clean
	quarto render tombstones/QBA043* --no-clean
	quarto render tombstones/QBA044* --no-clean
	quarto render tombstones/QBA045* --no-clean
	quarto render tombstones/QBA046* --no-clean
	quarto render tombstones/QBA047* --no-clean
	quarto render tombstones/QBA048* --no-clean
	quarto render tombstones/QBA049* --no-clean
	quarto render tombstones/QBA050* --no-clean
	quarto render tombstones/QBA051* --no-clean
	quarto render tombstones/QBA052* --no-clean
	quarto render tombstones/QBA053* --no-clean
	quarto render tombstones/QBA054* --no-clean
	quarto render tombstones/QBA055* --no-clean
	quarto render tombstones/QBA056* --no-clean
	quarto render tombstones/QBA057* --no-clean
	quarto render tombstones/QBA058* --no-clean
	quarto render tombstones/QBA059* --no-clean
	quarto render tombstones/QBA060* --no-clean
	quarto render tombstones/QBA061* --no-clean
	quarto render tombstones/QBA062* --no-clean
	quarto render tombstones/QBA063* --no-clean
	quarto render tombstones/QBA064* --no-clean
	quarto render tombstones/QBA065* --no-clean
	quarto render tombstones/QBA066* --no-clean
	quarto render tombstones/QBA067* --no-clean
	quarto render tombstones/QBA068* --no-clean
	quarto render tombstones/QBA069* --no-clean
	quarto render tombstones/QBA070* --no-clean
	quarto render tombstones/QBA071* --no-clean
	quarto render tombstones/QBA072* --no-clean
	quarto render tombstones/QBA073* --no-clean
	quarto render tombstones/QBA074* --no-clean
	quarto render tombstones/QBA075* --no-clean
	quarto render tombstones/QBA076* --no-clean
	quarto render tombstones/QBA077* --no-clean
	quarto render tombstones/QBA078* --no-clean
	quarto render tombstones/QBA079* --no-clean
	quarto render tombstones/QBA080* --no-clean
	quarto render tombstones/QBA081* --no-clean
	quarto render tombstones/QBA082* --no-clean
	quarto render tombstones/QBA083* --no-clean
	quarto render tombstones/QBA084* --no-clean
	quarto render tombstones/QBA085* --no-clean
	quarto render tombstones/QBA086* --no-clean
	quarto render tombstones/QBA087* --no-clean
	quarto render tombstones/QBA088* --no-clean
	quarto render tombstones/QBA089* --no-clean
	quarto render tombstones/QBA090* --no-clean
	quarto render tombstones/QBA091* --no-clean
	quarto render tombstones/QBA092* --no-clean
	quarto render tombstones/QBA093* --no-clean
	quarto render tombstones/QBA094* --no-clean
	quarto render tombstones/QBA095* --no-clean
	quarto render tombstones/QBA096* --no-clean
	quarto render tombstones/QBA097* --no-clean
	quarto render tombstones/QBA098* --no-clean
	quarto render tombstones/QBA099* --no-clean
	quarto render tombstones/QBA100* --no-clean
	quarto render tombstones/QBA101* --no-clean
	quarto render tombstones/QBA102* --no-clean
	quarto render tombstones/QBA103* --no-clean
	quarto render tombstones/QBA104* --no-clean
	quarto render tombstones/QBA105* --no-clean
	quarto render tombstones/QBA106* --no-clean
	quarto render tombstones/QBA107* --no-clean
	quarto render tombstones/QBA108* --no-clean
	quarto render tombstones/QBA109* --no-clean
	quarto render tombstones/QBA110* --no-clean
	quarto render tombstones/QBA111* --no-clean
	quarto render tombstones/QBA112* --no-clean
	quarto render tombstones/QBA113* --no-clean
	quarto render tombstones/QBA114* --no-clean
	quarto render tombstones/QBA115* --no-clean
	quarto render tombstones/QBA116* --no-clean
	quarto render cemeteries/* --no-clean
	quarto render tombstones.qmd --no-clean
	quarto render cemeteries.qmd --no-clean
	quarto render index.qmd --no-clean
	Rscript -e "beepr::beep(10)"

compile: generate_qmds
	quarto render tombstones/QBA001* --no-clean --quiet
	quarto render tombstones/QBA002* --no-clean --quiet
	quarto render tombstones/QBA003* --no-clean --quiet
	quarto render tombstones/QBA004* --no-clean --quiet
	quarto render tombstones/QBA005* --no-clean --quiet
	quarto render tombstones/QBA006* --no-clean --quiet
	quarto render tombstones/QBA007* --no-clean --quiet
	quarto render tombstones/QBA008* --no-clean --quiet
	quarto render tombstones/QBA009* --no-clean --quiet
	quarto render tombstones/QBA010* --no-clean --quiet
	quarto render tombstones/QBA011* --no-clean --quiet
	quarto render tombstones/QBA012* --no-clean --quiet
	quarto render tombstones/QBA013* --no-clean --quiet
	quarto render tombstones/QBA014* --no-clean --quiet
	quarto render tombstones/QBA015* --no-clean --quiet
	quarto render tombstones/QBA016* --no-clean --quiet
	quarto render tombstones/QBA017* --no-clean --quiet
	quarto render tombstones/QBA018* --no-clean --quiet
	quarto render tombstones/QBA019* --no-clean --quiet
	quarto render tombstones/QBA020* --no-clean --quiet
	quarto render tombstones/QBA021* --no-clean --quiet
	quarto render tombstones/QBA022* --no-clean --quiet
	quarto render tombstones/QBA023* --no-clean --quiet
	quarto render tombstones/QBA024* --no-clean --quiet
	quarto render tombstones/QBA025* --no-clean --quiet
	quarto render tombstones/QBA026* --no-clean --quiet
	quarto render tombstones/QBA027* --no-clean --quiet
	quarto render tombstones/QBA028* --no-clean --quiet
	quarto render tombstones/QBA029* --no-clean --quiet
	quarto render tombstones/QBA030* --no-clean --quiet
	quarto render tombstones/QBA031* --no-clean --quiet
	quarto render tombstones/QBA032* --no-clean --quiet
	quarto render tombstones/QBA033* --no-clean --quiet
	quarto render tombstones/QBA034* --no-clean --quiet
	quarto render tombstones/QBA035* --no-clean --quiet
	quarto render tombstones/QBA036* --no-clean --quiet
	quarto render tombstones/QBA037* --no-clean --quiet
	quarto render tombstones/QBA038* --no-clean --quiet
	quarto render tombstones/QBA039* --no-clean --quiet
	quarto render tombstones/QBA040* --no-clean --quiet
	quarto render tombstones/QBA041* --no-clean --quiet
	quarto render tombstones/QBA042* --no-clean --quiet
	quarto render tombstones/QBA043* --no-clean --quiet
	quarto render tombstones/QBA044* --no-clean --quiet
	quarto render tombstones/QBA045* --no-clean --quiet
	quarto render tombstones/QBA046* --no-clean --quiet
	quarto render tombstones/QBA047* --no-clean --quiet
	quarto render tombstones/QBA048* --no-clean --quiet
	quarto render tombstones/QBA049* --no-clean --quiet
	quarto render tombstones/QBA050* --no-clean --quiet
	quarto render tombstones/QBA051* --no-clean --quiet
	quarto render tombstones/QBA052* --no-clean --quiet
	quarto render tombstones/QBA053* --no-clean --quiet
	quarto render tombstones/QBA054* --no-clean --quiet
	quarto render tombstones/QBA055* --no-clean --quiet
	quarto render tombstones/QBA056* --no-clean --quiet
	quarto render tombstones/QBA057* --no-clean --quiet
	quarto render tombstones/QBA058* --no-clean --quiet
	quarto render tombstones/QBA059* --no-clean --quiet
	quarto render tombstones/QBA060* --no-clean --quiet
	quarto render tombstones/QBA061* --no-clean --quiet
	quarto render tombstones/QBA062* --no-clean --quiet
	quarto render tombstones/QBA063* --no-clean --quiet
	quarto render tombstones/QBA064* --no-clean --quiet
	quarto render tombstones/QBA065* --no-clean --quiet
	quarto render tombstones/QBA066* --no-clean --quiet
	quarto render tombstones/QBA067* --no-clean --quiet
	quarto render tombstones/QBA068* --no-clean --quiet
	quarto render tombstones/QBA069* --no-clean --quiet
	quarto render tombstones/QBA070* --no-clean --quiet
	quarto render tombstones/QBA071* --no-clean --quiet
	quarto render tombstones/QBA072* --no-clean --quiet
	quarto render tombstones/QBA073* --no-clean --quiet
	quarto render tombstones/QBA074* --no-clean --quiet
	quarto render tombstones/QBA075* --no-clean --quiet
	quarto render tombstones/QBA076* --no-clean --quiet
	quarto render tombstones/QBA077* --no-clean --quiet
	quarto render tombstones/QBA078* --no-clean --quiet
	quarto render tombstones/QBA079* --no-clean --quiet
	quarto render tombstones/QBA080* --no-clean --quiet
	quarto render tombstones/QBA081* --no-clean --quiet
	quarto render tombstones/QBA082* --no-clean --quiet
	quarto render tombstones/QBA083* --no-clean --quiet
	quarto render tombstones/QBA084* --no-clean --quiet
	quarto render tombstones/QBA085* --no-clean --quiet
	quarto render tombstones/QBA086* --no-clean --quiet
	quarto render tombstones/QBA087* --no-clean --quiet
	quarto render tombstones/QBA088* --no-clean --quiet
	quarto render tombstones/QBA089* --no-clean --quiet
	quarto render tombstones/QBA090* --no-clean --quiet
	quarto render tombstones/QBA091* --no-clean --quiet
	quarto render tombstones/QBA092* --no-clean --quiet
	quarto render tombstones/QBA093* --no-clean --quiet
	quarto render tombstones/QBA094* --no-clean --quiet
	quarto render tombstones/QBA095* --no-clean --quiet
	quarto render tombstones/QBA096* --no-clean --quiet
	quarto render tombstones/QBA097* --no-clean --quiet
	quarto render tombstones/QBA098* --no-clean --quiet
	quarto render tombstones/QBA099* --no-clean --quiet
	quarto render tombstones/QBA100* --no-clean --quiet
	quarto render tombstones/QBA101* --no-clean --quiet
	quarto render tombstones/QBA102* --no-clean --quiet
	quarto render tombstones/QBA103* --no-clean --quiet
	quarto render tombstones/QBA104* --no-clean --quiet
	quarto render tombstones/QBA105* --no-clean --quiet
	quarto render tombstones/QBA106* --no-clean --quiet
	quarto render tombstones/QBA107* --no-clean --quiet
	quarto render tombstones/QBA108* --no-clean --quiet
	quarto render tombstones/QBA109* --no-clean --quiet
	quarto render tombstones/QBA110* --no-clean --quiet
	quarto render tombstones/QBA111* --no-clean --quiet
	quarto render tombstones/QBA112* --no-clean --quiet
	quarto render tombstones/QBA113* --no-clean --quiet
	quarto render tombstones/QBA114* --no-clean --quiet
	quarto render tombstones/QBA115* --no-clean --quiet
	quarto render tombstones/QBA116* --no-clean --quiet
	quarto render cemeteries/* --no-clean --quiet
	quarto render tombstones.qmd --no-clean --quiet
	quarto render cemeteries.qmd --no-clean --quiet
	quarto render index.qmd --no-clean --quiet
	Rscript -e "beepr::beep(10)"
	
generate_qmds: generate_data
	Rscript scripts/generate_qmds.R
generate_data:
	Rscript scripts/merge_data.R
test:
	Rscript scripts/test_and_write_logs.R
