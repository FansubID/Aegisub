export script_name        = "dreamer2908's sleep bag"
export script_description = "A collection of random (and useless) stuff"
export script_author      = "dreamer2908"
export script_version     = "0.2.0"

local *

macroNamePrefix = 'Replace Stuff / '

stringStartsWith = (s, text) ->
	if type(s) != "string" or type(text) != "string"
		return false
	return string.sub(s, 1, #text) == text

stringEndsWith = (s, text) ->
	if type(s) != "string" or type(text) != "string"
		return false
	return string.sub(s, 0 - #text) == text

escapePattern = (s) ->
	specialChars = { "%", ".", "(", ")", "*", "^", "[", "]", "-", "+", "?", }
	for spec in pairs(specialChars)
		s = string.gsub(s, spec, "%"..spec)
	return s

stringSplit = (s, sep) ->
	result = {}
	count = 1
	sep = escapePattern(sep) -- required if the separator is normal text
	i, j = string.find(s, sep) -- basically search for the sep, and copy texts between them to result
	startPos = 1
	while i != nil
		result[count] = string.sub(s, startPos, i - 1)
		count += 1
		startPos = j + 1 -- still works even when a separator is right next to
		i, j = string.find(s, sep, j + 1)
	result[count] = string.sub(s, startPos)
	return result

interpolateNumber = (t1, t2, t, accel, startVal, endVal) ->
	-- check sanity
	if t1 == t2 or type(startVal) != type(endVal) or type(accel) != "number" or type(t1) != "number" or type(t2) != "number" or type(t) != "number" or type(startVal) != "number" or type(endVal) != "number"
		return endVal
	-- formula from ASS specs
	coefficient = math.pow((t - t1) / (t2 - t1), accel)
	return startVal + (endVal - startVal) * coefficient

-- Placeholder for moar (?) processing
replaceQuotes = (text) ->
	startPos = 1
	quotePos = string.find(text, '"')
	quoteCount = 0
	length = string.len(text)
	result = ''

	while quotePos != nil
		prevChar = ''
		nextChar = ''
		next2Char = ''
		if quotePos > 1
			prevChar = string.sub(text, quotePos - 1 , quotePos - 1)
		if quotePos < length
			nextChar = string.sub(text, quotePos + 1 , quotePos + 1)
		if quotePos < length - 1
			next2Char = string.sub(text, quotePos + 1 , quotePos + 2)
		if quotePos == 1 or (quotePos != length and (prevChar == ' ' or prevChar == '}' or nextChar == '"' or prevChar == '(' or prevChar == '[' or prevChar == '+' or prevChar == '-' or prevChar == '{' or prevChar == '='))
			result = result..string.sub(text, startPos, quotePos-1)..'“'
		elseif quotePos == length or (prevChar == '"' and nextChar == ' ') or nextChar == ' ' or nextChar == '.' or prevChar == '.' or nextChar == ',' or prevChar == ',' or nextChar == ';' or prevChar == ';' or nextChar == '+' or nextChar == '=' or nextChar == ')' or nextChar == '!' or nextChar == ':' or nextChar == ']' or nextChar == '-' or nextChar == '?' or nextChar == '!'
			result = result..string.sub(text, startPos, quotePos-1)..'”'
		else
			result = result..string.sub(text, startPos, quotePos)
		startPos = quotePos + 1
		quotePos = string.find(text, '"', startPos)

	result = result..string.sub(text, startPos)
	return result
	-- return string.gsub(text, "\"(.-)\"", "“%1”") -- old backup

replaceSingleQuotes = (text) ->
	startPos = 1
	quotePos = string.find(text, "'")
	quoteCount = 0
	length = string.len(text)
	result = ''

	while quotePos != nil
		prevChar = ''
		nextChar = ''
		next2Char = ''
		nextnextChar = ' '
		nextnextnextChar = ' '
		if quotePos > 1
			prevChar = string.sub(text, quotePos - 1, quotePos - 1)
		if quotePos < length
			nextChar = string.sub(text, quotePos + 1, quotePos + 1)
		if quotePos < length - 1
			next2Char = string.sub(text, quotePos + 1, quotePos + 2)
			nextnextChar = string.sub(text, quotePos + 2, quotePos + 2)
		if quotePos < length - 2
			nextnextnextChar = string.sub(text, quotePos + 3, quotePos + 3)
		if quotePos == 1 or (quotePos != length and (prevChar == ' ' or prevChar == '}' or nextChar == '"' or prevChar == '(' or prevChar == '[' or prevChar == '+' or prevChar == '-' or prevChar == '{' or prevChar == '='))
			result = result..string.sub(text, startPos, quotePos-1)..'‘'
		elseif quotePos == length or (prevChar == "'" and nextChar == ' ') or nextChar == ' ' or nextChar == '.' or prevChar == '.' or nextChar == ',' or prevChar == ',' or nextChar == ';' or prevChar == ';' or nextChar == '+' or nextChar == '=' or nextChar == ')' or nextChar == '!' or nextChar == ':' or nextChar == ']' or nextChar == '-' or (prevChar != ' ' and (((nextChar == 't' or nextChar == 'd' or nextChar == 's' or next2Char == 'll' or nextChar == 'm') and nextnextChar == ' ') or (next2Char == 're' and nextnextnextChar == ' ')))
			result = result..string.sub(text, startPos, quotePos-1)..'’'
		else
			result = result..string.sub(text, startPos, quotePos)
		startPos = quotePos + 1
		quotePos = string.find(text, "'", startPos)

	result = result..string.sub(text, startPos)
	return result
	-- return string.gsub(text, "'(.-)'", "‘%1’") -- old backup

replaceEllipsis = (text) ->
	return string.gsub(text, "-", "—")
	
replaceLinebreakDash = (text) ->
	return string.gsub(text, "\\N", "—")
	
replaceApostrophe = (text) ->
	return string.gsub(text, "'", "’")
	
replaceE = (text) ->
	return string.gsub(text, "*e", "é")
	
replacePoke = (text) ->
	return string.gsub(text, "Poke", "Poké")
	
replaceFakeEmdash = (text) ->
	return string.gsub(text, "-", "{\\fscx250}-{\\fscx}")
	
replaceHideTags = (text) ->
	return string.gsub(text, "\\", "//")
	
replaceUnhideTags = (text) ->
	return string.gsub(text, "//", "\\")
	
replaceLineBlock = (text) ->
	return string.gsub(text, "\\N", "{}")

replaceLineBlock2 = (text) ->
	return string.gsub(text, "`", "{}")

replaceStrikefont = (text) ->
	return string.gsub(text, "\\s1", "\\fn")
	
replaceremp1 = (text) ->
	return string.gsub(text, "\\p1", "")
	
replaceremp2 = (text) ->
	return string.gsub(text, "\\p0", "")
	
replaceremel1 = (text) ->
	return string.gsub(text, " ... ", " ")

replaceremel2 = (text) ->
	return string.gsub(text, " ..., ", " ")
	
replaceremel3 = (text) ->
	return string.gsub(text, " ...", " ")

replaceremel4 = (text) ->
	return string.gsub(text, ", ... ", "")	
	
replaceremel5 = (text) ->
	return string.gsub(text, ", ....", "")
	
replaceremel6 = (text) ->
	return string.gsub(text, "... ", "")
	
replaceremel7 = (text) ->
	return string.gsub(text, "..., ", "")
	
replaceremel8 = (text) ->
	return string.gsub(text, " ....", "")
	
trimEliminateEllipsis = (text) ->
	return string.gsub(text, "%s*%.%.%.", "")
	
	
-- End of placeholder

validateSelected = (subtitle, selected, active) ->
	if #selected > 0
		return true
	return false

replaceApostropheSelected = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = replaceApostrophe(line.text)
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Apostrophe (selected lines)")
	return selected	
	
replaceFakeEmdashSelected = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = replaceFakeEmdash(line.text)
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Ellipsis (selected lines)")
	return selected
	
trimEliminateEllipsisSelected = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = trimEliminateEllipsis(line.text)
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Delete Ellipsis (selected lines)")
	return selected	

replaceESelected = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = replaceE(line.text)
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."é (selected lines)")
	return selected	
	
replacePokeSelected = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = replacePoke(line.text)
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Poké (selected lines)")
	return selected	
	
replaceQuotesAll = (subtitle, selected, active) ->
	num_lines = #subtitle
	for i = 1, num_lines
		line = subtitle[i]
		if line.class == "dialogue"
			line.text = replaceQuotes(line.text)
			subtitle[i] = line
	aegisub.set_undo_point(macroNamePrefix.."Double quotes (all lines)")
	return selected

replaceQuotesSelected = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = replaceQuotes(line.text)
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Double quotes (selected lines)")
	return selected

replaceSingleQuotesAll = (subtitle, selected, active) ->
	num_lines = #subtitle
	for i = 1, num_lines
		line = subtitle[i]
		if line.class == "dialogue"
			line.text = replaceSingleQuotes(line.text)
			subtitle[i] = line
	aegisub.set_undo_point(macroNamePrefix.."Single quotes (all lines)")
	return selected

replaceSingleQuotesSelected = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = replaceSingleQuotes(line.text)
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Single quotes (selected lines)")
	return selected

replaceHideTagsSelected = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = replaceHideTags(line.text)
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Hide Tags (selected lines)")
	return selected
	
replaceUnhideTagsSelected = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = replaceUnhideTags(line.text)
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Unhide Tags (selected lines)")
	return selected

replaceLineBlockSelected = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = replaceLineBlock(line.text)
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Linebreak to Block (selected lines)")
	return selected
	
replaceLineBlock2Selected = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = replaceLineBlock2(line.text)
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."` to Block (selected lines)")
	return selected
	
replaceStrikefontSelected = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = replaceStrikefont(line.text)
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Strikefont (selected lines)")
	return selected
	
replaceLinebreakDashtSelected = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = replaceLinebreakDash(line.text)
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Linebreak to Dash (selected lines)")
	return selected
	
replaceEllipsisAllDialog = (subtitle, selected, active) ->
	num_lines = #subtitle
	for i = 1, num_lines
		line = subtitle[i] -- A line is considered dialog if its style starts with "Default" or "Alt"
		if line.class == "dialogue" and (stringStartsWith(line.style, "Default") or stringStartsWith(line.style, "Alt"))
			line.text = replaceEllipsis(line.text)
			subtitle[i] = line
	aegisub.set_undo_point(macroNamePrefix.."Ellipsis (dialog)")
	return selected

replaceEllipsisAll = (subtitle, selected, active) ->
	num_lines = #subtitle
	for i = 1, num_lines
		line = subtitle[i]
		if line.class == "dialogue"
			line.text = replaceEllipsis(line.text)
			subtitle[i] = line
	aegisub.set_undo_point(macroNamePrefix.."Ellipsis (all lines)")
	return selected

replaceEllipsisSelected = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = replaceEllipsis(line.text)
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Ellipsis (selected lines)")
	return selected

replaceQuotesEllipsis_selected = (subtitle, selected, active) ->
	replaceQuotesSelected(subtitle, selected, active)
	replaceSingleQuotesSelected(subtitle, selected, active)
	replaceEllipsisSelected(subtitle, selected, active)
	return selected

replaceQuotesEllipsis_all = (subtitle, selected, active) ->
	replaceQuotesAll(subtitle, selected, active)
	replaceSingleQuotesAll(subtitle, selected, active)
	replaceEllipsisAll(subtitle, selected, active)
	return selected

addTagSSPS = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = '{\\fn}'..line.text
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Add tag {\\fn}")
	return selected

joinConsecutiveTagBlocks = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = string.gsub(line.text, "}{\\", "\\") -- just clean up curly brackets with slashes. Probably safe
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Join consecutive tag blocks")
	return selected

setMaskAsDone = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.style = "Signs"
		line.actor = "Done"
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Mark as Done && set style Signs")
	return selected

setWaitTL = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.style = "Signs"
		line.actor = "Wait TL"
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Set wait for TL")
	return selected

stripN = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		parts = stringSplit(line.text, "\\N")
		joint = ""
		for i, v in ipairs(parts)
			-- insert a space if there's none between this and the last one
			-- don't bother to check if more than one space is already there. Might be intentional(?) Not my fault.
			if stringEndsWith(joint, " ") or stringStartsWith(v, " ") or #v == 0 or #joint == 0
				joint ..= v
			else
				joint ..= " "..v
		-- line.text = joint..#parts
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Strip \\N")
	return selected

trimEliminateDoubleSpace = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		text = string.gsub(line.text, " +", " ") -- double spaces -> single spaces
		text = string.gsub(text, " *(.-) *$", "%1") -- trim beginning + end. (.*) is too greedy: it will take the space at the end, too
		line.text = text
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Trim && eliminate double spaces")
	return selected

animateTagsAcrossMultiLines = (subtitle, selected, active) ->
	if #selected < 2
		return selected

	startVal = 0
	endVal = 8
	curLine = 1
	lineNum = #selected
	accel = 0.7

	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = "{\\shad"..string.format("%.2f", interpolateNumber(1, lineNum, curLine, accel, startVal, endVal)).."}"..line.text
		curLine += 1
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Add \\shad from 0 to 4.5")
	return selected

mergeLinearFbfMotion = (subtitle, selected, active) ->
	if #selected < 2 or (#selected % 2 != 0)
		return selected

	lineCount = #selected / 2

	for i = 1, lineCount
		line1 = subtitle[selected[i]]
		line2 = subtitle[selected[i + lineCount]]

		s1, s2 = string.match(line1.text, "\\pos%((%--[%d%.]+),(%--[%d%.]+)%)")
		t1, t2 = string.match(line2.text, "\\pos%((%--[%d%.]+),(%--[%d%.]+)%)")
		moveTag = string.format("\\move(%s,%s,%s,%s)", (s1), (s2), (t1), (t2))
		line1.text = string.gsub(line1.text, "\\pos%((%--[%d%.]+),(%--[%d%.]+)%)", moveTag)

		line1.end_time = line2.end_time

		subtitle[selected[i]] = line1

	aegisub.set_undo_point(macroNamePrefix.."Merge linear fbf motion")
	return selected

formatFloatAlt = (number, rounding) ->
	-- not slow like I though. On 1 core of my C2D T6600, running formatFloat 1 million 1 times (-1000 to 1000, step 0.002) took 3s
	-- note about this alternative way of rounding:
	-- result will be rounded to multiple of rounding paramenter
	-- for example: rounding = 0.05, result will be like 0.05, 0.1, 0.15, 0.2, 0.25, 0.3
	if type(number) != 'number'
		if type(number) == 'string'
			return number
		else
			return ''
	if type(rounding) != 'number' or rounding < 0
		rounding = 0.05
	number = math.floor(number / rounding  + 0.5) * rounding
	output = ''
	if number < 0
		output = '-'
		number = -number
	output ..= string.format('%d', number)
	fraction = number % 1
	output2 = string.format('%g', fraction)
	return output..string.sub(output2, 2)

parseDisLine_slim = (line) ->
	if type(line) != "string"
		return {}

	-- split line into tag blocks and associated texts
	tmpLineData = {}
	karma = 0
	start = 1

	-- get the first text block without tags, if any
	if not stringStartsWith(line, "{")
		start = string.find(line, "{")
		if start == nil
			start = #line + 1
		text = string.sub(line, 1, start - 1)
		tag = ''
		table.insert(tmpLineData, {:tags, :text})

	tagStart = 1
	for i = start, #line
		char = string.sub(line, i, i)
		if char == "{" or char == "}"
			if char == "{"
				if karma == 0
					karma = 1
					tagStart = i
			elseif char == "}"
				if karma == 1
					tags = string.sub(line, tagStart + 1, i - 1)
					nextBracket = string.find(line, "{", i + 1)
					if nextBracket == nil
						nextBracket = #line + 1
					text = string.sub(line, i + 1, nextBracket - 1)
					table.insert(tmpLineData, {:tags, :text})
				-- Keep karma in 0-1 range to fix broken typesetters {{\an8}This line is... {\i1}}}}broken
				karma = 0

	return tmpLineData

writeDisLine_textOnly = (lineData) ->
	line = ''
	if type(lineData) != 'table'
		return line
	for i, textBlock in ipairs(lineData)
		tags = textBlock["tags"]
		text = textBlock["text"]
		-- if string.len(tags) > 0 and not textOnly
		-- 	line ..= "{"..tags.."}"
		line ..= text
	return line

writeDisLine_slim = (lineData) ->
	line = ''
	if type(lineData) != 'table'
		return line
	for i, textBlock in ipairs(lineData)
		tags = textBlock["tags"]
		text = textBlock["text"]
		if string.len(tags) > 0
			line ..= "{"..tags.."}"
		line ..= text
	return line

-- TODO: expand its function to block consisting of several different lines like mocha text
jumpToNextBlock = (subtitle, selected, active) ->
	thisIndex = selected[1]
	thisLine = subtitle[thisIndex]
	thisText = writeDisLine_textOnly(parseDisLine_slim(thisLine.text))
	nextBlockIndex = nil
	lineCount = #subtitle

	for i = thisIndex, lineCount
		if subtitle[i].class == "dialogue"
			text = writeDisLine_textOnly(parseDisLine_slim(subtitle[i].text))
			if text != thisText
				nextBlockIndex = i
				break

	if nextBlockIndex == nil
		nextBlockIndex = thisIndex

	return {nextBlockIndex}

jumpToPrevBlock = (subtitle, selected, active) ->
	thisIndex = selected[1]
	thisLine = subtitle[thisIndex]
	thisText = writeDisLine_textOnly(parseDisLine_slim(thisLine.text))

	prevBlockIndex = nil
	prevText = ''
	state = 1 -- 1 = still in current block, 2 = in the previous block, moving to its beginning

	for i = thisIndex, 1, -1
		if subtitle[i].class == "dialogue"
			text = writeDisLine_textOnly(parseDisLine_slim(subtitle[i].text))
			if state == 1
				if text != thisText
					state = 2
					prevText = text
			else
				if text != prevText
					prevBlockIndex = i + 1
					break

	if prevBlockIndex == nil
		prevBlockIndex = thisIndex

	return {prevBlockIndex}

selectCurrentBlock_lite = (subtitle, selected, active) ->
	thisIndex = selected[1]
	thisLine = subtitle[thisIndex]
	thisText = writeDisLine_textOnly(parseDisLine_slim(thisLine.text))
	thisBlockStartIndex = thisIndex
	thisBlockEndIndex = thisIndex
	lineCount = #subtitle

	for i = thisIndex, lineCount
		if subtitle[i].class == "dialogue"
			text = writeDisLine_textOnly(parseDisLine_slim(subtitle[i].text))
			if text != thisText
				thisBlockEndIndex = i - 1
				break

	for i = thisIndex, 1, -1
		if subtitle[i].class == "dialogue"
			text = writeDisLine_textOnly(parseDisLine_slim(subtitle[i].text))
			if text != thisText
				thisBlockStartIndex = i + 1
				break

	toBeSelected = {}
	for i = thisBlockStartIndex, thisBlockEndIndex
		table.insert(toBeSelected, i)

	return toBeSelected, thisBlockStartIndex, thisBlockEndIndex

selectCurrentBlock = (subtitle, selected, active) ->
	thisIndex = selected[1]
	thisLine = subtitle[thisIndex]
	thisText = writeDisLine_textOnly(parseDisLine_slim(thisLine.text))
	thisBlockStartIndex = thisIndex
	thisBlockEndIndex = thisIndex
	lineCount = #subtitle

	for i = thisIndex, lineCount
		if subtitle[i].class == "dialogue"
			text = writeDisLine_textOnly(parseDisLine_slim(subtitle[i].text))
			if text != thisText
				thisBlockEndIndex = i - 1
				break

	for i = thisIndex, 1, -1
		if subtitle[i].class == "dialogue"
			text = writeDisLine_textOnly(parseDisLine_slim(subtitle[i].text))
			if text != thisText
				thisBlockStartIndex = i + 1
				break

	if thisBlockStartIndex == thisBlockEndIndex
		-- so we didn't got anything beside current line
		-- maybe this block contains multiple lines with different texts
		-- search for lines that have the same timing lying next to current line
		for i = thisIndex, lineCount
			if subtitle[i].class == "dialogue"
				if thisLine.start_time != subtitle[i].start_time and thisLine.end_time != subtitle[i].end_time
					thisBlockEndIndex = i - 1
					break

		for i = thisIndex, 1, -1
			if subtitle[i].class == "dialogue"
				if thisLine.start_time != subtitle[i].start_time and thisLine.end_time != subtitle[i].end_time
					thisBlockStartIndex = i + 1
					break

		-- search for groups of lines that have the same text as the first group in the same order (for now)
		lineInBlockCount = thisBlockEndIndex - thisBlockStartIndex + 1
		if lineInBlockCount > 1
			baseLines = {}
			-- print(lineInBlockCount)
			for i = thisBlockStartIndex, thisBlockEndIndex
				text = writeDisLine_textOnly(parseDisLine_slim(subtitle[i].text))
				table.insert(baseLines, text)
				-- print(text)
			plsContinue = true
			for i = thisBlockEndIndex + 1, lineCount, lineInBlockCount
				for j = 1, lineInBlockCount
					curLine = subtitle[i + j - 1]
					curLineText = writeDisLine_textOnly(parseDisLine_slim(curLine.text))
					if curLineText == baseLines[j]
						thisBlockEndIndex = i + j - 1
					else
						-- print('curLineText == "'..curLineText..'", baseLines['..j..'] = "'..baseLines[j]..'"')
						plsContinue = false
						break
				if not plsContinue
					break

	toBeSelected = {}
	for i = thisBlockStartIndex, thisBlockEndIndex
		table.insert(toBeSelected, i)

	return toBeSelected, thisBlockStartIndex, thisBlockEndIndex

jumpToSelectionEnd = (subtitle, selected, active) ->
	return selected, selected[#selected]

jumpToSelectionStart = (subtitle, selected, active) ->
	return selected, selected[1]

deleteNonTS = (subtitle, selected, active) ->
	lineCount = #subtitle
	deleleteMe = {}
	for i,line in ipairs(subtitle)
		if line.class == 'dialogue'
			if not stringStartsWith(line.style, "Sign")
				table.insert(deleleteMe, i)
	subtitle.delete(deleleteMe)

shiftPosition = (text, offsetX, offsetY) ->
	posReg = "\\pos%((%--%+-[%d%.]+),(%--%+-[%d%.]+)%)"
	moveReg1 = "\\move%((%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+)%)"
	moveReg2 = "\\move%((%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+)%)"

	rounding = 0.05
	shiftPos = (posX, posY) ->
		return string.format("\\pos(%s,%s)", formatFloatAlt(posX + offsetX, rounding), formatFloatAlt(posY + offsetY, rounding))
	shiftMove1 = (v1, v2, v3, v4) ->
		return string.format("\\move(%s,%s,%s,%s)", formatFloatAlt(v1 + offsetX, rounding), formatFloatAlt(v2 + offsetY, rounding), formatFloatAlt(v3 + offsetX, rounding), formatFloatAlt(v4 + offsetY, rounding))
	shiftMove2 = (v1, v2, v3, v4, v5, v6) ->
		return string.format("\\move(%s,%s,%s,%s,%s,%s)", formatFloatAlt(v1 + offsetX, rounding), formatFloatAlt(v2 + offsetY, rounding), formatFloatAlt(v3 + offsetX, rounding), formatFloatAlt(v4 + offsetY, rounding), formatFloatAlt(v5, rounding), formatFloatAlt(v6, rounding))

	text = string.gsub(text, posReg, shiftPos)
	text = string.gsub(text, moveReg1, shiftMove1)
	text = string.gsub(text, moveReg2, shiftMove2)

	return text

shiftPosition_x_plus2 = (subtitle, selected, active) ->
	for si, li in ipairs(selected)
		line = subtitle[li]
		line.text = shiftPosition(line.text, 1, 0)
		subtitle[li] = line

shiftPosition_y_plus2 = (subtitle, selected, active) ->
	for si, li in ipairs(selected)
		line = subtitle[li]
		line.text = shiftPosition(line.text, 0, 1)
		subtitle[li] = line

shiftPosition_x_minus2 = (subtitle, selected, active) ->
	for si, li in ipairs(selected)
		line = subtitle[li]
		line.text = shiftPosition(line.text, -1, 0)
		subtitle[li] = line

shiftPosition_y_minus2 = (subtitle, selected, active) ->
	for si, li in ipairs(selected)
		line = subtitle[li]
		line.text = shiftPosition(line.text, 0, -1)
		subtitle[li] = line

replaceTextInCurrentBlock = (subtitle, selected, active) ->
	lineCount = #subtitle
	thisIndex = selected[1]
	if thisIndex == lineCount -- you're not supposed to select the last line
		return
	thisLine = subtitle[thisIndex]
	thisBlockEndIndex = thisIndex -- you're supposed to select the first line
	thisText = writeDisLine_textOnly(parseDisLine_slim(subtitle[thisIndex+1].text))

	for i = thisIndex + 1, lineCount
		text = writeDisLine_textOnly(parseDisLine_slim(subtitle[i].text))
		if text != thisText
			thisBlockEndIndex = i - 1
			break

	firstLineData = parseDisLine_slim(thisLine.text)
	for i = thisIndex + 1, thisBlockEndIndex
		line = subtitle[i]
		lineData = parseDisLine_slim(line.text)
		if #lineData <= #firstLineData
			for j = 1, #lineData
				textBlock = lineData[j]
				firstLineTextBlock = firstLineData[j]
				textBlock['text'] = firstLineTextBlock['text']
		else
			for j = 1, #firstLineData
				textBlock = lineData[j]
				firstLineTextBlock = firstLineData[j]
				textBlock['text'] = firstLineTextBlock['text']
		line.text = writeDisLine_slim(lineData)
		subtitle[i] = line

	return selected

replaceTextInCurrentBlock_experimental = (subtitle, selected, active) ->
	lineCount = #subtitle
	thisIndex = selected[1]
	if thisIndex == lineCount -- you're not supposed to select the last line
		return
	thisLine = subtitle[thisIndex]
	thisBlockEndIndex = thisIndex -- you're supposed to select the first line
	thisText = writeDisLine_textOnly(parseDisLine_slim(subtitle[thisIndex+1].text))

	for i = thisIndex + 1, lineCount
		text = writeDisLine_textOnly(parseDisLine_slim(subtitle[i].text))
		if text != thisText
			thisBlockEndIndex = i - 1
			break

	firstLineData = parseDisLine_slim(thisLine.text)
	for i = thisIndex + 1, thisBlockEndIndex
		line = subtitle[i]
		lineData = parseDisLine_slim(line.text)
		if #lineData <= #firstLineData
			for j = 1, #lineData
				textBlock = lineData[j]
				firstLineTextBlock = firstLineData[j]
				textBlock['text'] = firstLineTextBlock['text']
		else
			for j = 1, #firstLineData
				textBlock = lineData[j]
				firstLineTextBlock = firstLineData[j]
				textBlock['text'] = firstLineTextBlock['text']
		line.text = writeDisLine_slim(lineData)
		subtitle[i] = line

	return selected

-- aegisub.register_macro(macroNamePrefix.."Add tag {\\fn}", "Add tag {\\n}", addTagSSPS)
aegisub.register_macro(macroNamePrefix.."Merge Linear FBF Motion", "Select the first and the last frames' lines", mergeLinearFbfMotion)
aegisub.register_macro(macroNamePrefix.."Double Quotes (all lines)", "Replace", replaceQuotesAll)
aegisub.register_macro(macroNamePrefix.."Double Quotes (selected lines)", "Replace", replaceQuotesSelected)
aegisub.register_macro(macroNamePrefix.."Single Quotes (selected lines)", "Replace", replaceSingleQuotesSelected)
aegisub.register_macro(macroNamePrefix.."Em Dash (selected lines)", "Replace", replaceEllipsisSelected)
aegisub.register_macro(macroNamePrefix.."Fake Em Dash (selected lines)", "Replace", replaceFakeEmdashSelected)
aegisub.register_macro(macroNamePrefix.."Linebreak to Em Dash (selected lines)", "Replace", replaceLinebreakDashtSelected)
-- aegisub.register_macro(macroNamePrefix.."Shift position x plus 2", "", shiftPosition_x_plus2, validateSelected)
-- aegisub.register_macro(macroNamePrefix.."Shift position y plus 2", "", shiftPosition_y_plus2, validateSelected)
-- aegisub.register_macro(macroNamePrefix.."Shift position x minus 2", "", shiftPosition_x_minus2, validateSelected)
-- aegisub.register_macro(macroNamePrefix.."Shift position y minus 2", "", shiftPosition_y_minus2, validateSelected)
aegisub.register_macro(macroNamePrefix.."Apostrophe (selected lines)", "Replace ", replaceApostropheSelected)
aegisub.register_macro(macroNamePrefix.."Convert *e to é (selected lines)", "Replace", replaceESelected)
aegisub.register_macro(macroNamePrefix.."Convert Poke (selected lines)", "Replace", replacePokeSelected)
aegisub.register_macro(macroNamePrefix.."Hide Tags (selected lines)", "Replace", replaceHideTagsSelected)
aegisub.register_macro(macroNamePrefix.."Unhide Tags (selected lines)", "Replace", replaceUnhideTagsSelected)
aegisub.register_macro(macroNamePrefix.."Linebreak to Block (selected lines)", "Replace", replaceLineBlockSelected)
aegisub.register_macro(macroNamePrefix.."` to Block (selected lines)", "Replace", replaceLineBlock2Selected)
aegisub.register_macro(macroNamePrefix.."Strikefont (selected lines)", "Replace", replaceStrikefontSelected)
aegisub.register_macro(macroNamePrefix.."Position Right (+1)", "", shiftPosition_x_plus2, validateSelected)
aegisub.register_macro(macroNamePrefix.."Position Left (-1)", "", shiftPosition_x_minus2, validateSelected)
aegisub.register_macro(macroNamePrefix.."Position Up (-1)", "", shiftPosition_y_minus2, validateSelected)
aegisub.register_macro(macroNamePrefix.."Position Down (+1)", "", shiftPosition_y_plus2, validateSelected)
aegisub.register_macro(macroNamePrefix.."Trim Double Spaces (selected lines)", "", trimEliminateDoubleSpace)


-- sedikit diutak 
-- TODO: make script to move lines by 2 pixels or so [done]
-- TODO: make a script to set style automatically