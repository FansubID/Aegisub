script_name="Silih Otomatis"
script_description = "Melakukan aksi silih pada dialog"
script_author      = "Padang Perwira Yudha"
script_version     = "2.5.1"
script_namespace="yudha.SilihOtomatis"

local haveDepCtrl,DependencyControl,depRec=pcall(require,"l0.DependencyControl")
if haveDepCtrl then
    script_version="2.5.1"
    depRec=DependencyControl{feed="https://raw.githubusercontent.com/Pcpkomputer/.bulan/master/DependencyControl.json"}
end

function silih(bintang, subs)
		local pola = "{%"..bintang.."}([^{]*){%"..bintang.."([^%*]?[^}]*)}"
		local silih = "{%"..bintang.."}%2{%"..bintang.."%1}"
	-------------------------------------------------------------

				for i=1, #subs do
				line=subs[i]
				text=line.text
				if line.class == "dialogue" then
				style = line.style
				efek = line.effect
				proses = false

				if style:match("Default") then proses = true end
				if style:match("Miring") then proses = true end
				if style:match("Dialog") then proses = true end
				if style:match("Main") then proses = true end
				if proses then
				text=text:gsub(pola, silih) end
				line.text=text
				subs[i]=line
				end
				end
				end



---------------------------------------------------------------
---------------------------------------------------------------
function bintang(subs, sel, act)
  silih("*", subs)
  aegisub.set_undo_point("script_name")
end


function add(subs, sel, act)
  silih("@", subs)
  aegisub.set_undo_point("script_name")
end


function pagar(subs, sel, act)
  silih("#", subs)
  aegisub.set_undo_point("script_name")
end


function dollar(subs, sel, act)
  silih("$", subs)
  aegisub.set_undo_point("script_name")
end


function persen(subs, sel, act)
  silih("%", subs)
  aegisub.set_undo_point("script_name")
end
----------------------------------------------------------------------
----------------------------------------------------------------------

function silih_main(subs, sel)
if res["cek1"] then bintang(subs, sel, act) end
if res["cek2"] then add(subs, sel, act) end
if res["cek3"] then pagar(subs, sel, act) end
if res["cek4"] then dollar(subs, sel, act) end
if res["cek5"] then persen(subs, sel, act) end
end

function uwu(subs)
			ed01=res.ed1
			ed02=res.ed2
			ed03=res.ed3
			ed04=res.ed4
			ed05=res.ed5
			go01=res.ed1go
			go02=res.ed2go
			go03=res.ed3go
			go04=res.ed4go
			go05=res.ed5go
			for i=1,#subs do
			if subs[i].class=="dialogue" then
            line=subs[i]
            text=subs[i].text
			if res["la1"] then
			if ed01:match("-") then ed01x=ed01:gsub("-","%%-") else ed01x=ed01 end
			if go01:match("-") then go01x=go01:gsub("-","%%-") else go01x=go01 end
			text=text:gsub(ed01x,"{*}"..ed01x.."{*"..go01x.."}") end
			if res["la2"] then
			if ed02:match("-") then ed02x=ed02:gsub("-","%%-") else ed02x=ed02 end
			if go01:match("-") then go01x=go01:gsub("-","%%-") else go02x=go02 end
			text=text:gsub(ed02x,"{*}"..ed02x.."{*"..go02x.."}") end
			if res["la3"] then
			if ed03:match("-") then ed03x=ed03:gsub("-","%%-") else ed03x=ed03 end
			if go01:match("-") then go01x=go01:gsub("-","%%-") else go03x=go03 end
			text=text:gsub(ed03x,"{*}"..ed03x.."{*"..go03x.."}") end
			if res["la4"] then
			if ed04:match("-") then ed04x=ed04:gsub("-","%%-") else ed04x=ed04 end
			if go01:match("-") then go01x=go01:gsub("-","%%-") else go04x=go04 end
			text=text:gsub(ed04x,"{*}"..ed04x.."{*"..go04x.."}") end
			if res["la5"] then
			if ed05:match("-") then ed05x=ed05:gsub("-","%%-") else ed05x=ed05 end
			if go01:match("-") then go01x=go01:gsub("-","%%-") else go05x=go05 end
			text=text:gsub(ed05x,"{*}"..ed05x.."{*"..go05x.."}") end
			line.text=text
			subs[i]=line
			end
			end
			end


function owo(subs, sel)
			ed01=res.ed1
			ed02=res.ed2
			ed03=res.ed3
			ed04=res.ed4
			ed05=res.ed5
			go01=res.ed1go
			go02=res.ed2go
			go03=res.ed3go
			go04=res.ed4go
			go05=res.ed5go
			for x, i in ipairs(sel) do
			line=subs[i]
			text=line.text
			if res["la1"] then
			if ed01:match("-") then ed01x=ed01:gsub("-","%%-") else ed01x=ed01 end
			if go01:match("-") then go01x=go01:gsub("-","%%-") else go01x=go01 end
			text=text:gsub(ed01x,"{*}"..ed01x.."{*"..go01x.."}") end
			if res["la2"] then
			if ed02:match("-") then ed02x=ed02:gsub("-","%%-") else ed02x=ed02 end
			if go01:match("-") then go01x=go01:gsub("-","%%-") else go02x=go02 end
			text=text:gsub(ed02x,"{*}"..ed02x.."{*"..go02x.."}") end
			if res["la3"] then
			if ed03:match("-") then ed03x=ed03:gsub("-","%%-") else ed03x=ed03 end
			if go01:match("-") then go01x=go01:gsub("-","%%-") else go03x=go03 end
			text=text:gsub(ed03x,"{*}"..ed03x.."{*"..go03x.."}") end
			if res["la4"] then
			if ed04:match("-") then ed04x=ed04:gsub("-","%%-") else ed04x=ed04 end
			if go01:match("-") then go01x=go01:gsub("-","%%-") else go04x=go04 end
			text=text:gsub(ed04x,"{*}"..ed04x.."{*"..go04x.."}") end
			if res["la5"] then
			if ed05:match("-") then ed05x=ed05:gsub("-","%%-") else ed05x=ed05 end
			if go01:match("-") then go01x=go01:gsub("-","%%-") else go05x=go05 end
			text=text:gsub(ed05x,"{*}"..ed05x.."{*"..go05x.."}") end
			line.text=text
			subs[i]=line
			end
			return sel
			end

function main(subs,sel)
ADD=aegisub.dialog.display
GUI=
{
	{x=0,y=0,width=1,height=1,class="label",label="[v2.5.1]",},
	{x=1,y=0,width=1,height=1,class="label",label="[//]",},
	{x=2,y=0,width=1,height=1,class="label",label="[Kalimat Awal]",},
	{x=3,y=0,width=1,height=1,class="label",label="[//]",},
	{x=4,y=0,width=1,height=1,class="label",label="[Kalimat Akhir]",},
	{x=0,y=1,width=1,height=1,class="checkbox",name="cek1",label="*",},
	{x=0,y=2,width=1,height=1,class="checkbox",name="cek2",label="@",},
	{x=0,y=3,width=1,height=1,class="checkbox",name="cek3",label="#",},
	{x=0,y=4,width=1,height=1,class="checkbox",name="cek4",label="$",},
	{x=0,y=5,width=1,height=1,class="checkbox",name="cek5",label="%",},
	--
	{x=1,y=1,width=1,height=1,class="checkbox",name="la1",},
	{x=1,y=2,width=1,height=1,class="checkbox",name="la2",},
	{x=1,y=3,width=1,height=1,class="checkbox",name="la3",},
	{x=1,y=4,width=1,height=1,class="checkbox",name="la4",},
	{x=1,y=5,width=1,height=1,class="checkbox",name="la5",},
	--
	{x=2,y=1,width=1,height=1,class="edit",name="ed1", value="Yudha-san",},
	{x=3,y=1,width=1,height=1,class="label",label=">",},
	{x=4,y=1,width=6,height=1,class="edit",name="ed1go", value="Yudha",},

	{x=2,y=2,width=1,height=1,class="edit",name="ed2", value="Yudha",},
	{x=3,y=2,width=1,height=1,class="label",label=">",},
	{x=4,y=2,width=6,height=1,class="edit",name="ed2go", value="Yudha-san",},

	{x=2,y=3,width=1,height=1,class="edit",name="ed3",},
	{x=3,y=3,width=1,height=1,class="label",label=">",},
	{x=4,y=3,width=6,height=1,class="edit",name="ed3go",},

	{x=2,y=4,width=1,height=1,class="edit",name="ed4",},
	{x=3,y=4,width=1,height=1,class="label",label=">",},
	{x=4,y=4,width=6,height=1,class="edit",name="ed4go",},

	{x=2,y=5,width=1,height=1,class="edit",name="ed5",},
	{x=3,y=5,width=1,height=1,class="label",label=">",},
	{x=4,y=5,width=6,height=1,class="edit",name="ed5go",},

	}

P,res=ADD(GUI,
{"Silih", "Seluruh","Sorot","Kembali"})
if P=="Seluruh" then uwu(subs) end
if P=="Sorot" then owo(subs, sel) end
if P=="Kembali" then aegisub.cancel() end
if P=="Silih" then silih_main(subs, sel) end

    return sel,act
end

function silih_otomatis(subs, sel)
main(subs, sel)
aegisub.set_undo_point(script_name)
return sel
end

if haveDepCtrl then depRec:registerMacro(silih_otomatis) else aegisub.register_macro(script_name,script_description,silih_otomatis) end
