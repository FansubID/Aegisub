script_name="Halipsis - Hapus Elipsis ... (seleksi)"
script_description="Menghilangkan titik-titik-titik."
script_author="Max FireHeart"
script_version="1.0"

function hallipsis(subs, sel)
    for x, i in ipairs(sel) do
        line=subs[i]
        text=line.text
		:gsub("}%.%.%. ","}")

		:gsub(" %.%.%.%.","%.")

		:gsub("^%.%.%. (%a?)","%1")

		:gsub(" %.%.%.(%p?)","%1")

		:gsub(" %.%.%., (%p?)",", %1")

		:gsub(" %.%.%. (%p?)","%1")

		:gsub(" %.%.%.(%p?)","%1")

		:gsub(" %.%.%. "," ")

		:gsub(" %.%.(%p)","%1")

		:gsub("(%a)%.%.(%p) ","%1%2 ")

		:gsub("^(%.%.%.) ","")

		:gsub("{%.%.%.([%a%p]?) ([%a%p]?)","{%1 %2")

		:gsub("}%.%.%.([%a%p]?) ([%a%p]?)","}%1 %2")

		:gsub("([%a%p])%.%.%.([%a%p])","%1%2")

		:gsub("%.%.%.(%a) ","%1")

		:gsub("  "," ")
	
		:gsub(",,",",")
	
		:gsub(",,,",",")

		:gsub(",,,,",",")

		:gsub("%.({[^}]-})%.","%.%1")
		:gsub("(%a) %. (%a)","%1%. %2")
		:gsub("(%a) %.({[^}]-})","%1%.%2")
		:gsub("(%a) %.%.({[^}]-})","%1 %2")	
		:gsub(" %.%. (%a)"," %1")
		:gsub("\"%.%. (%a)","\"%1")
		:gsub(" %.%.(%a)"," %1")
		:gsub("^%.%.(%a)","%1")
		:gsub("\"%.%.(%a)","\"%1")	
		:gsub("(%a)%.%.$","%1%.")
		:gsub("(%a)%.%.({[^}]-})","%1%.%2")
		:gsub("(%a) %.%.%.({[^}]-})%.","%1%2%.")	
		:gsub("({[^}]-})%.%.(%a)","%1%2")		
	line.text=text
        subs[i]=line
    end
    aegisub.set_undo_point(script_name)
    return sel
end

aegisub.register_macro(script_name, script_description, hallipsis)