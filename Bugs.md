# "Bugs"

Not necessarily *actual* bugs in WM (though some are!), but also behavior-as-designed that is surprising or unexpected and needs to be worked around.

## wm_schedule

I'll bring in a sample watchface for this at some point, but briefly, I found this:

Consider a watchface, in which there is an element with a tap action which is set to this script:

    function toggle()
	   wm_transition('flip from right')
	end
	
	wm_schedule {action='run_function', run_function=toggle}
	
We would expect, on tapping the item, to see the "flip from right" transition.  But strangely enough, this only happens if the main watch script contains the string `wm_schedule` *anywhere* in it.  Even if it's a comment.  But if the script is empty, or lacks that magic word, the transition won't happen.  Adding a comment with `wm_schedule` in it will magically make things work.  Who would have guessed?

## Quoting issues

**This is an import issue to know about, since it can cause code that "used to work" suddenly to fail mysteriously, and be hard to debug!**

Quotes cause no end of headaches to programmers pretty much everywhere, and WM and lua are no exceptions.  It's compounded by the fact that WM treats strings in watch elements and strings in the watch script slightly differently, when it comes to "tags", the strings we use with \{\} around them to represent values provided by WM like \{dm\} and \{wssp\}.

**In watch elements**, WM textually substitutes the tag's value into the string before evaluating it with lua (if it decides it's a lua thing and needs to be evaluated).  This means that if you have a calendar event with a description of "Suzie's Birthday Party" and you are doing something like `string.sub('{c1t}',1,12)` to process it, you have a problem.  You *need* those quotes around the \{c1t\}, otherwise it's just some random letters thrown into the middle of lua code and won't make any sense. On the other hand, when WM evaluates it and *before lua sees it*, it will be changed into `string.sub('Suzie's Birthday Party',1,12)`.  Do you see the problem?  The extra apostrophe has closed the quote too early, and now lua won't be able to parse it, and it will probably just show the raw code instead.  Ugh.  You could fix it by using double-quotes instead of single-quotes around the string, but that just begs the issue of what happens if the string has double-quotes in it.  The fix is just below.

**In the watch script**, things are *slightly* different, and subject to even more mystifying problems.  Instead of substituting the value of the tag directly, WM substitutes an expression which will evaluate to the value of the tag when lua processes it.  Specifically, when you use `{dz}` in your script, WM substitutes `wm_tag('{dz}')` for it, before lua gets to see it.  So now, if you quote the `{dz}`, it will wind up evaluating to the *string* `wm_tag('{dz}')` and not what you expect it to (`EDT` or whatever).  So in the watch script, you must be careful **not** to quote WM tags at all!

## The Quote Fix

Lua has more than one way to indicate strings.  We know about using quotes and double-quotes, but there's another one too.  You can surround a string by *pairs* of square brackets, with any number of equals signs between them—and the number of equal signs have to match.  That means you can write a string like this: `[=[string]=]` or like this: `[==[string]==]`, or with any number of = signs (even none, but then you run into confusion with subscripting).  And what's key here is that if you start a string with `[==[` for example, the string *will not end* until it hits a close-mark that has *exactly* two equal signs.  So even if you might have a `]` or even a `]=]` in your string, it still won't close it prematurely.

Obviously, since a string coming in from the calendar or something could conceivably have *anything* in it, you still can't absolutely positively guarantee you won't have a problem, but I think we can agree that `]==]` or even `]=]` is a *lot* less likely to show up in someone's appointment book than apostrophes and quotes.  (If you're really paranoid, you can use some large number of ='s signs, making it even less likely to match random data.)

So, we can solve all our problems above by using this kind of quoting whenever we don't know what the tag in-between will evaluate to.  Most of the WM tags expand to fairly predictable things (`Charging`, `Cloudy`, `New York`, `EST`, `25°C`, etc).  Really the only likely offenders are the {c\_t\} series.  Keep this in mind for others though, just in case something bizarre happens and you have trouble debugging it (maybe the weather is from `O'Hare` or something).  But for these tags, the `{c_t}` ones, make sure to quote with the brackets-and-equals method.  So you can say `string.sub([==[{c1t}]==], 1, 12)` with pretty good confidence that this won't run into quoting problems.  And if you're using Tasker variables, that might also contain anything, so you're better off with the bracket-style quoting.  And of course in the main watch script, you mustn't quote the tags at all, or they won't be evaluated.  Make sense?
