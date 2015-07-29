### About This Project:

This is a place for me to learn how to work with diabetes blood
glucose data obtained from the
[Nightscout](http://www.nightscout.info/) Project.

> The blood sugar concentration or blood glucose level is the amount
> of glucose (sugar) present in the blood of a human or animal. The
> body naturally tightly regulates blood glucose levels as a part of
> metabolic homeostasis.
>
> [Wikipedia/Blood_sugar](https://en.wikipedia.org/wiki/Blood_sugar)

The source of the raw data is a [Dexcom](http://www.dexcom.com/)
[G4 Platinum System with Share](http://www.dexcom.com/dexcom-g4-platinum-share)
Continuous Glucose Monitor (CGM) worn by my wife, Karen, who has been
a Type 1 Diabetic (T1D) since she was seven. We are using an Android
app, [XDrip](https://stephenblackwasalreadytaken.github.io/xDrip/) to
collect the data from the CGM and upload it to a Nighscout
database. Her cloud-based CGM data drives a website which allows her
to track her CGM data on her phone and
[Pebble Watch](http://www.nightscout.info/wiki/labs/pebble_watchface_custom_alerts).

You *can* do all of this with an Apple Phone and Apple watch ($$$) or
you can DIY and build your own rig as we have. As of June 2015, the
Dexcom website does not list Android as a supported platform for
cloud-based CGM and there are no publicly announced plans to support
the Android platform, let alone the Pebble Watch. The applications we
are using are all open source and available to anyone who wants to
learn more about diabetes self-management (diabetic required). Unlike
the Apple-based system, the rig we are using is not FDA certified.

### Motivation:

My wife is the motivation behind this project. As a T1D, her body does
not produce insulin. This means her body cannot properly process or
control glucose (sugar) in her system. The following image is an
"ideal" glucose-insulin curve pattern I found on
[Wikipedia](https://en.wikipedia.org/wiki/Blood_sugar#/media/File:Suckale08_fig3_glucose_insulin_day.png).

![Normal Blood Glucose Curves](images/suckale08_fig3_glucose_insulin_day.png
 "Jakob Suckale, Michele Solimena - Solimena Lab and Review Suckale
 Solimena 2008 Frontiers in Bioscience PMID 18508724, preprint PDF
 from Nature Precedings, original data: Daly et al. 1998 PMID
 9625092")

Karen controls her blood glucose levels manually using an external
supply of insulin which is injected into her body via a "pump" she
wears at all times. Maintaining homeostasis requires external tools
and conscious maintenance. The CGMs compliment other methods of
measuring blood glucose levels, such as the classic finger-prick
method. The finger prick method is actuall more accurate than the CGM,
but is more involved and is done infrequently thoughout the day.

Continuous Glucose Monitors such as the Dexcom G4 are revolutionary
because they measure interstitial glucose levels roughly every 5
minutes. And they do so without the conscious aid or effort of the
diabetic. Using alarms to notify the T1D of lows and highs can improve
blood glucose control and simplify the life of the T1D. Correcting
glucose imbalances is still a conscious process, but CGMs do simplify
and automate part of the monitoring process.

Unfortunately, the accuracy of today's CGMs is below that of a
traditional blood glucose meter. The traditional blood glucose meter
(finger prick) measures the level of glucose in the blood
directly. CGMs do not. They measure the level of sugar in the
diabetic's interstitial fluid. Interstitial glucose levels are a
lagging indicator of blood glucose level. Thus, by the time the CGM
detects a change in the interstitial glucose levels, the diabetic may
already be quite high or quite low. This is especially true for
brittle T1Ds, like Karen, who can fluctuate rapidly.

With all that said, these things are _awesome_. The ability to get
near-real-time feedback is a game changer for diabetes self
management. Obviously, more accurate and sensitive sensors are
desired, but the current generation sensors are quite good. The
accuracy of a CGM is measured by something called a Mean Absolute
Relative Difference (MARD) between what it reads from the interstitial
fluid and what is measured by a lab blood glucose test. Dexcom claims
the 2015 "G4 Platinum with share" has a 9% MARD, which
[they claim](http://www.dexcom.com/dexcom-g4-platinum-performance) is
the first single digit MARD on the market. The previous generation
of device has a 13% MARD.

We (and many others fighting Diabetes every day) thank Dexcom for
making terrific hardware and we thank the makers of the
[XDrip](https://stephenblackwasalreadytaken.github.io/xDrip/) and
[Nightscout](http://www.nightscout.info/) projects for making great
software. If you are a diabetic and you want to take charge of how you
manage your health, this is the best way I know of to do it. You are
the one in charge, as it should be.

##### [#WEARENOTWAITING](https://twitter.com/hashtag/wearenotwaiting)

### Goals:

Karen's CGM takes a reading 12 times an hour, 24 hours a day. Ideally,
her system should produce nearly 300 readings a day and a little over
2,000 readings a week. That is a lot of data.

Conveniently, I am a professional data analyst working for the New
York State Department of Health. I am not a doctor or medical
professional. But I do evaluate health care programs. My day job is to
work with "big data" generated by the Medicaid program in New York
State. This data is generated by millions of people across the
State. My goal is to use the same skills I use in my day job to
develop new ways of looking at and evaluating Karen's CGM data.

For exploration and rapid prototyping, I will use R. Any useful ideas
will be discussed with the Nightscout developers. To measure my own
progress, a list of more discreet goals.

- *DONE:* Setup and manage the Nightscout Mongo database and
  website.
- *IN PROGRESS:* Learn how to effecively query the Mongo database.

    - I can pull down lots of data, but my ability to restrict my query to
      items of interest is still quite limited.

- *DONE:* Learn how to import Mongodb data into R. This seems harder
  than necessary.
- *DONE:* Export Nightscout data as a CSV file and place it into this
  repo. This will be an ongoing process.
- *DONE:* Use the Nightscout data to make some basic plots of blood
  glucose levels.
- *TODO:* Create a template report for Karen that allows us to assess
  her blood glucose levels over any arbitrary time frame.
- *TODO:* Finish reading [Sugar Surfing](http://sugarsurfing.com/).
- *TODO:* Use ideas from the book to improve our reporting and
  processing of Karen's CGM data.
- *TODO:* Look for patterns in Karen's CGM data that can be used to
  predict extreme highs and lows. This is important. CGMs measure
  interstitial glucose levels, which are lagging indicators of blood
  glucose levels. Because Karen often swings quickly, this can be a
  problem. Can I find patterns in the data that can help us see a
  change coming before it happens?
- *TODO:* If yes, how can I make the process of finding these patterns
  available to others? In other words, how can I make a generalized
  process (report, function, code, etc.) that can be used by anyone,
  to find and predict rapid fluctuations in blood glucose level BEFORE
  they happen.
- *TODO:* Publish a R package to make it easier for others to repeat
  what I come up with.

Obviously, I am assuming there is some way to do this. But I could be
wrong. If I am, I'll still learn something. At the very least, I will
produce some reporting tools that may be of use to others.

### Files:

- config.R: Manages project configuration.
- packages.R: Loads commonly required packages. Is run everytime
  config.R is run.
- get-cgm-data: Script to import CGM data from Nightscout. Creates the
  "data/entries.csv" file.
- first-cgm-graph.Rmd: RMarkdown which imports "entries.csv" and
  creates a simple graph of the CGM data.
- passwords.R: Contains Mongo passwords. It is not part of the
  repo. It is a simple script that assigns values to four
  variables. If you have a Mongo database, you should be able to
  reproduce this file easily. See get-cgm-data.R for more details.
- Makefile: GNU compatible Makefile that lets me "compile" this
  project.
- LICENSE: Feel free to use this, just don't violate the license.
