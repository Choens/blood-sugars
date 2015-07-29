---
layout: post
title: "Get CGM Data"
author: "Andy Choens"
category: "Data Management"
excerpt: Documented R code for querying data from a Nightscout DB.

---

About
=====

[Nighscout](https://nightscout.github.io/) stores all of Karen's CGM
data on a [Mongodb](https://www.mongodb.org) server, controlled by our
family. To use Karen's Nightscout data to better understand her
diabetes, I have to learn how to use Mongo. Mongodb appears to be the
formal name of the product. It is referred to here as Mongo which
appears to be an abbreviation adopted by the community.

I have been using the [Robomongo](http://robomongo.org/) application to
view Mongo JSON data directly in the db server. Like R, it is FOSS and
is available for Linux, Mac and Windows.

Objectives
==========

1.  Import Nightscout data (JSON) and turn it into a R data frame.
2.  Briefly examine / QA the Nightscout data.
3.  Export the Nightscout data as a CSV file.

Code & Data
===========

The .Rmd file used to create this post is available on
[GitHub](https://github.com/Choens/blood-sugars/blob/master/get-cgm-data.Rmd).
The public data sets are in the [data
sub-folder](https://github.com/Choens/blood-sugars/tree/master/data).
The date on which the data file was built is provided in the CSV file
name.

File names and content is subject to periodic updates. Open a bug or
download one of these datasets for future use if you want to have a
guaranteed stable data-set. We have been using our current rig since
June 21, 2015. We are producing data at a prodigious rate. Data
collected prior to June 2015 is less consistent due to the limitations
with the previous rig and mistakes we made figuring out how to use it. I
do not recommend using data collected prior to June 2015 for analysis.

R Packages
==========

There are three R packages able to query a Mongo database:

-   [RMongo](http://cran.r-project.org/web/packages/RMongo/index.html)
    and
-   [rmongodb](http://cran.r-project.org/web/packages/rmongodb/index.html).
-   [mongolite](https://cran.r-project.org/web/packages/mongolite/index.html)

When I first started writing this, I only knew about the first two. I
have not yet tried to use mongolite. I'll write a separate post
discussing it.

I skimmed the documentation for the first two packages. RMongo looked
easier to use so I tried it first. Unfortunately, I was never able to
connect to our Mongo server running on [mongolab](https://mongolab.com/)
using RMongo. RMongo is not able to connect to Mongo using user names,
passwords or custom ports. All three of these are required to connect to
a mongolab server. Based on the documentation, RMongo has a more
R-centric API and it is probably great if you want to connect to a local
Mongo server. But that isn't what I want to do, so I stopped working
with it. Because I was never able to connect to my mongo server, the
example code below does not include RMongo.

The second package, rmongodb, feels more complicated but it works well.
This package loops over a cursor to import the data one entry at a time.
Looping over a cursor object is an algorithm commonly used in web
development but not in R, which tends to avoid loops. Using a cursor in
R feels unnecessarily complicated, it works. Most of the example code
you will find for using rmongodb is simplistic compared to what I have
written here, because most of the examples I have found are querying
much simpler collections. Although mongo is certainly very fast, I find
the additional complexity frustrating. Structural differences in JSON
objects and native R data structures are and additional source of
complexity to the code below.

I am hopeful that mongolite will simplify this. In the meantime, this is
a workable solution for importing data from a Nightscout database.

Import Nightscout data (JSON) and turn it into a R data frame
=============================================================

My literate programming documents always start with a chunk called init,
to define variables, load packages, etc. This script has three
dependencies, rmongodb, dplyr and pander. Normally this code chunk would
be hidden. Because this is an example, it is visible below.

The file, passwords.R, is not part of the public repo for security
reasons. This may be frustrating because the example code herein cannot
be run immediately on your own system and for that I apologize. As
written, this code is only runnable if you have access to a Nightscout
server. If you do, you can adopt the code in the
[passwords.example.R](https://github.com/Choens/blood-sugars/blob/master/passwords.example.R)
file to connect to your own database.

    ## passwords.R -----------------------------------------------------------------
    ## Defines the variables I don't want to post to GitHub. (Sorry)
    ## ns is short for Nightscout.
    ## ns_host = URL for the host server (xyz.mongolab.com:123456)
    ## ns_db = Name of the Nightscout database (lade_k_nightscout)
    ## ns_user = Admin User Name (Not admin)
    ## ns_pw = Admin Password (Not Admin)
    source("passwords.R")

    ## Required Packages -----------------------------------------------------------
    library(rmongodb)  ## For importing the data.
    library(dplyr)     ## For QA / data manipulation.
    library(pander)    ## For nice looking tables, etc.

Loading the rmongodb package, version 1.8.0, returns the following
dramatic warning:

> WARNING!

> There are some quite big changes in this version of rmongodb.
> mongo.bson.to.list, mongo.bson.from.list (which are workhorses of many
> other rmongofb high-level functions) are rewritten. Please, TEST IT
> BEFORE PRODUCTION USAGE. Also there are some other important changes,
> please see NEWS file and release notes at
> <https://github.com/mongosoup/rmongodb/releases/>

In spite of this warning, it worked fine. Mongo stores data in an object
called a collection, which is similar to a table in a traditional RDBMS.
However, unlike a table, the structure of a collection is not defined
prior to use. There are several other differences, which you can learn
about by reading the [introduction
tutorial](https://www.mongodb.org/about/introduction/) which is written
by actual mongo experts.

The following code chunk returns a list of all the collections which
exist in the Nighscout database. The "entries" collection is the only
collection we are interested in today. The database name,
lade\_k\_nightscout is prepended to each collection name.

    ## Open a connection to mongo --------------------------------------------------
    con <- mongo.create(host = ns_host,
                        username = ns_user,
                        password = ns_pw,
                        db = ns_db
                       )

    ## Make sure we have a connection ----------------------------------------------
    if(mongo.is.connected(con) == FALSE) stop("Mongo connection has been terminated.")


    ns_collections <- mongo.get.database.collections(con, ns_db)
    pandoc.list(ns_collections)

-   lade\_k\_nightscout.entries
-   lade\_k\_nightscout.devicestatus
-   lade\_k\_nightscout.treatments

<!-- end of list -->
The next code chunk will produce some empty vectors needed to hold the
Nightscout data before it is turned into a data frame. When importing
data from a RDBMS, it is normal practice to place the imported data
directly into an R data frame. When importing data from Mongo, the data
must first be placed into vectors. This is further complicated by the
fact that some records have a different number of fields and we have to
handle the NULL values in R, rather than via the database. Complexities
like this make this code much more complicated than a simple 'select \*
from foo;' query in a RDBMS.

    ## Make sure we still have a connection ----------------------------------------
    if(mongo.is.connected(con) == FALSE) stop("Mongo connection has been terminated.")

    ## Collections Variables -------------------------------------------------------
    ## Yeah, I just hard-coded these. Sue me.
    ns_entries <- "lade_k_nightscout.entries"

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

As of 2015-07-29 the "entries" collection contains
`r format(ns_count, big.mark=",")` records. That is a lot of data, about
a single person. The following code chunk imports the records in
'entries' and places the data into the vectors produced above.

The 'ns\_cursor' variable is a cursor. Looping over a cursor to get
row-specific returns is an approach which should be familiar to
web-developers. The use of a cursor loop feels odd because R programming
usually avoids loops like the plague but this approach works and appears
to be the preferred way of importing data from Mongo.

    ## Get the CGM Data, with a LOOP -----------------------------------------------
    ## The examples I found on the Internet always show this loop as a while loop.
    ## Depending on my future import needs, I may need to change this to a for loop.
    ## A new record is added every five minutes, which means it is not impossible for
    ## a new data entry to be produced while this script is running, even though it
    ## takes less that a couple of seconds to run.

    i = 1

    while(mongo.cursor.next(ns_cursor)) {
        
        # Get the values of the current record
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
        mbg[i] <- if( is.null(mongo.bson.value(cval, "mbg"))) NA else mongo.bson.value(cval, "mbg")
        slope[i] <- if( is.null( mongo.bson.value(cval, "slope") ) ) NA else mongo.bson.value(cval, "slope")
        intercept[i] <- if( is.null( mongo.bson.value(cval, "intercept") ) ) NA else mongo.bson.value(cval, "intercept")
        scale[i] <- if( is.null( mongo.bson.value(cval, "scale") ) ) NA else mongo.bson.value(cval, "scale")

        ## Increment the cursor to the next record.
        i = i + 1
    }


    ## Data Clean Up ---------------------------------------------------------------

    ## Fixes the date data.
    ## I'm not sure why I have to divide by 1000. If I don't, this won't work.
    date <- as.POSIXct(date/1000, origin = "1970-01-01 00:00:01")


    ## Builds the data.frame -------------------------------------------------------
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

Mongo allows each record to have a different number of data elements.
Thus, not all records include a 'mbg' element. Furthermore, NULLS must
be handled by the client. Querying a collection with a complicated data
structure requires some trial and error.

Briefly examine / QA the Nightscout data
========================================

The next code chunk does some very minimal QA on the "entries" data
frame. If the data frame has 0 rows, it will force the script to stop.
Otherwise, it returns a table with some basic meta-data about the
imported data set.

    if(dim(entries)[1] == 0) stop("Entries variable contains no rows.")

    entries %>%
        summarize(
            "N Rows" = n(),
            "N Days" = length(unique( format.POSIXct(.$date, format="%F" ))),
            "First Day" = min( format.POSIXct(.$date, format="%F" )),
            "Last Day" = max( format.POSIXct(.$date, format="%F" ))
            ) %>%
        pander()

<table>
<colgroup>
<col width="12%" />
<col width="12%" />
<col width="16%" />
<col width="16%" />
</colgroup>
<thead>
<tr class="header">
<th align="center">N Rows</th>
<th align="center">N Days</th>
<th align="center">First Day</th>
<th align="center">Last Day</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center">14368</td>
<td align="center">74</td>
<td align="center">FALSE</td>
<td align="center">2015-07-29</td>
</tr>
</tbody>
</table>

The following code chunk returns the number of entries recorded each day
between June 20 and July 05. Each entry is an independent intersitial
glucose reading. These readings are uploaded via the rig to the
Nightscout database. Assuming everything is working, the sensor takes a
new reading every five minutes. These entries are then uploaded to the
database, for an expected average of 288 entries per day.

    entries %>%
        filter(date >= "2015-06-20" & date <= "2015-07-05") %>%
        group_by( "Date" = format.POSIXct(.$date, format="%F") ) %>%
        summarize("N Entries" = n() ) %>%
        pander()

<table>
<colgroup>
<col width="15%" />
<col width="15%" />
</colgroup>
<thead>
<tr class="header">
<th align="center">Date</th>
<th align="center">N Entries</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center">2015-06-21</td>
<td align="center">15</td>
</tr>
<tr class="even">
<td align="center">2015-06-22</td>
<td align="center">279</td>
</tr>
<tr class="odd">
<td align="center">2015-06-23</td>
<td align="center">261</td>
</tr>
<tr class="even">
<td align="center">2015-06-24</td>
<td align="center">275</td>
</tr>
<tr class="odd">
<td align="center">2015-06-25</td>
<td align="center">286</td>
</tr>
<tr class="even">
<td align="center">2015-06-26</td>
<td align="center">237</td>
</tr>
<tr class="odd">
<td align="center">2015-06-27</td>
<td align="center">85</td>
</tr>
<tr class="even">
<td align="center">2015-06-28</td>
<td align="center">130</td>
</tr>
<tr class="odd">
<td align="center">2015-06-29</td>
<td align="center">282</td>
</tr>
<tr class="even">
<td align="center">2015-06-30</td>
<td align="center">285</td>
</tr>
<tr class="odd">
<td align="center">2015-07-01</td>
<td align="center">276</td>
</tr>
<tr class="even">
<td align="center">2015-07-02</td>
<td align="center">283</td>
</tr>
<tr class="odd">
<td align="center">2015-07-03</td>
<td align="center">256</td>
</tr>
<tr class="even">
<td align="center">2015-07-04</td>
<td align="center">283</td>
</tr>
</tbody>
</table>

Nightscout users refer to the hardware and software used to manage their
data as a 'rig'. The previous table is interesting because it shows the
variability in the amount of data collected via the rig. There are
several days which have far less than the expected number of entries.

-   June 21: I set up Karen's current rig on the evening of the 21st.
    Because it was late, Karen's rig only recorded 15 entries on that
    'day'.
-   June 27: Karen believes she replaced her CGM sensor on June 27.
    There was a period of several hours of no data after the old sensor
    failed and an additional time gap while she was syncing the new
    sensor to her CGM. As a result of those gaps, there are only 85
    records on the 27th.
-   June 28: The small number of entries on the 28th is a small mystery.
    For some reason the sensor was not communicating with the receiver
    correctly or the rig failed to upload the data to the server. We
    don't know which.

The other days are fairly consistent, but the table does demonstrate how
the number of entries recorded can vary dramatically. The inconsistency
in the quantity of data will have an impact on our ability to use
Nightscout data to predict her future blood glucose levels.

Export the Nightscout data as a CSV file
========================================

The final code chunk exports a date-stamped CSV file. I'll try to add a
new data set periodically to the public data if anyone wants to use it.
Old data sets will remain frozen, for reproducibility purposes, but may
disappear at some point in the future. Don't expect there to be more
than 5 data sets in the data folder.

    ## Saves the data as a CSV file ------------------------------------------------
    ## You are welcome to use the data stored publicly in the data folder.
    file_name <- paste("data/entries-", Sys.Date(), ".csv", sep="")
    write.csv(entries, file_name, row.names = FALSE)

    ## Clean up the session and good-bye.
    rm(list=ls())
