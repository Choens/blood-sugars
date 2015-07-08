# Blood Sugar

> The blood sugar concentration or blood glucose level is the amount
> of glucose (sugar) present in the blood of a human or animal. The
> body naturally tightly regulates blood glucose levels as a part of
> metabolic homeostasis.^[https://en.wikipedia.org/wiki/Blood_sugar]

This repo is a place for me to explore how to work with diabetes blood
glucose data. This is a medical example of the
[quantified self](http://quantifiedself.com/) movement. The data
source is a [Dexcom](http://www.dexcom.com/)
[G4 Platinum System with Share](http://www.dexcom.com/dexcom-g4-platinum-share)
Continuous Glucose Monitor (CGM) worn by my wife, Karen, who has been
a Type 1 Diabetic (T1D) since childhood. We are using an Android app,
[XDrip](https://stephenblackwasalreadytaken.github.io/xDrip/) to
collect the CGM data from the CGM and upload it to a Nighscout
database. We are running a [Nightscout](http://www.nightscout.info/)
database and website which allows her to track her CGM data on her
phone and
[Pebble Watch](http://www.nightscout.info/wiki/labs/pebble_watchface_custom_alerts). All
of these applications are open source and available to anyone who
wants to learn more about diabetes self-management (diabetic
required).

As a T1D, Karen's body has lost the ability to produce insulin which
means her body cannot properly process glucose (sugar) in her
system. This means her body cannot maintain an appropriate level of
homeostasis, something the rest of us do naturally and without
conscious effort. Below is an ideal glucose-insulin curve pattern I
found on
[Wikipedia](https://en.wikipedia.org/wiki/Blood_sugar#/media/File:Suckale08_fig3_glucose_insulin_day.png).

![Normal Blood Glucose Curves](https://en.wikipedia.org/wiki/File:Suckale08_fig3_glucose_insulin_day.png#/media/File:Suckale08_fig3_glucose_insulin_day.png
 "Jakob Suckale, Michele Solimena - Solimena Lab and Review Suckale
 Solimena 2008 Frontiers in Bioscience PMID 18508724, preprint PDF
 from Nature Precedings, original data: Daly et al. 1998 PMID
 9625092")

Her body cannot do this without without an external supply of insulin
and manual correction. In the past, diabetics were required to
regularly prick a finger to measure their blood glucose levels and
make corrections. Our bodies maintain homeostasis without conscious
effort of assistance. For a diabetic, this is necessarily a conscious
process. Even with more continuos blood glucose data, corrections are
intermittent, rather than continuous.

Continuous Glucose Monitors such as the Dexcom G4 are revolutionary
because they monitor glucose levels at a regularly spaced interval,
usually 5 minutes, throughout the day. The diabetic must still make
manual, conscious corrections to maintain homeostasis, but at least
the monitoring is more automatic and continuous. Unfortunately, the
accuracy of today's CGMs is less than a traditional blood glucose
meter for two reasons. The traditional blood glucose meter (finger
prick) measures the level of glucose in the blood directly. CGMs do
not. They measure the level of sugar in the diabetic's interstitial
fluid. Interstitial glucose levels are a lagging indicator of blood
glucose level. Thus, by the time the CGM detects a change in the
interstitial glucose levels, the diabetic may already be quite high or
quite low. This is especially true for brittle diabetics who fluctuate
rapidly. And because CGMs do not directly measure actual blood glucose
levels, they must be calibrated several times a day.

With all that said, these things are awesome. The ability to get
near-real-time feedback is a game changer for anyone who has to live
with this every single day. Obviously, more accurate and sensitive
sensors are desired, but the current generation sensors are quite
good. The accuracy of a CGM is measured by something called a Mean
Absolute Relative Difference (MARD) between what it reads from the
interstitial fluid and what is measured by a lab blood glucose
test. Dexcom claims the G4 Platinum with share has a 9% MARD, which
they claim is the first single digit MARD on the
market^[http://www.dexcom.com/dexcom-g4-platinum-performance]. The
previous generation of this device has a 13% MARD. I don't have the
ability to test this claim myself, but I can say that Karen has been
very happy with this CGM and believes it is the best she has used to
date.

When this device was announced, diabetics were really excited about
the ability to send the sensor data to their phone and smart watch for
continuous monitoring and feedback. As of June 2015, Dexcom only
supports this feature in conjunction with the Apple iOS ecosystem of
devices. We don't have any of those devices but we do have a strong
DIY streak. We thank Dexcom for making terrific hardware and we thank
the makers of the
[XDrip](https://stephenblackwasalreadytaken.github.io/xDrip/) and
[Nightscout](http://www.nightscout.info/) projects for making great
software. This stuff is making a real difference.

If you are a diabetic and you want to take charge of how you manage
your health, this is the best way I know of to do it. You are the one
in charge, as it should be.

# Goals

Karen's CGM takes a reading 12 times an hour, 24 hours a day. Ideally,
her system should produce nearly 300 readings a day and a little over
2,000 readings a week. That is a lot of data.

Conveniently, I am a professional data analyst working for the New
York State Department of Health. I am not a doctor. I evaluate health
care programs. My day job is to work with "big data" generated by the
Medicaid program in New York State. My goal is to use my data analysis
skills to develop new ways of looking at and evaluating Karen's
diabetes.

For exploration and rapid prototyping, I will use R. Useful ideas will
be discussed with the Nightscout developers. To measure my own
progress, this is a list of more discreet goals.

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

# Files:

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
