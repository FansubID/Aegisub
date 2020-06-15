-- Copyright (c) 2018, Fmohican
-- Romanizer for Aegisub

local tr = aegisub.gettext

script_name = tr"Romanizer"
script_description = tr"Replace old diacritics with new one"
script_author = "Fmohican"
script_version = "1.0.2"

function all(subs, sel)
    for _, i in ipairs(sel) do
        local line = subs[i]
        line.text = line.text:gsub("ş", "ț") --Found this in some subs, maybe will help maybe not.
        line.text = line.text:gsub("Þ", "Ț")
        line.text = line.text:gsub("º", "ș")
        line.text = line.text:gsub("þ", "ț")
        line.text = line.text:gsub("ª", "Ș")
        line.text = line.text:gsub("ã", "ă")
        line.text = line.text:gsub("Ã", "Ă")
		--2nd set of non romanian diacritics
		line.text = line.text:gsub("ă", "ă")
		line.text = line.text:gsub("î", "î")
		line.text = line.text:gsub("ş", "ș")
		line.text = line.text:gsub("ţ", "ț")
		line.text = line.text:gsub("â", "â")
		line.text = line.text:gsub("Ă", "Ă")
		line.text = line.text:gsub("Î", "Î")
		line.text = line.text:gsub("Ş", "Ș")
		line.text = line.text:gsub("Ţ", "Ț")
		line.text = line.text:gsub("Â", "Â")
        subs[i] = line
    end
    aegisub.set_undo_point(tr"WinEncode -> Standard (UTF-8)")
end

function legacy(subs, sel)
    for _, i in ipairs(sel) do
        local line = subs[i]
		line.text = line.text:gsub("ă", "ă")
		line.text = line.text:gsub("Ă", "Ă")
		line.text = line.text:gsub("â", "â")
		line.text = line.text:gsub("Â", "Â")
		line.text = line.text:gsub("ţ", "ț")
		line.text = line.text:gsub("Ţ", "Ț")
		line.text = line.text:gsub("î", "î")
		line.text = line.text:gsub("Î", "Î")
		line.text = line.text:gsub("ş", "ș")
		line.text = line.text:gsub("Ş", "Ș")
        subs[i] = line
    end
    aegisub.set_undo_point(tr"Romanizer Legacy -> Standard")
end

aegisub.register_macro(script_name .. "/Wrong Encode -> Standard", script_description, all)

aegisub.register_macro(script_name .. "/Legacy -> Standard", script_description, legacy)
