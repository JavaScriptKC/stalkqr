generateUniqueIdentifier = (a, b) ->
  b = a = ""
  while a++ < 36
    b += (if a * 51 & 52 then (if a ^ 15 then 8 ^ Math.random() * (if a ^ 20 then 16 else 4) else 4).toString(16) else "-")
  b

generate = (count = 1) ->
	if count > 0 then (generateUniqueIdentifier() for x in [0...count]) else []
			
codes = 
	generate: generate

module.exports = codes