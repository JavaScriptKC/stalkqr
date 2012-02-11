generateUniqueIdentifier = (a, b) ->
  b = a = ""
  while a++ < 36
    b += (if a * 51 & 52 then (if a ^ 15 then 8 ^ Math.random() * (if a ^ 20 then 16 else 4) else 4).toString(16) else "-")
  b

urlGenerator = 
	generate: (host, number, event) ->
		i = 0
		qrCodes = []
		console.log number
		while i < number
			uuid = generateUniqueIdentifier()
			if event?
				url = 'http://' + host + '/scan/' + event + '/' + uuid
			else 
				url = 'http://' + host + '/scan/' + uuid
			qrCodes.push(url)
			i++
		return qrCodes
			

codes = 
	generateOne: (host, event) -> 
		urls = urlGenerator.generate(host, 1, event)
		console.log (urls)
		return { url: urls[0] }
		
	generateMany: (host, number, event) ->
		urls: urlGenerator.generate host, number, event

module.exports = codes