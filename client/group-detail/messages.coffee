Template.messages.events({
	'submit form.input': (e,t) ->
		e.preventDefault()
		messageBox = t.find('input.message')
		Meteor.call('addMessage', Session.get('slug'), messageBox.value)
		messageBox.value = ""
		messageBox.focus()
})

Template.messages.preserve(['form input.message'])