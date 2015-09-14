---
layout: post
title: "Get CGM Data"
author: "Andy Choens"
category: "data management"
excerpt: Example code to import Nightscout DB into R.

---

# About


This is a follow up from my first post on 2015-07-29. That post
provides working code for querying our Nightscout database and storing
the resulting CGM data in CSV.

This code works. But, recompiling a R Markdown file, just to produce a
CSV file is . . . . inelegant. Which is why I need to write this
addendum. Several weeks ago I pulled the relevant code out of the .Rmd
file from two months ago and put together a R function and script able
to do the same thing with A LOT less fuss and bother.

# Objectives Of This Post

Objectives for this post include:

1. Introduce my new R function.
2. Introduce the script which uses the R function.
3. Discuss, briefly, the process I'm using to update the data
   published here.

# Code, Data, Tools

*Code:* The R function discussed here can be found on GitHub
 [here](https://github.com/Choens/blood-sugars/blob/master/R/importNightscout.R). The
 script using this function can be found
 [here](https://github.com/Choens/blood-sugars/blob/master/get-nightscout-data-from-server.R).

*Data:* All published data can be found in the [data
sub-folder](https://github.com/Choens/blood-sugars/tree/master/data) on
the project page.

*Data Warning:* Our current rig has been in nearly continuous use since
June 21, 2015. Data collected prior to June 2015 is less consistent due
to limitations with the previous rig and mistakes we made figuring out
how to use it. I do not recommend using data collected prior to June
2015 for analysis.

*Reproducibility Warning:* File names and content are subject to
periodic updates. Open a bug or download one of these data sets for
long-term use.

*Dependencies:* Beyond an operational R installation, you will need
 the rmongodb package. I'm experimenting with the mongolite package,
 but in the meantime, I will continue to use this package and code.

*Tools:* I used the [RoboMongo](http://robomongo.org/) application to
view Mongo JSON data directly in the database server. Like R, it is FOSS
and is available for Linux, Mac and Windows. Other tools used include R
and Emacs running on [Fedora 22](https://getfedora.com/).

# R Functions

I don't like long stretches of complicated sphagetti code. Sphagetti
code is hard to debug and tends to be inelegantly
repetitive. Programmers have an rule / acronym, D R Y, which stands
for Do Not Repeat Yourself.

Irony. I put D R Y and what it means into the same sentence!

The long post from July really only does three things.

1. Imports CGM data into a data frame.
2. Cleans up the data slightly.
3. Writes it to a CSV file in the data folder.

One project deliverable Karen wants is a live dashboard able to
explore her Nightscout CGM data. This dashboard will need a function
capable of doing steps 1 and 2, but not three. Thus, I created a
function to do 1 and 2 which I can use to produce CSV files and can be
reused by the dashboard I'll create sometime this fall.

The script will handle the last step. Writing a CSV file only takes a
couple of lines of code. No reason to create a new function to write
our data out to plain text.

The code for the function is below. I really won't waste your time
explaining it. It is almost EXACTLY like the code I published in
July. If you want to read that post, follow this
[link](https://choens.github.io/blood-sugars//data management/2015/07/29/Get-CGM-Data.html).

This function imports the Nightscout CGM data into R and returns a
data frame. I'll add more error checking before I use this function
with the dashboard.

{% highlight r linenos=table %}
    #' Imports Nightscout Data
    #' Imports Nightscout data.
    #' Requires rmongodb.
    #' The dependency on rmongodb may change in the future.
    #' In the future, this function will accept additional input, i.e. date range.
    #'
    #' @param ns_host URL or IP Address of the Nightscout host.
    #' @param ns_db Name of the Nightscout Database.
    #' @param ns_user User Name of the Nightscout DB user.
    #' @param ns_pw Password for the Nightscout DB user.
    #'
    #' @return A data frame containing the Nightscout data.
    #'
    importNightscout <- function(ns_host, ns_db, ns_user, ns_pw) {
        require(rmongodb)
     
        ## Open connection to Mongo ------------------------------------------------
        con <- mongo.create(host = ns_host,
                            username = ns_user,
                            password = ns_pw,
                            db = ns_db
                            )
     
        ## Make sure we have a connection ----------------------------------------------
        if(mongo.is.connected(con) == FALSE) stop("Mongo connection has been terminated.")
     
        ## This will later be used for a more mature error report.
        ns_collections <- mongo.get.database.collections(con, ns_db)
     
        ## Test connection ---------------------------------------------------------
        if(mongo.is.connected(con) == FALSE) stop("Mongo connection has been terminated.")
     
        ## Collections Variables -------------------------------------------------------
        ## Yeah, I just hard-coded these. Sue me.
        ns_entries <- paste(ns_db,".entries",sep="")
     
        ## Mongo Variables -------------------------------------------------------------
        ## ns_count: Total number of records in entries.
        ## ns_cursor: A cursor variable capable of returning the valie of all fields in
        ##            a single row of the entries collection.
        ##
        ns_count   <- mongo.count(con, ns_entries)
        ns_cursor <- mongo.find(con, ns_entries)
     
        ## R Vectors to hold Nightscout  data ------------------------------------------
        ## If you don't define the variable type, you tend to get characters.
        device     <- vector("character",ns_count)
        date       <- vector("numeric",ns_count)
        dateString <- vector("character",ns_count)
        sgv        <- vector("integer",ns_count)
        direction  <- vector("character",ns_count)
        type       <- vector("character",ns_count)
        filtered   <- vector("integer",ns_count)
        unfiltered <- vector("integer",ns_count)
        rssi       <- vector("integer",ns_count)
        noise      <- vector("integer",ns_count)
        mbg        <- vector("numeric",ns_count)
        slope      <- vector("numeric",ns_count)
        intercept  <- vector("numeric",ns_count)
        scale      <- vector("numeric",ns_count)
     
        ## Get the CGM Data, with a LOOP -----------------------------------------------
        i = 1
     
        while(mongo.cursor.next(ns_cursor)) {
     
            ## Get the values of the current record
            cval = mongo.cursor.value(ns_cursor)
     
            ## Place the values of the record into the appropriate location in the vectors.
            ## Must catch NULLS for each record or the vectors will have different lengths when we are done.
            device[i] <- if( is.null(mongo.bson.value(cval, "device")) ) NA else mongo.bson.value(cval, "device")
            date[i] <- if( is.null(mongo.bson.value(cval, "date")) ) NA else mongo.bson.value(cval, "date")
            dateString[i] <- if(is.null(mongo.bson.value(cval, "dateString")) ) NA else mongo.bson.value(cval, "dateString")
            sgv[i] <- if( is.null( mongo.bson.value(cval, "sgv") ) ) NA else mongo.bson.value(cval, "sgv")
            direction[i] <- if( is.null( mongo.bson.value(cval, "direction") ) ) NA else mongo.bson.value(cval, "direction")
            type[i] <- if( is.null(mongo.bson.value(cval, "type") ) ) NA else mongo.bson.value(cval, "type")
            filtered[i] <- if( is.null( mongo.bson.value(cval, "filtered") ) ) NA else mongo.bson.value(cval, "filtered")
            unfiltered[i] <- if( is.null( mongo.bson.value(cval, "unfiltered") ) ) NA else mongo.bson.value(cval, "unfiltered")
            rssi[i] <- if( is.null( mongo.bson.value(cval, "rssi") ) ) NA else mongo.bson.value(cval, "rssi")
            noise[i] <- if( is.null( mongo.bson.value(cval, "noise") ) ) NA else mongo.bson.value(cval, "noise")
            mbg[i] <- if( is.null( mongo.bson.value(cval, "mbg"))) NA else mongo.bson.value(cval, "mbg")
            slope[i] <- if( is.null( mongo.bson.value(cval, "slope") ) ) NA else mongo.bson.value(cval, "slope")
            intercept[i] <- if( is.null( mongo.bson.value(cval, "intercept") ) ) NA else mongo.bson.value(cval, "intercept")
            scale[i] <- if( is.null( mongo.bson.value(cval, "scale") ) ) NA else mongo.bson.value(cval, "scale")
     
            ## Increment cursor to next record.
            i = i + 1
        }
     
        ## Data Clean Up -----------------------------------------------------------
     
        ## Fixes dates.
        ## I'm not sure why I have to divide by 1000.
        date <- as.POSIXct(date/1000, origin = "1970-01-01 00:00:01")
     
        ## Builds the data frame ---------------------------------------------------
        entries <- as.data.frame(list( device = device,
                                      date = date,
                                      dateString = dateString,
                                      sgv = sgv,
                                      direction = direction,
                                      type = type,
                                      filtered = filtered,
                                      unfiltered = unfiltered,
                                      rssi = rssi,
                                      noise = noise,
                                      mbg = mbg,
                                      slope = slope,
                                      intercept = intercept,
                                      scale = scale
                                      )
                                 )
     
        return(entries)
    } ## END importNightscout
{% endhighlight %}

I then wrote a simple script in the root directory which uses this
function. It accepts the returned data frame and writes it out to CSV
in the data folder. To create a new data set, I only have to run the
script, which is in the Makefile as the save-data build.

{% highlight r linenos=table %}
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
{% endhighlight %}
