all: get-cgm-data.R first-cgm-graph.Rmd
	Rscript -e 'rmarkdown::render("get-cgm-data.R")'
	Rscript -e 'rmarkdown::render("first-cgm-analysis.Rmd")'

post2015-07-29: 2015-07-29-get-cgm-data.Rmd
	Rscript -e 'rmarkdown::render("2015-07-29-get-cgm-data.Rmd", output_format="md_document")'

post2015-08-16: 2015-08-16-basic-statistics.Rmd
	Rscript -e 'rmarkdown::render( "2015-08-16-basic-statistics.Rmd" )'

post2015-08-03: 2015-08-03-daily-overlay.Rmd
	Rscript -e 'rmarkdown::render("2015-08-03-daily-overlay.Rmd", output_format="html_document")'
