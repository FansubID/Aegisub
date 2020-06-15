
local tr = aegisub.gettext

script_name = tr"Fix karaoke keyframes"
script_description = tr"Shift/snap karaoke lines to keyframes and shift \\k tags accordingly."
script_author = "biki-desu"
script_version = "1.0.1"

--Set button labels / id's
--Do it here because it's faster
local t_p = tr"Process"
local t_e = tr"Cancel"
local t_kfmtp = tr"Per-frame"
local t_kfmtc = tr"Consistent average"

--Configuration
local c_keepconfig = true --keep script configuration
local c_shift = false
local c_fs = 0
local c_snap =  true
local c_kfb = 3
local c_kfa = 3
local c_kfmt = 1 --0 means auto, 1 means consistent --if you don't know which one you want, you want consistent

--This is called first, deals with configuration
function script_start(subs, selected_lines, active_line)
    if not c_keepconfig then --Check if we want to keep configuration, if not then reset to default
        c_shift = false
        c_fs = 0
        c_snap =  true
        c_kfb = 3
        c_kfa = 3
        c_kfmt = 1
    end

    agi_dialog = {
        { class = "checkbox"; x = 0; y = 0; width = 2; height = 1; hint = tr"Enable manual frame shift"; name = "shift"; label = tr"Manual frame shift:"; value = c_shift; },
        { class = "label";    x = 0; y = 1; width = 2; height = 1; label = tr"Frames to shift:"; },
        { class = "intedit";  x = 2; y = 1; width = 2; height = 1; hint = tr"Frames to shift"; name = "fs"; value = c_fs; min = -250; max = 250; step = 1; },
        { class = "checkbox"; x = 0; y = 2; width = 2; height = 1; hint = tr"Enable auto snapping to keyframes"; name = "snap"; label = tr"Auto-snapping to keyframes:"; value = c_snap; },
        { class = "label";    x = 0; y = 3; width = 2; height = 1; label = tr"Frames to search forward:"; },
        { class = "intedit";  x = 2; y = 3; width = 2; height = 1; hint = tr"Frames to search forward"; name = "kfb"; value = c_kfb; min = 1; max = 250; step = 1; },
        { class = "label";    x = 0; y = 4; width = 2; height = 1; label = tr"Frames to search back:"; },
        { class = "intedit";  x = 2; y = 4; width = 2; height = 1; hint = tr"Frames to search back";    name = "kfa"; value = c_kfa; min = 1; max = 250; step = 1; },
        { class = "label";    x = 0; y = 5; width = 2; height = 1; label = tr"Keyframe matching:"; },
        { class = "dropdown"; x = 2; y = 5; width = 2; height = 1; hint = tr"Keyframe matching"; name = "kfmt"; items = { t_kfmtc, t_kfmtp }; value = c_kfm(); }
    }

    script_gui(subs, selected_lines)
end

--This deals with the script GUI
function script_gui(subs, selected_lines)
    local agi_button, agi_result = aegisub.dialog.display(agi_dialog, {t_p, t_e})
    c_shift = agi_result.shift
    c_fs = agi_result.fs
    c_snap = agi_result.snap
    c_kfb = agi_result.kfb
    c_kfa = agi_result.kfa
    c_kfmt = agi_result.kfmt

    if agi_button == t_e then --Cancel
        aegisub.cancel()
    elseif agi_button == t_p then --Process
        script_process(subs, selected_lines, subs, agi_button)
    else
        fatal(tr"Unknown action requested, cannot continue.")
    end
end

--This does the actual action
function script_process(subs, selected_lines, subs, agi_button)
    local tKaraoke = {}
    for x, i in ipairs(selected_lines) do
        local l = subs[i].text
        if string.find(l, "\\[kK][fot]?") then table.insert(tKaraoke, i) end
    end

    if c_shift == true then
        for _, i in ipairs(tKaraoke) do
            process_karaoke_leadinout(subs, i, c_fs, c_fs)
        end
    end

    if c_snap == true then
        if c_kfm() == t_kfmtc then
            local skeyframes = {}
            local ekeyframes = {}

            for _, i in ipairs(tKaraoke) do
                local l = subs[i]

                fs = aegisub.frame_from_ms(l.start_time)
                fe = aegisub.frame_from_ms(l.end_time)

                for _, kf in ipairs(aegisub.keyframes()) do
                    if kf >= (fs - c_kfb) and kf <= (fs + c_kfa) then table.insert(skeyframes, fs - kf) end
                    if kf >= (fe - c_kfb) and kf <= (fe + c_kfa) then table.insert(ekeyframes, fe - kf) end
                end
            end

            local skft
            if isEmpty(skeyframes) then
                fatal("No valid skeyframes found. Do you have a decent set of keyframes?")
            else
                for i in ipairs(skeyframes) do skft = skft + skeyframes[i] end
            end
            local skfa = round(skft / #skeyframes)

            local ekft
            if isEmpty(ekeyframes) then
                fatal("No valid ekeyframes found. Do you have a decent set of keyframes?")
            else
                for i in ipairs(skeyframes) do ekft = ekft + ekeyframes[i] end
            end
            local ekfa = round(ekft / #ekeyframes)

            for _, i in ipairs(tKaraoke) do
                process_karaoke_leadinout(subs, i, skfa, ekfa)
            end
        else--if c_kfm == t_kfmtp then
            for _, i in ipairs(tKaraoke) do
                local l = subs[i]

                local st = l.start_time
                local et = l.end_time
                local fs = aegisub.frame_from_ms(l.start_time)
                local fe = aegisub.frame_from_ms(l.end_time)

                for _, kf in ipairs(aegisub.keyframes()) do
                    if kf >= (fs - c_kfb) and kf < (fs - c_kfa) then st = aegisub.ms_from_frame(kf) end
                    if kf >= (fe + c_kfb) and kf <= (fe + c_kfa) then et = aegisub.ms_from_frame(kf) end
                end
                
                process_karaoke_leadinout(subs, i, fs - aegisub.frame_from_ms(st), fe - aegisub.frame_from_ms(et))
                
                subs[i] = l
            end
        end
    end
end

--------------------
--Helper Functions--
--------------------

--lazy way of doing error dialogs
function fatal(errtxt)
    aegisub.log(0, errtxt)
    aegisub.cancel()
end
function err(errtxt)
    aegisub.log(1, errtxt)
    aegisub.cancel()
end
function warn(errtxt)
    aegisub.log(2, errtxt)
    aegisub.cancel()
end
function hint(errtxt)
    aegisub.log(0, errtxt)
end

--checks if there is something in the string, now with more types
function isEmpty(x)
    if type(x) == "nil" then
        return true
    elseif type(x) == "string" then
        if x == "" then return true else return false end
    elseif type(x) == "number" then
        return false --a "number" is a result of a calculation, so cannot be empty
    elseif type(x) == "table" then
        if table.concat(x) == "" or table.concat(x) == nil then return true else return false end
    elseif type(x) == "boolean" then
        return false --you're either true or false, so you cannot be empty
    else
        hint(string.format(tr"isEmpty: Cannot check %s type.", type(x)))
        return nil
    end
end

function c_kfm()
    if c_kfmt == 1 then return t_kfmtc else return t_kfmtp end
end

function round(x)
    if x >= math.floor(x) + 0.5 then return math.ceil(x) else return math.floor(x) end
end

function process_karaoke_leadinout(subs, i, nLeadin, nLeadout)
    if isEmpty(i) or i < 0 then fatal(tr"process_karaoke_leadinout: the input line index cannot be empty or negative.") end
    local l = subs[i]

    l.start_time = aegisub.ms_from_frame(aegisub.frame_from_ms(l.start_time) + nLeadin)
    l.end_time = aegisub.ms_from_frame(aegisub.frame_from_ms(l.end_time) + nLeadout)

    local p, q = string.find(l.text, "\\[kK][fot]?(%d+)") --doing it this way because lua's regular expressions suck
    if p == nil or q == nil then fatal("The supported k-tags are: \\k, \\K, \\kf, \\ko, \\kt. Make sure that your karaoke lines kave them!") end
    local r = string.sub(l.text, p, q)

    local ktag = string.match(r, "(\\[kK][fot]?)")
    local kval = string.match(r, "(%d+)") + math.floor((aegisub.ms_from_frame(aegisub.frame_from_ms(l.start_time) - nLeadin) - l.start_time) / 10)

    l.text = string.sub(l.text, 1, p - 1) .. ktag .. kval .. string.sub(l.text, q + 1, #l.text + 1)
    subs[i] = l
end

aegisub.register_macro(script_name, script_description, script_start)
