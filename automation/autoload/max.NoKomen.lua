script_name="NoKomen - Hapus {Komentar} (seleksi)"
script_description="Menghilangkan titik-titik-titik."
script_author="Max FireHeart"
script_version="1.0"

function nokomen(subs, sel)
    for x, i in ipairs(sel) do
        line=subs[i]
        text=line.text
		:gsub("{[^\\}]-}","")

		:gsub("{[^\\}]-\\N[^\\}]-}","")
	    
		:gsub("^({[^}]-}) *","%1")
	    
		:gsub(" *$","")			
	line.text=text
        subs[i]=line
    end
    aegisub.set_undo_point(script_name)
    return sel
end

aegisub.register_macro(script_name, script_description, nokomen)