Template.group_detail.events({
	'submit .ballot form': (e, t) ->
		e.preventDefault()

		restInput = t.find('input.restaurant')

		Meteor.call('vote', Session.get('slug'), restInput.value, (err, result) ->
			console.log("Voted")
		)

	'click .recent a': (e) ->
		e.preventDefault()
		Meteor.call('vote', Session.get('slug'), @.toString())

	'click .group h3': (e) ->
		e.preventDefault()
		Meteor.call('vote', Session.get('slug'), @.name)
})

Template.group_detail.grouped_votes = () ->
	
	grouped = _.groupBy(Votes.currentVotes(Session.get('slug')).fetch(), 'restaurant')

	if(grouped)
		bySize = []

		for restaurant, votes of grouped
			bySize.push({name: restaurant, votes: votes})

		_.sortBy(bySize, (rest) ->
			rest.votes.length
		).reverse()


Template.group_detail.created = () ->
	self = @

	geoSuccess = (p) ->
		console.log("success", p)
		Session.set("can-geo", true)
		Session.set('location', p)

	geoFail = (p) ->
		console.log("failure", p)
		Session.set('can-geo', false)
		Session.set('location', null)

	if(geoPosition.init())
		geoPosition.getCurrentPosition(geoSuccess, geoFail, {enableHighAccuracy:true})
	else
		Session.set("can-geo", false)

	Deps.autorun(() ->
		grouped = _.groupBy(Votes.find().fetch(), 'restaurant')

		if(grouped)
			bySize = []

			for restaurant, votes of grouped
				bySize.push({name: restaurant, votes: votes})

			bySize = _.sortBy(bySize, (rest) ->
				rest.votes.length
			).reverse()

			#boxes = d3.select('.votes .box').data(bySize, (d) -> d.restaurant)
	)
