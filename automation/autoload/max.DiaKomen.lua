script_name="DiaKomen - Ubah Dialog Menjadi {Komentar} (seleksi)"
script_description="Fungsinya seperti namanya dan kebalikannya."
script_author="Max FireHeart"
script_version="1.0"

function diakomen(subs, sel)
    for x, i in ipairs(sel) do
        line=subs[i]
        text=line.text
		:gsub("\\N","_br_")
		
		:gsub("{([^\\}]-)}","}%1{")
		
		:gsub("^([^{]+)","{%1")
		
		:gsub("([^}]+)$","%1}")
		
		:gsub("([^}])({\\[^}]-})([^{])","%1}%2{%3")
		
		:gsub("^({\\[^}]-})([^{])","%1{%2")
		
		:gsub("([^}])({\\[^}]-})$","%1}%2")
		
		:gsub("{}","")
		
		:gsub("_br_","\\N")
		:gsub("%(x","{%(x")
		:gsub("q%)","q%)}")
	line.text=text
        subs[i]=line
    end
    aegisub.set_undo_point(script_name)
    return sel
end

aegisub.register_macro(script_name, script_description, diakomen)