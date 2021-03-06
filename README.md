# WMresources
Resources for users of the WatchMaker program for Android

I hope to collect some useful programming tips, actual pieces of code, images, and other tools for WatchMaker users.  This project is *always* a work in progress.  Please feel free to contribute, either via email or via github cloning and forking, etc.

This README file will, I hope, be expanded in the future.

Unless otherwise specified, content here is by Mark Shoulson.  Permission is explicitly GRANTED to use anything here for any purpose, commercial or not, and to repost it anywhere you'd like (unless otherwise specified).  But please, please credit the author(s).

## Things in this Repository

(non-exhaustive)

* [Some lua programming tips](Tips1.md)
* [The table of all Time Zones and their offsets!](TZs.lua)
* [The same table, all in one line](TZs1.lua)
* [Lua library for the Hebrew Calendar](HebCal.lua)
* [Lua library for the Islamic Calendar](IslCal.lua)
* [Some graphic elements that might be useful](Elements/)
* [A font of geometric shapes](WatchGeometries.ttf), and also the
  [source code for it](WatchGeoms.sfd) (for Fontforge)
  * A tip I discovered in using it: to make a shape from the WatchGeometries font that's just (about) X by Y pixels (plus some line-width), set the font-size to *80*, and then set the `anim_scale_x` and `anim_scale_y` values to X and Y respectively.
