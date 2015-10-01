# The Uneven Watch

The Uneven Watch is a watch I built to explore and study uneven rates of movement for watch hands, and became a way to study the "easing" transition functions which Watchmaker provides us.  It's pretty complicated to explain, though, so it really needs this auxiliary page.

It looks pretty innocent when you first put it on.  Very plain, unimaginative color scheme (sorry about that), perfectly standard watch-face.  It is a little cool in that it detects if you have a "flat tire" watchface and if so it adjusts the tick-marks on the bottom to accomodate.  It becomes useful/important to be able to watch the hands actually get to the tick-marks, and I didn't want to be missing that at the bottom of the screen.  There is a slightly lighter-grey circle in the background, and the size of its top half indicates your watch battery, and the bottom half your phone battery.  The excitement starts when you tap the center.

## The Configuration Screen

Up pop the configuration elements.  They're a little cryptic, and also tricky to tap right, so be careful.  To understand the configuration, you need to understand the design of the watchface.

The idea is that over each "part" of the watchface (dividing the watch into an equal number of "parts"), the hands (all of them) don't necessarily move evenly ("linearly"), but their speed is governed by another function.  The functions in question can be found in [the WatchMaker documentation](http://watchmaker.haz.wiki/lua#tweening_functions), which has graphs for them all, etc.  Each one is a function that starts at "0" and ends at "1", following some path between them.  I put "0" and "1" in quotes because the start and end could be anything: the point is how it travels between them.  So the hands might traverse each quarter of the watch (that would be the "part") using the "outQuint" function, which starts out moving fast and then slows down (like almost all the other "out-" functions; the difference is in how quickly they slow down).  The tickmarks on the watch would adjust accordingly, so between any two tickmarks it's still one minute for the minute hand and one second for the second hand, even though some of the ticks are closer together than others.

The configuration face is all about choosing which tweening function and how the "parts" are figured.  Just below the center is the element for choosing which function (or rather, which family of functions) you're going to use.  At first, it's set to "linear", which is the same in all configurations and works like a plain watch face.  Tap on that word to cycle through all the choices: "linear", "Sine", "Quad", "Cubic", "Circ", "Quart", "Quint", "Expo", "Back", "Bounce", "Elastic".

In Watchmaker, each of these functions comes in four flavors: "in", "out", "inOut", and "outIn".  Tap the element above the center of the watch, which starts out as "In", to toggle between "In" and "Out" for the "in" and "out" variants.  The other two variants, "inOut" and "outIn", are combinations of these: "inOut" is "in" followed twice as fast and half as high until the midpoint, followed by "out" starting from there and going the rest of the way.  Or equivalently, "in" followed by a mirror-image "in".  To get these, use the "Mirrored" element below the function-selector.  Note that it's on (yellow) by default, so when you were selecting "In" you were really getting "inOut".  (The watch doesn't actually use the inOut or outIn functions; internally, it runs the "in" or the "out" halfway forwards and then halfway backwards, but it's the same thing.)  When the Mirrored feature is off (grey), you can get the plain "in" and "out" variants.

When using most of these functions, even a fairly modest one like inOutSine, the hands will still come to a complete *stop* at the end of the "part".  That's because the derivative at the ends goes to zero, so there's a pause between getting to the end and starting again, and that can be disconcerting.  So you can "mix in" a linear signal to the function.  You might want function that moves the hands to be, say, 30% linear, and 70% the tweening function, to get a little bit of positive movement even at the ends. That's what the "+lin 0%" at the bottom represents: by default, 0% of the function comes from the linear mix-in; it's all tweening function.  Tap the "+" sign to the right of it to increase the percentage of linear mix-in by 5%; tap the "-" sign to the left of it to decrease it by 5%.

Finally, there's the element at the top, for defining the "parts."  By default, a "part" is 15 minutes (or seconds, depending on the hand.  Or three hours, for the hour hand.  We'll speak in terms of minutes.)  That is, one-quarter of the watchface.  The tweening function (possibly mirrored, possibly with linear mix-in) is repeated four times around the dial, starting at 12:00.  By tapping the "+" and "-" signs to either side of the figure, you can change the size of the "part" to any of these sizes that evenly divide the dial: 1, 5, 10, 15, 20, 30, or 60 minutes (the last being the whole dial).

Whenever you change a parameter, the hands will jump to the position they should be in for that time of the hour according to the function and part-size you've chosen.  Also, the hour and minute tick-marks will redistribute themselves around the circle appropriately too.  Note that when your part-size is 5 minutes (or 10 minutes if the function is mirrored), the hour-marks will all be exactly where they normally are--it's the minutes between them that change.  And of course if your part-size is 1 minute, then even the small minute-ticks will be in their usual places.  It's the hands' action between them that changes.

Did I say "finally" above?  There's another setting, a little harder to see: a faint dark star between the center and 9:00 (on an ordinary watch).  Tap that, and it becomes outlined, and another set of hands appear--very faintly.  These dark "shadow hands" keep the same time as the regular hands, only they move like hands on a normal clock.  That is, they move as if the hour and minute marks were all in their usual places, they move with the same speed throughout the hour, etc.  This is fun to watch, to see how they differ from where your regular hands are, and how the normal-looking hands fall behind and race ahead of them (especially fun to watch the second hands).

When you're done messing with the settings, tap the purple "DONE" word on the right side of the watch to make all the setting elements disappear.

I suppose there could be some "sensible" uses of this watch.  For example, sometimes people like to think of time in terms of 5-minute (or even 10 or 15 minute) bites, and would rather hear "quarter after five" than "five sixteen", etc.  By using one of the higher-curved inOut functions, you get hands that spend most of their time at the ends of the part (at the hour-markers, or at the quarter-hours if your part is 15 minutes long, etc), and zip through the area in-between comparatively quickly.

Note also that a few of the functions are particularly... weird.  There's the "Back" family, which is shaped *mostly* like the others, except that it slightly overshoots at the end (for "in"), and/or pulls back at the beginning (for "out").  This can get you hands moving counterclockwise briefly, and conceivably have tick-marks that are visited in the "wrong" order.

They only get weirder after that.  The "Bounce" functions go from "0" all the way to "1" (in the "in" direction) quite quickly... and then bounce back partway... and fall back to "1"... and bounce again... etc.  Obviously, this will produce really weird arrangements of ticks and numbers, and strange paths for the hands.  The "Elastic" family is similarly strange, as it significantly overshoots the end value (in "out" direction), and then wobbles back to settle there after a few oscillations.

So, that's it.  The face is for studying these tweening functions, or making all kinds of uneven-paced faces.  Want to see "logarithmic" time?  Use an unmirrored Expo function with a part-size of 60min, for example.  And so on...  Have fun with it!!