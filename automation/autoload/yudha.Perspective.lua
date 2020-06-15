script_name="Perspective"
script_description = "Script that finds .ass perspective for a known rectangle->tetragon projection"
script_author      = "Padang Perwira Yudha"
script_version     = "1.4.2"
script_namespace="yudha.Perspective"

local haveDepCtrl,DependencyControl,depRec=pcall(require,"l0.DependencyControl")
if haveDepCtrl then
   script_version="1.4.2"
    depRec=DependencyControl{feed="https://raw.githubusercontent.com/Pcpkomputer/.bulan/master/DependencyControl.json"}
end

function pesanerot(message,cancel)
ADD=aegisub.dialog.display
ADD({{class="label",label=message}},{"OK"},{close='OK'})
if cancel then aegisub.cancel() end
end

function main(subs, sel)
		ADD=aegisub.dialog.display
		ADP=aegisub.decode_path
		ADO=aegisub.dialog.open
		scriptpath=ADP("?script").."\\"
		vpath="D:\\"
		kosong=""
		for x, i in ipairs(sel) do
		line=subs[i]
		text=line.text
		if x==1 then
		tags=text:match("\\i?clip%([^%)]-%)")
		tags1=text:match("\\i?clip%([^%)]-%)")
		end
		if tags==nil or tags=="" then pesanerot("Enggak ada koordinatnya goblok!",1) end
		hasil=tags
		:gsub("\\i?clip%(","<")
		:gsub("%)",">")
ADD=aegisub.dialog.display
GUI=
{
	{x=0,y=0,width=1,height=1,class="label",label="Versi 1.4.2",},
    {x=0,y=1,width=1,height=1,class="label",label="Koordinat :",},
    {x=1,y=1,width=1,height=1,class="edit",name="coor", value=""..hasil.."",},
	{x=0,y=2,width=1,height=1,class="label",label="Rasio :",},
    {x=1,y=2,width=1,height=1,class="edit",name="ras",value="3.5",},
	{x=0,y=3,width=1,height=1,class="checkbox", name="cekorigin",label="Origin :",},
	{x=1,y=3,width=1,height=1,class="edit",name="orz",},
	{x=0,y=4,width=1,height=1,class="checkbox", name="cekscale",label="Scale :",},
	{x=1,y=4,width=1,height=1,class="edit",name="scl",},
	--- ----
	{x=2,y=1,width=1,height=1,class="label",label="|",},
	{x=2,y=2,width=1,height=1,class="label",label="|",},
	{x=2,y=3,width=1,height=1,class="label",label="|",},
	{x=2,y=4,width=1,height=1,class="label",label="|",},
	----
	{x=3,y=0,width=1,height=1,class="label",label="Fungsi Replacer:",},
	{x=3,y=1,width=2,height=1,class="edit",name="repl",},
}
repeat
P,res=ADD(GUI,
{"Proses","Kembali","Replace"},{ok='Proses',close='Kembali'})
until P=="Proses" or P=="Kembali" or P=="Replace"
--
if P=="Replace" then
text=text:gsub("\\i?clip%([^%)]-%)",""..res.repl)
line.text=text
subs[i]=line
end
if res["cekscale"] then
skrup="perspective.py \""..res.coor.."\" -r "..res.ras.." -s "..res.scl.."\n@pause"
else
skrup="perspective.py \""..res.coor.."\" -r "..res.ras.."\n@pause"
end
if res["cekorigin"] then
skrup="perspective.py \""..res.coor.."\" -r "..res.ras.." -o "..res.orz.."\n@pause" end
if res["cekorigin"] and res["cekscale"] then
skrup="perspective.py \""..res.coor.."\" -r "..res.ras.." -o "..res.orz.." -s "..res.ras.."\n@pause" end

--
if P=="Kembali" then aegisub.cancel() end
if P=="Proses" then
crot=vpath.."temp.bat"

local pl0x=io.open(vpath.."temp.bat","w")
pl0x:write(skrup)
pl0x:close()
-----
aegisub.progress.title("Memproses...")
crot=crot:gsub("%=","^=")
os.execute(crot)
main(subs, sel)
end
end
-----
function quo(x) x="\""..x.."\"" return x end
-----
aegisub.set_undo_point(script_name)
end
-----

if haveDepCtrl then depRec:registerMacro(main) else aegisub.register_macro(script_name,script_description,main) end
