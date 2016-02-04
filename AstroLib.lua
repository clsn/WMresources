var_TZs= { A= 1.0, ACDT= 10.5, ACST= 9.5, ACT= -5.0, ACWST= 8.75, ADT= 3.0, ADT= -3.0, AEDT= 11.0, AEST= 10.0, AFT= 4.5, AKDT= -8.0, AKST= -9.0, ALMT= 6.0, AMST= -3.0, AMST= 5.0, AMT= -4.0, AMT= 4.0, ANAST= 12.0, ANAT= 12.0, AQTT= 5.0, ART= -3.0, AST= 3.0, AST= -4.0, AWDT= 9.0, AWST= 8.0, AZOST= 0.0, AZOT= -1.0, AZST= 5.0, AZT= 4.0, AoE= -12.0, B= 2.0, BNT= 8.0, BOT= -4.0, BRST= -2.0, BRT= -3.0, BST= 6.0, BST= 11.0, BST= 1.0, BTT= 6.0, C= 3.0, CAST= 8.0, CAT= 2.0, CCT= 6.5, CDT= -5.0, CEST= 2.0, CET= 1.0, CHADT= 13.75, CHAST= 12.75, CHOT= 8.0, CHUT= 10.0, CKT= -10.0, CLST= -3.0, CLT= -3.0, COT= -5.0, CST= -6.0, CVT= -1.0, CXT= 7.0, ChST= 10.0, D= 4.0, DAVT= 7.0, DDUT= 10.0, E= 5.0, EASST= -5.0, EAST= -5.0, EAT= 3.0, ECT= -5.0, EDT= -4.0, EEST= 3.0, EET= 2.0, EGST= 0.0, EGT= -1.0, EST= -5.0, F= 6.0, FET= 3.0, FJST= 13.0, FJT= 12.0, FKST= -3.0, FKT= -4.0, FNT= -2.0, G= 7.0, GALT= -6.0, GAMT= -9.0, GET= 4.0, GFT= -3.0, GILT= 12.0, GMT= 0.0, GST= 4.0, GST= -2.0, GYT= -4.0, H= 8.0, HADT= -9.0, HAST= -10.0, HKT= 8.0, HOVT= 7.0, I= 9.0, ICT= 7.0, IDT= 3.0, IOT= 6.0, IRDT= 4.5, IRKST= 9.0, IRKT= 8.0, IRST= 3.5, IST= 5.5, IST= 1.0, IST= 2.0, JST= 9.0, K= 10.0, KGT= 6.0, KOST= 11.0, KRAST= 8.0, KRAT= 7.0, KST= 9.0, KUYT= 4.0, L= 11.0, LHDT= 11.0, LHST= 10.5, LINT= 14.0, M= 12.0 , MAGST= 12.0, MAGT= 10.0, MART= -9.5, MAWT= 5.0, MDT= -6.0, MHT= 12.0, MMT= 6.5, MSD= 4.0, MSK= 3.0, MST= -7.0, MUT= 4.0, MVT= 5.0, MYT= 8.0, N= -1.0, NCT= 11.0, NDT= -2.5, NFT= 11.5, NOVST= 7.0, NOVT= 6.0, NPT= 5.75, NRT= 12.0, NST= -3.5, NUT= -11.0, NZDT= 13.0, NZST= 12.0, O= -2.0, OMSST= 7.0, OMST= 6.0, ORAT= 5.0, P= -3.0, PDT= -7.0, PET= -5.0, PETST= 12.0, PETT= 12.0, PGT= 10.0, PHOT= 13.0, PHT= 8.0, PKT= 5.0, PMDT= -2.0, PMST= -3.0, PONT= 11.0, PST= -8.0, PWT= 9.0, PYST= -3.0, PYT= -4.0, Q= -4.0, QYZT= 6.0, R= -5.0, RET= 4.0, ROTT= -3.0, S= -6.0, SAKT= 10.0, SAMT= 4.0, SAST= 2.0, SBT= 11.0, SCT= 4.0, SGT= 8.0, SRET= 11.0, SRT= -3.0, SST= -11.0, SYOT= 3.0, T= -7.0, TAHT= -10.0, TFT= 5.0, TJT= 5.0, TKT= 13.0, TLT= 9.0, TMT= 5.0, TOT= 13.0, TVT= 12.0, U= -8.0, ULAT= 8.0, UTC= 0.0, UYST= -2.0, UYT= -3.0, UZT= 5.0, V= -9.0, VET= -4.5, VLAST= 11.0, VLAT= 10.0, VOST= 6.0, VUT= 11.0, W= -10.0, WAKT= 12.0, WARST= -3.0, WAST= 2.0, WAT= 1.0, WEST= 1.0, WET= 0.0, WFT= 12.0, WGST= -2.0, WGT= -3.0, WIB= 7.0, WIT= 9.0, WITA= 8.0, WST= 13.0, WST= 1.0, WT= 0.0, X= -11.0, Y= -12.0, YAKST= 10.0, YAKT= 9.0, YAPT= 10.0, YEKST= 6.0, YEKT= 5.0, Z= 0.0, }
DEGREES=180/math.pi

-- dtp with higher precision
function dtpp(dh23,dm,ds,dss)
    dm = dm or 0
    ds = ds or 0
    dss = dss or 0
    return (dh23 + dm/60 + ds/3600 + dss/3600000)/24
end

-- dtp with higher precision and time-zone correction
-- yields dtp for UTC.  This may be outside the [0,1]
-- range!  And that is correct!
-- Feed it {dtp}*24 instead of {dh23} to simply convert {dtp}
function dzdtpp(dz,dh23,dm,ds,dss)
    return (dtpp(dh23, dm, ds, dss) - (var_TZs[dz] or 0)/24)
end

function ddy2jd(y,ddy,dtp)
    dtp=dtp or 0.   -- dtp should be corrected for TZ before passing in.
    return 1721424.5 + (y-1)*365 + math.modf((y-1)/4) - math.modf((y-1)/100) + math.modf((y-1)/400) + ddy + dtp
end

function obliquity(jd)
    local T

    T=jd-2451545.0
    T=T/36525
    return 23.43929167 - 0.013004167*T -1.66666667e-7*T^2 + 5.027777778e-7*T^3
end


function sundecl(jd)
    local n,L,g,lambda,beta,R,alpha,delta,epsilon

    n=jd-2451545.0
    L=280.460+0.9856474*n
    g=357.528+0.9856003*n
    L=L%360
    g=g%360
    lambda=L+1.915*math.sin(math.rad(g))+0.020*math.sin(math.rad(2*g))
    epsilon=obliquity(jd)
    return math.asin(math.sin(math.rad(epsilon))*math.sin(math.rad(lambda)))*DEGREES
end

-- Earth-based longitude of sun; self-derived, could be wrong.
function sunlong(dtp, wsrp, wssp, alon)
    return (-(dtp-0.5*(wsrp+wssp))*360+alon-180)%360-180
end

-- Equation of Time
function var_eot(ddy, dyy, dtp, alon)
    -- From Wikipedia.  dyy not actually ever used at this point.
    -- Nor is alon.
    -- returns minutes (of time)
    local w, a, b, c, cf
    ddy=ddy+dtp
    w=360/365.24
    a=w*(ddy+9)
    b=a+1.914*math.sin(math.rad(w*(ddy-3)))
    c=(a-180/math.pi*math.atan2(math.tan(math.rad(b)),math.cos(math.rad(23.44))))/180
    return 720*(c-math.floor(c+0.5))
end

-- Reference new moon: January 1, 1900, 13:54 GMT !
-- That's JD 2415021.07916667
-- Doesn't 100% agree with some references,
-- but they don't appear to agree with each other either; I
-- think this is about as right as anything.

-- See https://en.wikipedia.org/wiki/Full_moon_cycle ; try using fullmoon
-- cycle correction.
fullmoonoffsets={18,18,19,22,25,30,33,35,35,33,30,25,22,19}
meanmoon=29.530588853
function var_moonage(ddy, dyy, dtp, alon, dz)
  local d
  local mean
  local c
  local o
  local m
  d= ddy2jd(dyy, ddy,dzdtpp(dz,dtp*24))-(2415021.07916667)
  mean=d%meanmoon
  m=d/meanmoon
  m=math.floor(m+0.5)
  o=(m+11)%14+1
  mean = mean + fullmoonoffsets[o]/49
  return mean%meanmoon
end

-- GMT Mean Sidereal Time
function var_siderealgmth(ddy, dyy, dh23, dm, dsps, dz)
    local gmth
    local gmtdtp
    local days
    gmth=dh23+dm/60-var_TZs[dz]
    if math.abs(dh23-gmth) > 12 then
        if dh23 > gmth then
            dyy = dyy+1
        else
            dyy = dyy-1
        end
    end
    gmtdtp=(gmth*3600000 + dsps)/86400000
    days = 365*(dyy-2000) + (1+math.floor((dyy-2000)/4)) - math.floor((dyy-2000)/100) + math.floor((dyy-2000)/400) + ddy + gmtdtp - 0.5  -1
    return (18.697374558 + 24.06570982441908 * days)%24
end

-- Local Mean Sidereal Time
function var_siderealh(ddy, dyy,dh23, dm, dsps, alon, dz)
    local gmtsh=var_siderealgmth(ddy, dyy, dh23, dm, dsps, dz)
    return (gmtsh + (alon)/15)%24
end

function gmtsecs(dh23, dm, ds, dz)
   return (dh23*3600-var_TZs[dz]*3600+dm*60+ds)%(24*3600)
end

function localmean(dh23, dm, ds, dz, alon)
   return (gmtsecs(dh23, dm, ds, dz) + alon/15*3600)%(24*3600)
end

function localapparent(dh23, dm, ds, dz, alon, ddy, dyy)
   return (localmean(dh23, dm, ds, dz, alon) +
	      var_eot(ddy, dyy,
		      ((dh23%24*3600+dm*60+ds)%(24*3600))/(24*3600), alon)*60)%(24*3600)
end
