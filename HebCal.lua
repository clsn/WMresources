--[==[
Calculations for Hebrew dates and temporal hours.
Calendar math from Edward M. Dershowitz and Nachum Reingold,
see http://emr.cs.uiuc.edu/~reingold/calendar-book/index.html
Translated into Lua from emacs-lisp by Mark Shoulson, mark@shoulson.com

The MIT License (MIT)

Copyright (c) 2015 Mark E. Shoulson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]==]



heb_epoch=-1373427
function heb_leap_year(n)
    return (1+7*n)%19 < 7
end

function heb_last_month(y)
    if heb_leap_year(y)
	then
	    return 13
	else
	    return 12
    end
end

function heb_last_day(m, y)
    if m==2 or m==4 or m==6 or m==10 or m==13 or
	m==12 and not heb_leap_year(y) or
	m==8 and not heb_long_heshvan(y) or
	m==9 and heb_short_kislev(y)
	then return 29
	else return 30
    end
end

function heb_elapsed(y)
    local monthelapsed=math.modf((235*y-234)/19)
    local partselapsed=12084+13753*monthelapsed
    local day=29*monthelapsed + math.modf(partselapsed/25920)
    if 3*(day+1)%7 < 3
	then day=day+1
    end
    return day
end

function heb_ny_delay(y)
    local ny0=heb_elapsed(y-1)
    local ny1=heb_elapsed(y)
    local ny2=heb_elapsed(y+1)

    if ny2-ny1==356
	then return 2
	else if ny1-ny0==382
	    then return 1
        end
    end
    return 0
end

function heb_days_in_year(y)
    return heb_to_fixed(1+y, 7, 1) - heb_to_fixed(y, 7, 1)
end

function heb_long_heshvan(y)
    return heb_days_in_year(y)%10 == 5
end

function heb_short_kislev(y)
    return heb_days_in_year(y)%10 == 3
end

function heb_to_fixed(y,m,d)
    local rv;
    local mm;
    rv = heb_epoch + heb_elapsed(y) + heb_ny_delay(y) + d - 1
    if m < 7
	then
	    mm=7
	    while mm <= heb_last_month(y) do
		rv = rv + heb_last_day(mm, y)
		mm = mm + 1
	    end
	    mm=1
	    while mm < m do
		rv = rv + heb_last_day(mm, y)
		mm = mm + 1
	    end
	else
	    mm=7
	    while mm < m do
		rv = rv + heb_last_day(mm, y)
		mm = mm + 1
	    end
    end
    return rv
end
	    
function heb_from_fixed(d)
    local approx = math.modf((d - heb_epoch)/365.25)
    local year = approx -1
    local start
    local month
    local day
    local y

    y=approx
    while d >= heb_to_fixed(y, 7, 1) do
	year = year + 1
	y = y + 1
    end
    if d < heb_to_fixed(year, 1, 1)
	then start = 7
	else start = 1
    end
    
    month=start
    while d > heb_to_fixed(year, month, heb_last_day(month, year)) do
	month = month + 1
    end

    day = 1 + d - heb_to_fixed(year, month, 1)
    return ({year=year, month=month, day=day})
end

function greg_jd_to_fixed(y, jd)
    local rv
    rv = (y-1) * 365
    rv = rv + math.modf((y-1)/4)
    rv = rv - math.modf((y-1)/100)
    rv = rv + math.modf((y-1)/400)
    rv = rv + jd
    return rv
end

var_monthnames={"Nisan", "Iyar", "Sivan", "Tammuz", "Av", "Elul",
    "Tishrei", "Marcheshvan", "Kislev", "Tevet", "Shvat", "Adar", "Adar II"}


var_s_temporal= ({dtp}-{wsrp})/({wssp}-{wsrp})
var_s_tempnight=({dtp}>{wssp} or {dtp}<{wsrp})
function on_second(dt)
   var_s_tempnight=({dtp}>{wssp} or {dtp}<{wsrp})
   if var_s_tempnight
   then
      if {dtp}>{wssp}
      then
          var_s_temporal= math.abs(({dtp}-{wssp})/(1+{wsrp}-{wssp}))
       else
          var_s_temporal= math.abs(({dtp}+(1-{wssp}))/(1+{wsrp}-{wssp}))
       end
   else
      var_s_temporal= ({dtp}-{wsrp})/({wssp}-{wsrp})
   end
end
