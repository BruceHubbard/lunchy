Template.group_detail.events({
	'submit .ballot form': (e, t) ->
		e.preventDefault()

		restInput = t.find('input.restaurant')

		Meteor.call('vote', Session.get('slug'), restInput.value, (err, result) ->
			console.log("Voted")
		)
})