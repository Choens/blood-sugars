all: get-cgm-data.R first-cgm-graph.Rmd
	Rscript -e 'rmarkdown::render("get-cgm-data.R")'
	Rscript -e 'rmarkdown::render("first-cgm-analysis.Rmd")'

demo: first-cgm-graph.Rmd
	Rscript -e 'rmarkdown::render("first-cgm-analysis.Rmd")'

import: get-cgm-data.Rmd
	Rscript -e 'rmarkdown::render("get-cgm-data.Rmd", output_format="md_document")'
