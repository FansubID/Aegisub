script_name="Curcol - {\\s1}Strikethrough{\\s0} Menjadi {Komentar} (seleksi)"
script_description="Mengubah kata yang {\\s1}dicoret{\\s0} menjadi {komentar} dan sebaliknya."
script_author="Max FireHeart"
script_version="1.0"

function curcol(subs, sel)
    for x, i in ipairs(sel) do
        line=subs[i]
        text=line.text
		:gsub("{\\s1}{([^\\}]-)}$","%1")

		:gsub("{\\s[10]}{([^\\}]-)}","%1")

		:gsub("}{\\s0}","")

		:gsub("{\\s1}","{")

		:gsub("{\\s0}","}")

		:gsub("{([^\\{]-){([^\\}]-)}}","{%2}")
		:gsub("{([^\\{}]-){([^\\}]-)}([^\\{}]-)}","{%1(x%2q)%3}")
		:gsub("{([^\\{}]-){([^\\}]-)}([^\\{}]-){([^\\}]-)}([^\\{}]-)}","{%1(x%2q)%3(x%4q)%5}")		
		:gsub("{([^\\}]-)}([^\\{}]-)}","(x%1q)%2")
		:gsub("(%([^\\()]-%))(%([^\\()]-%))","%1")			
	line.text=text
        subs[i]=line
    end
    aegisub.set_undo_point(script_name)
    return sel
end

aegisub.register_macro(script_name, script_description, curcol)