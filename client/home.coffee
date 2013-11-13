Template.home.events({
	'submit form': (e, t) ->
		e.preventDefault()

		slug = URLify2(t.find('input.name').value)
		Router.go('/g/' + slug)
})