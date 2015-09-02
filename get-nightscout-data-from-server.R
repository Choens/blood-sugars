## #############################################################################
## Get Nightscout Data From Server
##
## Simple, reusable script to download data from the Nightscout server and
## save it as a CSV file in the data folder.
##
## The importNightscout function depends on rmongodb, so this script does too.
##
## #############################################################################

## Let's make sure we are starting clean.
rm(list=ls())

## Source the function, which imports it into the session.
source( file = "R/importNightscout.R" )

## Source the passwords file. See passwords.example.R for details
## regarding how to set up this file.
source( file = "passwords.R" )

## Imports the Nightscout CGM data and creates a data frame called entries.
## This is the standard name used in this project for Nightscout CGM data.
entries <- importNightscout(ns_host, ns_db, ns_user, ns_pw)

## Saves the data as a CSV file.
file_name <- paste("data/entries-", Sys.Date(), ".csv", sep="")
write.csv(entries, file_name, row.names = FALSE)

## Clean up the session and good-bye.
## If you don't want to immediately wipe out your session status,
## comment out this last line.
rm( list=ls() )


