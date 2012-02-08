vm =
	generatedCodes: new ko.observableArray() 
	generateNew: ->
		$.post '/generate',
			(result) =>
				@generatedCodes.push url: result.url
	events: new ko.observableArray([{name:'one'},{name:'two'}])

ko.applyBindings vm