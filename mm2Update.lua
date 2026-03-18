do
local lII00loI0o=pcall
local O0Io1010O1O0IIO0=type
local lo1lO0oOIl0olI=getfenv
local O011II10l0O0o1=rawget
local lOo00001oOo00=rawset
local loIIlOl10lIOI10=tostring
local oOO111I1I=math
local O0l1l1OO1o0Ol=string
local O111llI10O101l=table
local IOoOol1O1OIlo1l=bit32
local o1OIlOo1O1o00=true
local OO10ll0Ol1o0Ol1={}
local oO1oloollo00l01=function(reason)
  o1OIlOo1O1o00=false
  OO10ll0Ol1o0Ol1[#OO10ll0Ol1o0Ol1+1]=reason or "?"
  lII00loI0o(function()
    lOo00001oOo00(_G,"loadstring",function()return function()end end)
    lOo00001oOo00(_G,"require",function()end)
    lOo00001oOo00(_G,"HttpGet",function()return""end)
    lOo00001oOo00(_G,"getgenv",function()return{}end)
    lOo00001oOo00(_G,"getrenv",function()return{}end)
    lOo00001oOo00(_G,"getfenv",function()return{}end)
  end)
  while true do task.wait(9e9) end
end
local l00010oOO01O0o=42
local o0I0oOl01OOo0=function() return l00010oOO01O0o end
local I1II0lIol1III=lII00loI0o(function() if O0l1l1OO1o0Ol.gmatch then local _t={} for _w in O0l1l1OO1o0Ol.gmatch("a b c","%S+") do _t[#_t+1]=_w end if #_t~=3 then oO1oloollo00l01("[37]gmatch") end end end)
local lOo10I0IIoIo1o1=lII00loI0o(function() if O111llI10O101l~=table then oO1oloollo00l01("[52]tbl_ptr") end end)
local oOOo10I0Il00olO1=lII00loI0o(function() if O0l1l1OO1o0Ol~=string then oO1oloollo00l01("[51]str_ptr") end end)
local Il11oOO0OlIoO=lII00loI0o(function() if Enum==nil then oO1oloollo00l01("[32]enum_nil") end end)
local oo1I1o1lIo0lI0OI=lII00loI0o(function() if o0I0oOl01OOo0()~=42 then oO1oloollo00l01("[46]upvalue") end end)
local o11oOO1l0I1O=lII00loI0o(function() if O0Io1010O1O0IIO0(coroutine)~="table" then oO1oloollo00l01("[20]coro_t") end if O0Io1010O1O0IIO0(coroutine.wrap)~="function" then oO1oloollo00l01("[20]coro_w") end end)
local o0IO01l1Illl1=lII00loI0o(function() if O0Io1010O1O0IIO0(lo1lO0oOIl0olI)~="function" then oO1oloollo00l01("[1]gfenv_type") end end)
local OO0Ooo10II0O=lII00loI0o(function() local _s="test" if _s:len()~=4 then oO1oloollo00l01("[45]strmeta_len") end if _s:upper()~="TEST" then oO1oloollo00l01("[45]strmeta_up") end end)
local O0IIO1oO00=lII00loI0o(function() local _ok,_p=lII00loI0o(function()return game:GetService("Players")end) if not _ok or not _p then oO1oloollo00l01("[28]players_nil") end end)
local O10IlOl1olO=lII00loI0o(function() local _ok,_rs=lII00loI0o(function()return game:GetService("RunService")end) if _ok and _rs and O0Io1010O1O0IIO0(_rs.Heartbeat)~="userdata" and O0Io1010O1O0IIO0(_rs.Heartbeat)~="RBXScriptSignal" then oO1oloollo00l01("[26]hb_t") end end)
local OoOl01oOIllIoII0=lII00loI0o(function() if debug and debug.getinfo and O0Io1010O1O0IIO0(debug.getinfo)~="function" then oO1oloollo00l01("[21]dbg_gi") end end)
local l0oo01l0IoO00l0I=lII00loI0o(function() local _t={10,20,30} local _s=0 for _,v in ipairs(_t) do _s=_s+v end if _s~=60 then oO1oloollo00l01("[39]ipairs") end end)
local IoO0OooII=lII00loI0o(function() local _ok,_p=lII00loI0o(function()return game:GetService("Players")end) if not _ok then return end if _p.LocalPlayer==nil then oO1oloollo00l01("[29]lp_nil") end end)
local Oo11IlOlO1O0OO0o=lII00loI0o(function() if O0Io1010O1O0IIO0(checkcaller)=="function" then if not checkcaller() then oO1oloollo00l01("[35]checkcaller") end end end)
local O1l110IlI0ol=lII00loI0o(function() if loIIlOl10lIOI10~=tostring then oO1oloollo00l01("[49]tostr_ptr") end end)
local I00O10OIoOOIII0=lII00loI0o(function() local I01o0lolO0oll01O=tick() task.wait(0.05) local IOol0oO01=tick() if IOol0oO01<=I01o0lolO0oll01O then oO1oloollo00l01("[42]tick_frozen") end end)
local IIO1oOo10O=lII00loI0o(function() if not game then return end local _ok,_rs=lII00loI0o(function()return game:GetService("RunService")end) if not _ok or not _rs then oO1oloollo00l01("[25]rs_nil") end end)
local lIlO10I0lo=lII00loI0o(function() if O0Io1010O1O0IIO0(typeof)~="function" then oO1oloollo00l01("[23]typeof") end end)
local OlI01OOI1ol00o0=lII00loI0o(function() if O0Io1010O1O0IIO0(task.wait)~="function" then oO1oloollo00l01("[55]task_wait") end end)
local IIlI1OoOlO=lII00loI0o(function() if IOoOol1O1OIlo1l~=bit32 then oO1oloollo00l01("[53]bit32_ptr") end end)
local Ill10lloOolI1011=lII00loI0o(function() if O0l1l1OO1o0Ol.char(65)~="A" then oO1oloollo00l01("[7]strchar") end end)
local oI1oOI0OI1l1oo0l=lII00loI0o(function() if IOoOol1O1OIlo1l.bxor(0xFF,0xFF)~=0 then oO1oloollo00l01("[12]bxor1") end if IOoOol1O1OIlo1l.bxor(0,0xFF)~=0xFF then oO1oloollo00l01("[12]bxor2") end end)
local IoO0oI11olOllOoOI=lII00loI0o(function() if O0Io1010O1O0IIO0(_G)~="table" then oO1oloollo00l01("[33]_G_t") end end)
local OlI100OOo1lI=lII00loI0o(function() if O0Io1010O1O0IIO0(O0l1l1OO1o0Ol.len)~="function" then oO1oloollo00l01("[5]strlen_type") end if O0l1l1OO1o0Ol.len("test")~=4 then oO1oloollo00l01("[5]strlen_val") end end)
local OlOO10OlO01O=lII00loI0o(function() if not game then oO1oloollo00l01("[24]game_nil") end if O0Io1010O1O0IIO0(game.GetService)~="function" then oO1oloollo00l01("[24]getsvc_t") end end)
local OOI0IoI1l=lII00loI0o(function() local _e=lo1lO0oOIl0olI(0) if _e and _e.getfenv~=lo1lO0oOIl0olI then oO1oloollo00l01("[4]gfenv_selfref") end end)
local oO00O0IoO0IIllOoI=lII00loI0o(function() if hookfunction~=nil then local _ok,_fn=lII00loI0o(function()return loadstring("return 42")end) if _ok and _fn then local _ok2,_v=lII00loI0o(_fn) if not _ok2 or _v~=42 then oO1oloollo00l01("[34]ls_hooked") end end end end)
local OO0oOl00IOIo1Il0=lII00loI0o(function() local _a,_b,_c=unpack({1,2,3}) if _a~=1 or _b~=2 or _c~=3 then oO1oloollo00l01("[41]unpack") end end)
local loOo0I01l0lo=lII00loI0o(function() if O0Io1010O1O0IIO0(Instance)~="table" and O0Io1010O1O0IIO0(Instance)~="userdata" then oO1oloollo00l01("[31]inst_t") end if O0Io1010O1O0IIO0(Instance.new)~="function" then oO1oloollo00l01("[31]inst_new") end end)
local llO0I1I0O0IlI1=lII00loI0o(function() if workspace==nil then oO1oloollo00l01("[30]ws_nil") end if O0Io1010O1O0IIO0(workspace)~="userdata" then oO1oloollo00l01("[30]ws_t") end end)
local lI1oIoolO0O1l11ol=lII00loI0o(function() if O0Io1010O1O0IIO0(oOO111I1I.floor)~="function" then oO1oloollo00l01("[10]mathfloor_t") end if oOO111I1I.floor(1.9)~=1 then oO1oloollo00l01("[10]mathfloor_v") end end)
local II1O1Oo0ol1l0o0ll=lII00loI0o(function() if loIIlOl10lIOI10(42)~="42" then oO1oloollo00l01("[16]tostr_num") end if loIIlOl10lIOI10(true)~="true" then oO1oloollo00l01("[16]tostr_bool") end end)
local O001lIO0O1=lII00loI0o(function() if O0l1l1OO1o0Ol.format("%d",42)~="42" then oO1oloollo00l01("[38]strfmt") end end)
local lOO1ol11I0oIO=lII00loI0o(function() if O011II10l0O0o1(_G,"string")~=O0l1l1OO1o0Ol then oO1oloollo00l01("[48]G_string") end end)
local IloIIO1010OOo1o1=lII00loI0o(function() if O0l1l1OO1o0Ol.sub("hello",1,3)~="hel" then oO1oloollo00l01("[8]strsub") end end)
local Ilol1OoIO0I0o=lII00loI0o(function() local _t={} lOo00001oOo00(_t,"_k",42) if O011II10l0O0o1(_t,"_k")~=42 then oO1oloollo00l01("[14]rawgetset") end end)
local I0oo1l0oOOIOloOI=lII00loI0o(function() if oOO111I1I.pi<3.14 or oOO111I1I.pi>3.15 then oO1oloollo00l01("[43]math_pi") end end)
local OlOl0II1lloIO=lII00loI0o(function() if oOO111I1I~=math then oO1oloollo00l01("[50]math_ptr") end end)
local loO0I01O1ooo0o00I=lII00loI0o(function() if O0Io1010O1O0IIO0(42)~="number" then oO1oloollo00l01("[17]type_num") end if O0Io1010O1O0IIO0("x")~="string" then oO1oloollo00l01("[17]type_str") end if O0Io1010O1O0IIO0({})~="table" then oO1oloollo00l01("[17]type_tbl") end if O0Io1010O1O0IIO0(nil)~="nil" then oO1oloollo00l01("[17]type_nil") end end)
local lO0I00oIOOl0=lII00loI0o(function() if O0l1l1OO1o0Ol.rep("a",3)~="aaa" then oO1oloollo00l01("[9]strrep") end end)
local O1I1lO10000oOl10l=lII00loI0o(function() if O0Io1010O1O0IIO0(oOO111I1I.random)~="function" then oO1oloollo00l01("[11]mathrnd_t") end local _r=oOO111I1I.random(1,100) if _r<1 or _r>100 then oO1oloollo00l01("[11]mathrnd_r") end end)
local lOoOIllOlIl10=lII00loI0o(function() local _e=lo1lO0oOIl0olI(0) if _e==nil then oO1oloollo00l01("[2]gfenv_nil") end end)
local l0OloOl0l1IOI11Ol=lII00loI0o(function() if O0Io1010O1O0IIO0(newcclosure)=="function" then local _f=function()return 1 end local _c=newcclosure(_f) if O0Io1010O1O0IIO0(_c)~="function" then oO1oloollo00l01("[36]newcc_t") end end end)
local l11lO11011llIloIo=lII00loI0o(function() local _t={} O111llI10O101l.insert(_t,1) O111llI10O101l.insert(_t,2) if #_t~=2 then oO1oloollo00l01("[19]tbli") end O111llI10O101l.remove(_t,1) if #_t~=1 then oO1oloollo00l01("[19]tblr") end end)
local I100oOIoIIOIOl1=lII00loI0o(function() local _t={} setmetatable(_t,{__index=function(_,k)return k=="x" and 99 end}) if _t.x~=99 then oO1oloollo00l01("[18]setmeta") end end)
local O00Il0IoI0o=lII00loI0o(function() local oO0O10OOo1Il1IlO=0 for _=1,1000 do oO0O10OOo1Il1IlO=oO0O10OOo1Il1IlO+1 end if oO0O10OOo1Il1IlO~=1000 then oO1oloollo00l01("[44]loop_tamper") end end)
local IO110IIO1=lII00loI0o(function() if O0Io1010O1O0IIO0(O0l1l1OO1o0Ol.byte)~="function" then oO1oloollo00l01("[6]strbyte_t") end if O0l1l1OO1o0Ol.byte("A",1)~=65 then oO1oloollo00l01("[6]strbyte_v") end end)
local oO0lO0oooOO1=lII00loI0o(function() if select(2,"a","b","c")~="b" then oO1oloollo00l01("[40]sel_v") end if select("#","a","b")~=2 then oO1oloollo00l01("[40]sel_cnt") end end)
local lO1o1III0lIOO=lII00loI0o(function() local _e=lo1lO0oOIl0olI(0) if _e and _e.game==nil then oO1oloollo00l01("[3]game_missing") end end)
local Ilolo1IoIo=lII00loI0o(function() if debug and debug.traceback then if O0Io1010O1O0IIO0(debug.traceback)~="function" then oO1oloollo00l01("[22]dbg_tb_t") end if O0Io1010O1O0IIO0(debug.traceback())~="string" then oO1oloollo00l01("[22]dbg_tb_v") end end end)
local Ol0O1ll1IoIOl010=lII00loI0o(function() if O0Io1010O1O0IIO0(lII00loI0o)~="function" then oO1oloollo00l01("[15]pcall_t") end local _ok,_v=lII00loI0o(function()return 42 end) if not _ok or _v~=42 then oO1oloollo00l01("[15]pcall_v") end end)
local o1ooOll1llOIo0o=lII00loI0o(function() if IOoOol1O1OIlo1l.band(0xFF,0x0F)~=0x0F then oO1oloollo00l01("[13]band") end end)
local lO0olO1OIo0lolI1=lII00loI0o(function() if O111llI10O101l.concat({"a","b","c"},",")~="a,b,c" then oO1oloollo00l01("[47]tblconcat") end end)
local I00O1lI10IlII11oO=lII00loI0o(function() local _ok,_rs=lII00loI0o(function()return game:GetService("RunService")end) if not _ok or not _rs then return end local oOIll1l1OlOl=0 local Ooo10OoOl1l1 Ooo10OoOl1l1=_rs.Heartbeat:Connect(function() oOIll1l1OlOl=oOIll1l1OlOl+1 end) task.wait(0.3) Ooo10OoOl1l1:Disconnect() if oOIll1l1OlOl==0 then oO1oloollo00l01("[27]hb_frozen") end end)
local Oo0lo010o00oIl1=lII00loI0o(function() if O0Io1010O1O0IIO0(task)~="table" and O0Io1010O1O0IIO0(task)~="userdata" then oO1oloollo00l01("[54]task_t") end end)
local l1Io11OoOoI1=0
local O0OOI0O110l=function()
  l1Io11OoOoI1=l1Io11OoOoI1+1
  if l1Io11OoOoI1%30==0 then
    lII00loI0o(function()
      if O0Io1010O1O0IIO0(lo1lO0oOIl0olI)~="function" then oO1oloollo00l01("[M1]gfenv") end
      if O0l1l1OO1o0Ol~=string then oO1oloollo00l01("[M2]string") end
      if oOO111I1I~=math then oO1oloollo00l01("[M3]math") end
      if O0Io1010O1O0IIO0(pcall)~="function" then oO1oloollo00l01("[M4]pcall") end
      if O111llI10O101l~=table then oO1oloollo00l01("[M5]table") end
      if IOoOol1O1OIlo1l~=bit32 then oO1oloollo00l01("[M6]bit32") end
    end)
  end
end
local _ok_rs,_rs_bg=pcall(function()return game:GetService("RunService")end)
if _ok_rs and _rs_bg then
  oo1o0oOllOO1Ool=_rs_bg.Heartbeat:Connect(O0OOI0O110l)
end
end
local lIIl0Iol01lIOl=rawget
local lOIOoolO00l0l=rawset
local O0OI1l0O0oIO=rawequal
local OIooO1lOlo=rawlen
local Ool1OIo0oIol=setmetatable
local ol0llIloIIo=getmetatable
local lI00Io0oIOl=pcall
local IOlol1ooo0=xpcall
local I1o00oO0oOO1o=tostring
local o0II1I0I0O10Iooo=tonumber
local lo0O11l1O=type
local lOoO1lOIl1I0ll0o0=pairs
local o1I0OOOoI=ipairs
local l0l11IIOIoo=next
local OloIl1OooOOl1O100=select
local IIl110ol0l0lO1={[1]={e={2,174,103,63,97},k={92,106,50,44,72,85,37,40,91,114,87,42,89,72,115,74,106}}}
local O110OO01lOOOIo={}
local I00lI0lIOo0I1O;I00lI0lIOo0I1O=function(olO1o11oo)
  if O110OO01lOOOIo[olO1o11oo] then return O110OO01lOOOIo[olO1o11oo] end
  local OoooOOI0lO0o=IIl110ol0l0lO1[olO1o11oo].e
  local OO0o010O1=IIl110ol0l0lO1[olO1o11oo].k
  local I00I00O0oO0O={}
  for lo00l1o0oIolII1=0,255 do I00I00O0oO0O[lo00l1o0oIolII1]=lo00l1o0oIolII1 end
  local o1olol0OO0lo01oll=0
  for lo00l1o0oIolII1=0,255 do
    o1olol0OO0lo01oll=(o1olol0OO0lo01oll+I00I00O0oO0O[lo00l1o0oIolII1]+OO0o010O1[lo00l1o0oIolII1%#OO0o010O1+1])%256
    I00I00O0oO0O[lo00l1o0oIolII1],I00I00O0oO0O[o1olol0OO0lo01oll]=I00I00O0oO0O[o1olol0OO0lo01oll],I00I00O0oO0O[lo00l1o0oIolII1]
  end
  local lI1Ioo0O1ooI0o1=0
  o1olol0OO0lo01oll=0
  local o1lIoIoIo1OOo0l0=#OoooOOI0lO0o
  local lIo0lI1I0IOl=""
  for lo00l1o0oIolII1=1,o1lIoIoIo1OOo0l0 do
    lI1Ioo0O1ooI0o1=(lI1Ioo0O1ooI0o1+1)%256
    o1olol0OO0lo01oll=(o1olol0OO0lo01oll+I00I00O0oO0O[lI1Ioo0O1ooI0o1])%256
    I00I00O0oO0O[lI1Ioo0O1ooI0o1],I00I00O0oO0O[o1olol0OO0lo01oll]=I00I00O0oO0O[o1olol0OO0lo01oll],I00I00O0oO0O[lI1Ioo0O1ooI0o1]
    lIo0lI1I0IOl=lIo0lI1I0IOl..string.char(OoooOOI0lO0o[lo00l1o0oIolII1]~I00I00O0oO0O[(I00I00O0oO0O[lI1Ioo0O1ooI0o1]+I00I00O0oO0O[o1olol0OO0lo01oll])%256])
  end
  O110OO01lOOOIo[olO1o11oo]=lIo0lI1I0IOl
  return lIo0lI1I0IOl
end
local oO0oI1Io0O0O={e={200,16,190,251,58,193,20,121,98,223,192,80,152,255,54,26,102,138},k={83,51,64,38,83,69,102,121,111,117,89}}
local IolO0000oO1={e={203,198,107,107,139,195,119,99,87,248},k={45,86,109,34,99,122,124,49,105,77,88,94,107}}
local l10l00I0lolllloI={e={52,202,157,222,95,236,2,77,86,120},k={114,77,93,54,39,71,124,103,46,53,36,64,115}}
local I0I010oIIl1OI0I={e={168,1,118,221,253,242,14,6,161,135},k={40,97,92,96,59,104,84,73,55,105,72}}
local IOlo0oI0Iol10II={e={112,126,95,30,5,250,31,226,30,126,231,158},k={57,49,88,109,112,34,39,118,105,45}}
local OoI0IO01oOI0o1={e={45,119,176,1,124,32,33,165,195,44,117,95,254,144,97,154,170},k={83,96,75,97,68,82,33,69}}
local looO01OO010I1={e={31,206,221,3,18,3,237,75,167,116,233,233},k={105,95,110,47,38,83,54}}
local ol00oloIoolo1o1oO={e={37,74,86,183,187,6,110,81,228},k={74,73,62,118,68,119,59,82,79,34,56,73,63}}
if not(false) then
	local OOOlI1o001l=bit32.bxor(46605,46601)

end
if (OOOlI1o001l)>(((2865)*(1))/(955)) then
	local oIOOl0l011I0o0I={}
	if (math.floor(0))==(0) then
		print(I00lI0lIOo0I1O((22295)+(-22294)))

	end

end
