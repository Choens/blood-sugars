save-data: get-nightscout-data-from-server.R
	Rscript -e 'source("get-nightscout-data-from-server.R")'

post2015-07-29: 2015-07-29-get-cgm-data.Rmd
	Rscript -e 'rmarkdown::render("2015-07-29-get-cgm-data.Rmd", output_format="md_document")'

post2015-08-25: 2015-08-25-basic-cgm-statistics.Rmd
	Rscript -e 'rmarkdown::render( "2015-08-25-basic-cgm-statistics.Rmd" )'

post2015-08-03: 2015-08-03-daily-overlay.Rmd
	Rscript -e 'rmarkdown::render("2015-08-03-daily-overlay.Rmd", output_format="md_document")'

post2015-09-16: 2015-09-16-basic-cgm-graphs.Rmd
	Rscript -e 'rmarkdown::render("2015-09-16-basic-cgm-graphs.Rmd", output_format="md_document")'
