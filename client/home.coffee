Template.home.events({
	'submit form': (e, t) ->
		e.preventDefault()

		nameInput = t.find('input.name')

		Meteor.call('addGroup', nameInput.value, (err, result) ->
			console.log(err, result)
			if(!err)
				nameInput.value = ""
				Router.go('/g/' + result.slug)
		)
})