script_name="SCXvid"
script_description="GUI for SCXvid avisynth"
script_author="Padang Perwira Yudha"
script_version="1.0.2"
script_namespace="yudha.SCXvid"

local haveDepCtrl,DependencyControl,depRec=pcall(require,"l0.DependencyControl")
if haveDepCtrl then
    script_version="1.0.2"
    depRec=DependencyControl{feed="https://raw.githubusercontent.com/Pcpkomputer/.bulan/master/DependencyControl.json"}
end

function hayoapaini(subs, sel)
	--
	ADD=aegisub.dialog.display
	ADP=aegisub.decode_path
	ADO=aegisub.dialog.open
	ak=aegisub.cancel
	scriptpath=ADP("?script").."\\"
	scriptname=aegisub.file_name()
	vpath=ADP("?video").."\\"
	videoname=nil
	targ="Same as source"
	target=""
	--target=""..res.target

	--
    if videoname==nil then videoname=aegisub.project_properties().video_file:gsub("^.*\\","") end
    if videoname==nil or videoname=="" then t_error("Video belum dimuat",1) end
	--
target=vpath
GUI=
	{
    {x=0,y=0,width=1,height=1,class="label",label="Sumber Video :",},
    {x=1,y=0,width=7,height=1,class="edit",name="vid", value=""..videoname.."",},
	{x=1,y=1,width=1,class="dropdown",name="targ",value=targ,items={"Same as source","Custom:"}},
	{x=0,y=1,width=1,height=1,class="label",label="Target Simpan :",},
    {x=2,y=1,width=6,height=1,class="edit",name="target", value=""..target.."",},

	}
	 repeat
P,res=ADD(GUI,
{"Proses","Target Simpan","Kembali"},{ok='Proses',close='Kembali'})
if P=="Target Simpan" then
tgt_path=aegisub.dialog.open("Targetkan pada folder tempat ingin disimpan (Pilih salah satu file dalam folder)",".",scriptpath,"",false,false)
aaa = io.open(tgt_path)
if tgt_path then tgt_path=tgt_path:gsub("(.*\\).-$","%1") end
gui("target",tgt_path)
end
until P=="Proses" or P=="Kembali"
if P=="Kembali" then    aegisub.cancel() end
if res.targ=="Custom:" then target=res.target end
vfull=target..videoname
vfull2=vpath..videoname
noob=res.target..videoname
noob1=vpath.."\\scx.bat"
noob2=target.."\\scx.bat"
vsm=0
----------

--------------------------------------------------------
--Proses Inti---
if res.targ=="Custom:" then
skrup="@echo off \necho Making SCXvid keyframes...\n set video="..vfull2.."\nset video2="..vfull2.." \necho FFvideosource(\"%video%\") > \"%video%_keyframes.avs\" \necho SCXvid(\""..noob.."_keyframes.log\") >> \"%video%_keyframes.avs\" \navsmeter \"%video%_keyframes.avs\" \ndel \"%video%_keyframes.avs\" \ndel \"%video%.ffindex\" \ndel \""..noob1.." \necho Keyframes complete @pause"
else
skrup="@echo off \necho Making SCXvid keyframes...\n set video="..vfull.."\nset video2="..vfull.." \necho FFvideosource(\"%video%\") > \"%video%_keyframes.avs\" \necho SCXvid(\"%video%_keyframes.log\") >> \"%video%_keyframes.avs\" \navsmeter \"%video%_keyframes.avs\" \ndel \"%video%_keyframes.avs\" \ndel \"%video%.ffindex\" \ndel \""..noob2.." \necho Keyframes complete @pause"
end

batch=scriptpath.."scx.bat"
batch1=vpath.."scx.bat"

local nice=io.open(vpath.."scx.bat","w")
nice:write(skrup)
nice:close()

 -- proses scxvid --
if res.targ=="Custom:" then
info="Video yang digunakan: "..vfull2.."\nTarget Simpan: "..target.."\n\nSudah yakin benar?"
else
info="Video yang digunakan: "..vfull.."\nTarget Simpan: "..target.."\n\nSudah yakin benar?" end
P=ADD({{class="label",label=info}},{"Ya","Tidak"},{ok='Ya',close='Tidak'})
if P=="Ya" then

	aegisub.progress.title("Memproses...")
	batch=batch:gsub("%=","^=")
	os.execute(quo(batch1))

end
end
-----------

function gui(a,b)
  for k,v in ipairs(GUI) do
    if b==nil then b="" end
    if v.name==a then v.value=b else v.value=res[v.name] end
  end
end

-----------
function quo(x) x="\""..x.."\"" return x end
----
function t_error(message,cancel)
ADD({{class="label",label=message}},{"OK"},{close='OK'})
if cancel then ak() end
end

if haveDepCtrl then depRec:registerMacro(hayoapaini) else aegisub.register_macro(script_name,script_description,hayoapaini) end
