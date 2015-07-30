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

*Note:* None of this code has been reviewed by the FDA. Use at your
own risk. If you find a bug, let me know. I welcome contributions. I
am not responsible for your health or diabetes management.

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
method. The finger prick method is actually more accurate than the
CGM, but is more involved and is done infrequently thoughout the day.

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
