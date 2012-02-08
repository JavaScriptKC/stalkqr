vm =
	generatedCodes: new ko.observableArray() 
	generateNew: ->
		$.post '/generate',
			(result) =>
				@generatedCodes.push url: result.url

ko.applyBindings vm