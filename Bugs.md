# "Bugs"

Not necessarily *actual* bugs in WM (though some are!), but also behavior-as-designed that is surprising or unexpected and needs to be worked around.

# wm_schedule

I'll bring in a sample watchface for this at some point, but briefly, I found this:

Consider a watchface, in which there is an element with a tap action which is set to this script:

    function toggle()
	   wm_transition('flip from right')
	end
	
	wm_schedule {action='run_function', run_function=toggle}
	
We would expect, on tapping the item, to see the "flip from right" transition.  But strangely enough, this only happens if the main watch script contains the string `wm_schedule` *anywhere* in it.  Even if it's a comment.  But if the script is empty, or lacks that magic word, the transition won't happen.  Adding a comment with `wm_schedule` in it will magically make things work.  Who would have guessed?

# Quoting issues

**This is an import issue to know about, since it can cause code that "used to work" suddenly to fail mysteriously, and be hard to debug!**

Quotes cause no end of headaches to programmers pretty much everywhere, and WM and lua are no exceptions.  It's compounded by the fact that WM treats strings in watch elements and strings in the watch script slightly differently, when it comes to "tags", the strings we use with \{\} around them to represent values provided by WM like \{dm\} and \{wssp\}.

**In watch elements**, WM textually substitutes the tag's value into the string before evaluating it with lua (if it decides it's a lua thing and needs to be evaluated).  This means that if you have a calendar event with a description of "Suzie's Birthday Party" and you are doing something like `string.sub('{c1t}',1,12)` to process it, you have a problem.  You *need* those quotes around the \{c1t\}, otherwise it's just some random letters thrown into the middle of lua code and won't make any sense. On the other hand, when WM evaluates it and *before lua sees it*, it will be changed into `string.sub('Suzie's Birthday Party',1,12)`.  Do you see the problem?  The extra apostrophe has closed the quote too early, and now lua won't be able to parse it, and it will probably just show the raw code instead.  Ugh.  You could fix it by using double-quotes instead of single-quotes around the string, but that just begs the issue of what happens if the string has double-quotes in it.  The fix is just below.

**In the watch script**, things are *slightly* different, and subject to even more mystifying problems.  Instead of substituting the value of the tag directly, WM substitutes an expression which will evaluate to the value of the tag when lua processes it.  Specifically, when you use `{dz}` in your script, WM substitutes `wm_tag('{dz}')` for it, before lua gets to see it.  So now, if you quote the `{dz}`, it will wind up evaluating to the *string* `wm_tag('{dz}')` and not what you expect it to (`EDT` or whatever).  So in the watch script, you must be careful **not** to quote WM tags at all!

## The Quote Fix

Lua has more than one way to indicate strings.  We know about using quotes and double-quotes, but there's another one too.  You can surround a string by *pairs* of square brackets, with any number of equals signs between them—and the number of equal signs have to match.  That means you can write a string like this: `[=[string]=]` or like this: `[==[string]==]`, or with any number of = signs (even none, but then you run into confusion with subscripting).  And what's key here is that if you start a string with `[==[` for example, the string *will not end* until it hits a close-mark that has *exactly* two equal signs.  So even if you might have a `]` or even a `]=]` in your string, it still won't close it prematurely.

Obviously, since a string coming in from the calendar or something could conceivably have *anything* in it, you still can't absolutely positively guarantee you won't have a problem, but I think we can agree that `]==]` or even `]=]` is a *lot* less likely to show up in someone's appointment book than apostrophes and quotes.  (If you're really paranoid, you can use some large number of ='s signs, making it even less likely to match random data.)

So, we can solve all our problems above by using this kind of quoting whenever we don't know what the tag in-between will evaluate to.  Most of the WM tags expand to fairly predictable things (`Charging`, `Cloudy`, `New York`, `EST`, `25°C`, etc).  Really the only likely offenders are the \{c\_t\} series.  Keep this in mind for others though, just in case something bizarre happens and you have trouble debugging it (maybe the weather is from `O'Hare` or something).  But for these tags, the `{c_t}` ones, make sure to quote with the brackets-and-equals method.  So you can say `string.sub([==[{c1t}]==], 1, 12)` with pretty good confidence that this won't run into quoting problems.  And if you're using Tasker variables, that might also contain anything, so you're better off with the bracket-style quoting.  And of course in the main watch script, you mustn't quote the tags at all, or they won't be evaluated.  Make sense?

# Table literals

Somewhat related to quoting problems: Watchmaker apparently does *not* like table literals in watch elements (though they're okay in the main script).  This may or may not affect you, depending on how much of a lua programmer you are, but if you ever work with tables, you may suddenly discover that what worked in the script doesn't work when you take it out into the watch.  I assume the issue is that table literals are set off by \{\} braces, which Watchmaker uses for its special tags, which get pre-processed in watch elements.

It probably isn't an issue for most people, and I guess if it is you can use a quickie function in the main script like this:

    function to_table(...)
        return {...}
    end

(Seriously, like that: actually type the three periods in a row and everything.)  Then you can use `to_table(1, 2, 8, 19, "x")` instead of `{1, 2, 8, 19, "x"}`.

# var_, var_s, and var_ms

I am a little hazy on the details of this myself, but I do know that it's bitten me a few times.  I'm not sure that every time I prevent this problem it would have otherwise happened, but definitely it needs to be addressed sometimes.

It starts with WM trying to figure out how to treat what you placed into a field in an element (like the text or x-coordinate or *most* (but not all) fields).  When you said you wanted the text to be `foobar` or `math.sin(42)`, does that mean you want the actual *string* `"foobar"` or `"math.sin(42)"`?  Or do you want lua to evaluate that and use the result, i.e., whatever value is in the `foobar` variable, or `-0.91652154791563`?  It could have been consistent, say, *always* to evaluate with lua, but that would mean that whenever you wanted just a plain string, you'd have to put it in quotes, and since that's a very common use-case, that would easily be missed and start to get confusing, especially to the large number of users who don't do that much programming—exactly the people who need as little confusion as possible.  So WM has to do a sort of balancing act, to try to guess whether or not you wanted lua to evaluate your string.

For the most part, its guesses are pretty good—once *you* know how to do your part in expressing things.  I don't know the precise rules, but generally speaking, it seems that certain patterns trigger lua-evaluation.  Stuff that looks like standard lua functions, like `math.rad(...)` or `string.sub(...)` seems to do it, and other pieces of syntax that somehow "look like" lua code.  And of course, if something fails to compile in lua, WM can fall back and treat it like a plain string instead (which you will sometimes see, like if you don't do quoting properly, as above).

One main thing that needs special handling is your user-defined variables and functions.  It's one thing to look for lua-like syntax when you know the lua reserved words and built-in functions.  But when you bring in what the user might have defined, you don't have anything to go on.  Technically *any* appropriately-shaped word (starts with a letter or \_, has only letters, numbers, and \_ in it) is a valid lua variable, and therefore a valid lua expression.  Should your text `"year"` be used as a string, or evaluated as the lua variable it is?  So the rule is that WM treats stuff that starts with `var_` as lua variables that have to be evaluated.  I guess the thinking is that you're unlikely to use text that has `var_` as the start of a word, unless you knew what you were doing (in which case, if you really wanted a word like that, you can just quote it.)

So that's why so many variables and functions in lua are named with `var_` at the start: because a variable named `color` won't get evaluated, but one named `var_color` will.  And the same is (probably) true of functions.  So you can name functions anything you want if they're only being called inside other functions, but ones that have to be "visible" to WM at the element level need the `var_` prefix.

## But why aren't my variables varying?

Most people seem to handle all the above complications more or less okay.  If something fails to be evaluated, slap a `var_` on it and try again, or just use `var_` all over the place, just in case, etc.  That's all fine, until one day you have a variable or something that *is* being evaluated, like you wanted, but doesn't seem to be *updated*.  That is, you know the program should be changing the value, but it isn't showing up changed on the screen.  This can be because WM takes another hint from the name of a variable.  A variable that just starts with `var_` is evaluated, but then WM might cache that value and not bother evaluating it again, assuming that value hasn't changed.  To signal to WM not to make that assumption, you need to use the prefix `var_s_`, which means that this value should be checked at least every second.  For something that's likely to change more often (something that moves/changes smoothly, for example), you have to use the `var_ms_` prefix, indicating that it is potentially subject to change every *milli*second.

I'm not completely sure how all this works.  By this reasoning, it doesn't sound like it would work to have a `var_face` variable control which of several "pages" or "modes" your watch is in.  After all, if it's on face 0 now, how does it know to re-evaluate it when you tap the "change mode" button?  But somehow that doesn't seem to be an issue.  Variables like that apparently work okay without a `var_ms_` prefix.  It seems more to be an issue of variables that change not as a result of an action, but due to the passage of time, something that is changed or set in an `on_second()` or `on_millisecond()` function.  Usually you discover this problem only when something you expected to update doesn't, and then you realize you need to change the prefix.  It's something to be aware of.

### Trick for forcing updates

Thanks to +Björn B for this trick: sometimes, particularly if you're trying
to debug something that's in a variable that was never supposed to be
exposed, you may want to force, somehow, a display to update a value that
doesn't have the magic components in the name.  A brilliant trick for this
is to do something like:

    blah + {ds}*0

See?  The variable is just whatever variable it is, the `+` sign makes WM evaluate it as a lua expression, and since the expression clearly depends on `{ds}`, it must have to re-evaluate it every second.  But of course, you're multiplying `{ds}` by zero, so it doesn't actually affect the results.  You would use `{dss}*0` to get millisecond updating, course. You might have to get creative to make this work for string values and stuff, but the idea is transferrable: work `{ds}` or `{dss}` into the expression and WM will evaluate it; multiply it by zero or otherwise nullify its actual contribution to make it easier to read.

## But the compass pointer *still* isn't working!

Oh, right.  This is an important one, that can drive you all-the-way nuts before you realize what's going on.  In order to conserve battery usage, WM doesn't bother checking high-battery and frequently-changing things like the accelerometer sensors, the gyroscope, the compass, etc. unless it figures you actually want it.  But it isn't always good about telling whether you want it.  If there are no *visible* elements (opacity at least 1) which have an attribute *directly* dependent on one of these sensors, the value won't update, *even if* it is used in `on_millisecond` or something like that.  So you have to put something that depends on whatever you're using directly in the watch.  It doesn't have to be big (make it size 1 or something, nobody will see it, especially if its opacity is also 1), but it has to be there.  A simple compass pointer or down-pointing pointer or something.

# Shaders

There seem to be some issues with shaders in WM generally.  When they work, they can do great things, but sometimes stuff just goes weird; I think these are bugs in WM.

* Using a shader (at least, I've seen this with the `Progress` shader) on a shape which has non-zero `skew_x`/`skew_y` values apparently doesn't always work quite right.  The shape does not wind up looking like you would expect.

* Using a shader (at least, I've seen this with the `Segment` shader) on a shape with a rapidly-changing color (i.e. a color value that changes on the millisecond level) appears to cause WM to crash after a few minutes.  (On the other hand, I think I've used the `Radial Gradient` shader with one of its values changing rapidly without problems.)

* I have heard a report that the `HSV` shader causes unusual battery drain; I have *not* confirmed this.

# Image colors (tints)

WM appears to have a bug that when an image's color is changed from `'ffffff'` (the usual value) by a script or code effect, the script cannot later change it back.  I've heard this is specific to colors like `'ffffff'` or `'000000'` or other "pure" colors.  I'm told that by using a tint like `'fffffe'` you can avoid this problem.

