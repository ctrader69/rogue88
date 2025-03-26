extends Node

# I fed the initials, vowels, and finals lists from the python gibberish library
# into bing co-pilot which generated this code.

# Component sets for building gibberish
var initials = ["m", "c", "b", "r", "d", "h", "s", "p", "l", "g", "f", "w", "t", "k", "n", "v", "st", "pr", "j", "br", "ch", "gr", "sh", "tr", "cr", "fr", "z", "sp", "wh", "cl", "y", "bl", "th", "fl", "sch", "pl", "q", "dr", "str", "sc", "sl", "kr", "sw", "gl", "ph", "kl", "sm", "sn", "kn", "sk", "mcc", "scr", "wr", "mc", "chr", "spr", "thr", "tw", "schw", "mcg", "mck", "rh", "sq", "schl", "shr", "schr", "x", "schm", "mcm", "gh", "mcn", "hyp", "mccl", "schn", "mcd", "hydr", "kh", "ts", "mcl", "psych", "spl", "dw", "pf", "mccr", "mcf", "typ", "cz", "sr", "cycl", "gn", "hr", "hy", "syn", "sz", "kw"]
var vowels = ["e", "a", "i", "o", "u", "ia", "ie", "ee", "io", "au", "ea", "ou", "ai", "ue", "ei", "eau", "eu", "oe", "ae", "eo", "oa", "oo", "ao", "ua", "oi", "ui", "aa", "ieu", "uo", "oia", "aue", "iu", "aia", "iou", "ii", "aio", "uie", "eia"]
var finals = ["s", "n", "r", "d", "ng", "l", "y", "rs", "ns", "t", "m", "ll", "nt", "c", "ck", "st", "k", "ss", "sts", "rd", "nd", "ry", "rt", "w", "lly", "tt", "ch", "ts", "ty", "p", "ls", "ld", "nts", "x", "rg", "sh", "ly", "th", "ff", "g", "rn", "ngs", "nn", "tz", "sm", "gh", "ms", "z", "cs", "ps", "h", "ds", "b", "lt", "nk", "nds", "ys", "rk", "ght", "v", "cks", "f", "ct", "rth", "rry", "lls", "ny", "ws", "cts", "wn", "rds", "dy", "bly", "rts", "ft", "hl", "gy", "pp", "rly", "mp", "ntly", "sch", "ngly", "sly", "ks", "tch", "ncy", "rm", "gs", "rty", "hn", "fy", "rst", "rr", "ntz", "bs", "cy", "dly", "tts"]

# Generates a random gibberish word based on initials, vowels, and finals
func word(min_syllables, max_syllables) -> String:
	var word = ""
	var syllables = randi_range(min_syllables, max_syllables)  # Random number of syllables
	for i in range(syllables):
		word += initials[randi() % initials.size()]
		word += vowels[randi() % vowels.size()]
		if randf() < 0.5:  # Randomly decide to add a final or not
			word += finals[randi() % finals.size()]
	return word
	
func sentence_fragment():
	# 11 => 15 characters but excluding leading/trailing ..
	var max = 11
	var result = ""
	while (true):
		var next = word(1, 2)
		var candidate = result + next
		if candidate.length() <= max:
			result = candidate
		else:
			# try for a shorter word
			next = word(1, 1)
			candidate = result + next
			if candidate.length() <= max:
				result = candidate
			else:
				break
		result += " "
	return ".." + result.strip_edges() + ".."
