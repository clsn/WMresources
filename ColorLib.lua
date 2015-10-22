-- http://www.rapidtables.com/convert/rgb-to-hsv.htm


function hsv2rgb(h, s, v)   -- HSV in [0,360), [0,1], [0,1]
    local c=v*s
    local x=c*(1-math.abs((h/60)%2-1))
    local m=v-c
    local r,g,b
    if 0<=h and h<60 then
	r,g,b=c,x,0
    elseif h<120 then
	r,g,b=x,c,0
    elseif h<180 then
	r,g,b=0,c,x
    elseif h<240 then
	r,g,b=0,x,c
    elseif h<300 then
	r,g,b=x,0,c
    else
	r,g,b=c,0,x
    end
    return (r+m)*255, (g+m)*255, (b+m)*255
end

function rgb2hsv(r, g, b)   -- RGB in [0,255]
    r=r/255
    g=g/255
    b=b/255
    local cmax=math.max(r,g,b)
    local cmin=math.min(r,g,b)
    local delta=cmax-cmin
    local h,s,v
    if delta==0 then
	h=0
    elseif r == cmax then
	h=60*(((g-b)/delta)%6)
    elseif g == cmax then
	h=60*((b-r)/delta+2)
    else
	h=60*((r-g)/delta+4)
    end
    if cmax==0 then
	s=0
    else
	s=delta/cmax
    end
    v=cmax
    return h,s,v
end

function hsl2rgb(h, s, l)   -- HSL in [0,360), [0,], [0,1].  Almost  the same as HSV
    local c=(1-math.abs(2*l-1))*s
    local x=c*(1-math.abs(h/60)%2-1)
    local m=l-c/2
    local r,g,b
    -- factor out?
    if 0<=h and h<60 then
	r,g,b=c,x,0
    elseif h<120 then
	r,g,b=x,c,0
    elseif h<180 then
	r,g,b=0,c,x
    elseif h<240 then
	r,g,b=0,x,c
    elseif h<300 then
	r,g,b=x,0,c
    else
	r,g,b=c,0,x
    end
    return (r+m)*255, (g+m)*255, (b+m)*255
end

function rgb2hsl(r, g, b)   -- RGB in [0,255]
    -- factor commonalities with HSV?
    r=r/255
    g=g/255
    b=b/255
    local cmax=math.max(r,g,b)
    local cmin=math.min(r,g,b)
    local delta=cmax-cmin
    local h,s,l
    if delta==0 then
	h=0
    elseif r == cmax then
	h=60*(((g-b)/delta)%6)
    elseif g == cmax then
	h=60*((b-r)/delta+2)
    else
	h=60*((r-g)/delta+4)
    end
    l=(cmax+cmin)/2
    if l==0 or l==1 then
	s=0
    else
	s=delta/(1-math.abs(2*l-1))
    end
    return h,s,l
end

function rgb2hex(r,g,b)
    return ("%02x%02x%02x"):format(r,g,b)
end

function hex2rgb(h)
    return tonumber(h:sub(1,2), 16), tonumber(h:sub(3,4), 16), tonumber(h:sub(5,6), 16)
end
