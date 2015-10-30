# Some Watchmaker Coding Tips

A few coding tips I have found helpful; maybe you will to.

# Polar Coordinates

If you know how far something is from the center (say, the radius of your watch dial), and what angle it's at (say, the second-hand rotation value), and need to translate that into X and Y coordinates (e.g., moving a shape around as a second hand), you'll need these formulæ. It's handy to define functions for them in the main watch script:

    function var_x(r, theta) return  r*math.sin(math.rad(theta)) end
	function var_y(r, theta) return -r*math.cos(math.rad(theta)) end
	
Don't forget the `math.rad` part  This is a common mistake, because it's easy to forget, and then you get mystifying results.  The lua trigonometry functions (sin, cos, etc.) operate on radians, while WM (and most people) measures angles in degrees.  The `math.rad()` function converts degrees to radians.  If you need to convert from radians to degrees (say, after using an arctan function), multiply by 180/math.pi`.

# The % Operator

This is probably the most useful but underused operator. It very often happens that we want something to count up... but only to a certain point, and then start again at the bottom. Like cycling through screens, or colors. I see lots of code with things like `var_x=var_x+1 ; if var_x==10 then var_x=0 end`... it's a waste. We have an operator that does this for us already

The % sign is the modulus operator. Basically, A%B means “the remainder when A is divided by B”, or equivalently, “the number that you get when you subtract B from A repeatedly until you get a non-negative number less than B.” This is exactly what you need for this kind of thing:

    var_x=(var_x+1)%10
	
This counts up from 0 to 9, and back to 0. In lua (unlike most other languages), we are frequently counting from 1 to n, not 0 to n-1, so the formula would be a little different for the 1 to n case:

    var_x=var_x%10+1
	
Don't use those long-winded functions; it's just clunky.

# Toggling

Similarly, you shouldn't need a function to toggle a variable between two values. You shouldn't have to say `if var_x==1 then var_x=0 else var_x=1 end` or something (assuming `var_x` is always either 0 or 1). This is sufficient:

    var_x=1-var_x
	
You can modify that if you're toggling between 1 and 2 (`var_x=3-var_x`) etc. If you're using a boolean variable (one that is either true or false, not a numerical value), you can just say:

    var_x=not var_x
	
(and whatever you do, don't say things like "`if var_x==true`" or "`if var_x==false`". Just "`if var_x`" and "`if not var_x`". Testing a boolean for equality to true/false is redundant.)

# math.max() and math.min()

These are good to know about on general principles, and have particular applications in hand movements.  The `math.max()` function simply returns the largest of its arguments, however many there are, and `math.min()` returns the smallest.  This is useful when you want to “cap” a value so it doesn't exceed or fall below a certain value, even when the usual calculation for it would move it past.  So for example (a little contrived), if you wanted a smooth second hand that went around the dial in only 55 seconds and then stopped at 12:00 for 5 seconds until the next minute started, you might try setting the rotation to "`{drss}*60/55`", but then the hand wouldn't stop at 12:00, it would carry on for another 5 seconds and then snap back at the top of the minute.  But "`math.min(360, {drss}*60/55)`" would work: the value would be capped at 360.  Using `math.max(0, something)` is good for making sure the result never goes negative.

# string.format Shorthand

Just a shorthand I found that can save you some keystrokes if you use string functions a lot, especially string.format. Instead of “`string.format(“%s %d:%02d”, var_a, var_b, var_c)`” for example, you can say:

    (“%s %d:%02d”):format(var_a, var_b, var_c)
	
Note the syntax: the format string in quotes inside parens, then a *colon*, then “`format`”, and the parameters in parens. I don't actually know why the parens around the format string are necessary; I would not think they would be. I'm sure they aren't needed if the format is not a literal string (e.g. it's a variable).

You can also use this trick if you make use of the `string.sub` function. Instead of `string.sub(var_s, 2, 4)`, you can say `var_s:sub(2, 4)` (no need for extra parens here because it isn't a literal string.)

# Interpolation

This is the cause of perhaps the majority of posts asking for math help on the forum.  You need to move a pointer between two points on a line to display the hours or battery level.  Or maybe you need to rotate a hand on a dial for minutes, but it isn't a standard 360° dial, but rather only part.  Or anything like that.

Basically, the problem is this: you have some "input" number coming in, and you need to convert it to some "output".  The input is going to be in some range, say between numbers *lo* and *hi*.  You want the output to be also in some range of numbers, say *LO* and *HI* (note that *HI* is not necessarily actually bigger than *LO*), so that when the input is *lo*, the output is *LO*, and when the input is *hi* the output is *HI*, and when it's halfway between them it's halfway between, and when it's a quarter of the way between then it's a quarter of the way between in the output too, and so on.  This is the magic formula you need for all cases like this.  If the number coming in is *x*, then in order to find the output, you compute:

        LO + (x-lo)/(hi-lo) * (HI-LO)

Read it again, it's important.

So say you have a dial for minutes that's only an arc, say between 120° and 250°, so that at 0 minutes the rotation should be 120° and at 60 minutes it should be 250° (it never will be 60 minutes, only up to 59, but it's simpler to understand this way, and this will also come in handy if you wind up dealing with fractions of a minute, since then you can have numbers bigger than 59).  What should be the rotation for the hand?

        120 + {dm}/60 * (250-120)

Since *lo* is zero in this case, things are a little simpler.  And of course you could simplify (250-120) into 130, but you certainly don't have to, and maybe it's clearer to read if you don't.

Now let's say you don't want it to jump between minutes, it should move more smoothly, taking fractional minutes into account.  You could compute the fractional minutes yourself, but it's easier just to use a variable WM already gives you: \{drm\}.  That's the rotation of the minute hand, adjusted for seconds.  Since it's the *rotation* of the minute hand and not the measure of minutes, its *hi* value is actually 360, not 60.  And we get:

        120 + {drm}/360 * (250-120)

This formula is what you need most of the time you're looking for a special rotation or something.

(P.S. This might wind up doing something unexpected if you plug it in without thinking.  If your arc crosses the Y-axis, say between 290° and 30°, things will probably wind up in the wrong direction if you plug the numbers in blindly.  You could try using -70 instead of 290.  Another option would be to work it out as if it's between 0 and 100 and then subtract 70 (or add 290 modulo 360) afterward.)

# Auto-flash

This is something I found handy for cases when I wanted a layer to “flash”, i.e. turn on for a few seconds and then automatically turn off. It can also be used for moving things someplace and then back again, etc. You can do this with `wm_schedule` by scheduling a “sleep” action between two things or something, but somehow I'd rather avoid having a bunch of things in the queue. This feels more like a “set-and-forget”

To trigger the flash (say, in a tap action):

    wm_schedule {action='tween', tween='x', from=-100, to=100, duration=4, easing=outInExpo }
	
You can use any other tween (instead of 'x'), and the duration is in seconds of about how long the flash is to last. Then, in the opacity of the layer that's going to flash:

    100-math.abs(tweens.x)

Or if you want it flash *off*, use just “`math.abs(tweens.x)`”.  Either way, you'll need to initialize (set) `tweens.x` in the main script somewhere.

This works because we're using the tween to “slide” the value between -100 and 100, using the outInExpo function. Thing is, the outInExpo function spends almost all of its time just about in the middle of its range, and very little time approaching and leaving it. So the value is around zero for most of those four seconds. By using math.abs() (absolute value), we get something that goes from 100 to 0, stays there a while, and comes back to 100.

# Second Hand Movement

The usual choices for moving the second hand are either by jumps each second or smoothly.  Both are nice, but there are other options.  Probably the nicest I've seen so far is setting the rotation to

    {drss}+math.sin(math.rad({drss}*60))-3
	
which gives a pleasing “smooth-step” motion: rest on the second-tick for a moment, smoothly move to the next one, subtly speeding up to start and slowing down to stop.  This function works by superimposing a 60-per-minute (1 Hz) sine curve “ripple” on top of the smooth seconds motion.  The “pause” happens because part of the “ripple” is a backward motion that cancels out the forward smooth motion.  There are some other possibilities too, though the differences might be very subtle.  (The rest of this section gets a little involved; you can copy code directly if you like, but there's also an attempt to explain it so you can craft your own.)  For example, something where the second hand remains on its tick for half a second, and then over the next half-second moves at constant speed (unlike above, where it eased into and out of its motion) to the next tick, you could use

    {drs}+math.max(0, ({dss}/1000-0.5)*12)
	
Note the use of `math.max()`.  We're taking `{dss}/1000` (the fractional part of the second), subtracting one-half (so it's negative for the first half and goes up only to ½), multiplying by 12 (it has to move six degrees between ticks, but we're not using the first six) and then using math.max()` to “clamp” the value so it doesn't go below zero, i.e. the first half-second doesn't do anything.

We can really go more general, and use any of the “easing” functions that Watchmaker provides.  See http://watchmaker.haz.wiki/lua#tweening_functions for graphs of these.  They're various ways you can move something from zero to one (or any two values) smoothly, but not necessarily evenly: maybe faster at the beginning, maybe slower, etc.  Most of them are variations on the same shape, just sharper or gentler (I can't think of a case where I would use `inOutCubic` but not `inOutQuad`.  Who would really notice the difference?)  So you might like to use one of the Back functions, which “overshoots” slightly, e.g.

    {drs}+inBack({dss}, 0, 6, 1000)
	
which will seem to pull back slightly before going to the next second.  Or maybe move only in the second half of the second, as above, and this time overshoot the destination instead of pulling back before starting:

    {drs}+outBack(math.max(0, {dss}-500), 0, 6, 500)

These easing functions are a little strange to use directly; you have to remember their parameters: 1) where are we now (input)? 2) what's the starting output? 3) what's the change from starting to ending output? 4) what's the ending input?

# Lap Time

A lot of watches have a stopwatch feature, and a lot of (real) ones have a “lap time” or “split time” feature, which is often missing in Watchmaker re-creations, and that's a shame.  The usual convention works as follows: you press START/STOP, and the stopwatch starts or stops.  If you hit LAP/RESET while the stopwatch is running, the *display* (or the postion of the hands) freezes, so you can record the time it took up to this point (this lap), but the timer itself *keeps running*.  When you hit LAP/RESET again, the display/hands is released and jumps forward to the current time.  You can hit START/STOP while the display/hands is frozen with LAP/RESET, in which case the timer stops, and when you release the display/hands it jumps forward to wherever it stopped, but isn't still running.  To actually reset the stopwatch, you hit LAP/RESET while the timer is actually stopped.  (All this sounds complicated, but it isn't a Watchmaker thing; this is how most real-life stopwatches work.)

There are a lot of ways of representing stopwatches, so we can't explore them all.  For this example, we'll assume you are doing a stopwatch with dials: one for (smooth) seconds (rotation `{swrss}`) and one for minutes (rotation `{swrm}`).   To make lap timing work as described above, set the stopwatch  second-hand rotation to

    var_lap_sr or {swrss}

and the stopwatch minute-hand  rotation to

    var_lap_mr or {swrm}
	
You can use other variable names.   Then, instead of “Stopwatch:reset” as the tap action for the  LAP/RESET button, set it to this script:

    if var_lap_sr
    then
	    var_lap_sr=nil
		var_lap_mr=nil
	else
	    if {swr}
		then
		    var_lap_sr={swrss}
			var_lap_mr={swrm}
		else
		    wm_action('sw_reset')
		end
	end
	
Looks a little long, but once you have it you can copy and paste it around.  The idea is, if the hands are frozen, free them.  Otherwise, if the stopwatch is running, freeze the hands, and if it isn't running, reset the stopwatch.

You can do something similar with a digital stopwatch; use just one variable, set it to the string you want displayed in the field and do the same thing in the field with the variable “or” the current string.

# Gravity

Somewhere along the line, you're likely to want to have something rotate with gravity, so it always points down (or up). The formula isn't complicated, but it's one more thing to remember, so here it is, for reference.  Just set the rotation to:

    math.atan2({sax}, {say}) * 180/math.pi
	
# Reversing Text

Something I just noticed, probably good to jot it down so I don't forget it: if you want to have mirror-imaged text for some bizarre reason, you can do it by setting the `anim_scale_x` to -100.  *But* you can't do this with the arrows; you have to go into the field and edit it.

To reverse an image, you can do much the same thing: set its width to be the *negative* of its actual width (or its height to be the negative of its height, if you want it flipped vertically).

# Variables

This is something they teach you when programming: if you're using a number in a lot of places, set a variable to it and then use the variable.  That way, if you change the number, you don't have to track down all the places it was used.  This is handy in many places in WM.  I often declare a variable `var_r` to be the radius of my clock face, and other things depend on it.  To make the face smaller or larger, I can just change `var_r` in the script file and the whole face automagically remakes itself the right size.  Try it when you have something like the radius, or maybe a landmark position that affects many other things.  Variables are your friends.

# Version

An important thing to know: the version of lua used in WM (at the time of writing) is Lua 5.1.  You can find out by making a text element with the value `("%s"):format(_VERSION)`.
