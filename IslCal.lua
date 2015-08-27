--[==[
Calculations for the Islamic Calendar
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

-- I am less familiar with the Islamic calendar than I am with the Jewish
-- calendar, so caveat emptor.  The calculations from this file seem to
-- match up with other calculations.

IslEpoch=227015

function isl_ly(y)
    local yy=y%30
    return yy==2 or yy==5 or yy==7 or yy==10 or yy==13 or yy==16 or yy==18 or yy==21 or yy==24 or yy==26 or yy==29
end

function isl_last_day(m, y)
    if m==1 or m==3 or m==5 or m==7 or m==9 or m==11
	then return 30
    elseif m==2 or m==4 or m==6 or m==8 or m==10
	then return 29
    elseif isl_ly(y)
	then return 30
    else
	return 29
    end
end

function isl_day_number(m, d, y)
   return 30 * math.modf(m/2) + 29 * math.modf((m-1)/2) + d
end


function isl_to_fixed(month, day, year)
   local y=year%30
   local ly_in_cycle

   if y<3 then ly_in_cycle=0
   elseif y<6 then ly_in_cycle=1
   elseif y<8 then ly_in_cycle=2
   elseif y<11 then ly_in_cycle=3
   elseif y<14 then ly_in_cycle=4
   elseif y<17 then ly_in_cycle=5
   elseif y<19 then ly_in_cycle=6
   elseif y<22 then ly_in_cycle=7
   elseif y<25 then ly_in_cycle=8
   elseif y<27 then ly_in_cycle=9
   else ly_in_cycle=10
   end

   return (isl_day_number(month, day, year) + (year-1)*354 +
	      math.modf(year/30)*11 + ly_in_cycle + (IslEpoch-1))
end

function isl_from_fixed(d)
    local approx=math.modf((d-IslEpoch)/355)
    local year=approx
    local month
    local day
    local y
    local m

    if d < IslEpoch then return nil end

    y=approx
    while d >= isl_to_fixed(1, 1, y+1)
    do
       year=year+1
       y=y+1
    end
    month=1
    m=1
    while d > isl_to_fixed(m, isl_last_day(m, year), year)
    do
       month=month+1
       m=m+1
    end
    day=d-(isl_to_fixed(month, 1, year)-1)
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

-- Names taken from emacs-lisp file; no guarantees regarding transliteration.

var_isl_monthnames={"Muharram", "Safar", "Rabi I", "Rabi II", "Jumada I", "Jumada II", "Rajab", "Sha'ban", "Ramadan", "Shawwal", "Dhu al-Qada", "Dhu al-Hijjah"}
