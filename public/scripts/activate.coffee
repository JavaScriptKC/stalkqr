$ ->
	$('#activate').click ->
		console.log $(@).data 'id'
		$.post '/activate/' + $(@).data('id').toString(), 
			(res) ->
				if res.result
					$('#activationSuccess').fadeIn()
				#todo error