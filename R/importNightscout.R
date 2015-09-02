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
