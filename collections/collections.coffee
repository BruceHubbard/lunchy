cutoffTime = () ->
	cutoff = new Date()
	cutoff.setHours(cutoff.getHours() - 5)
	cutoff

@Groups = new Meteor.Collection("Groups")
@Groups.recent = () ->
	if(Meteor.userId)
		votes = Votes.myVotes(@userId)

		if(votes.fetch)
			votes = votes.fetch()

		votedIn = _.pluck(votes, 'group')
		Groups.find({_id: {$in: votedIn}})


@Votes = new Meteor.Collection("Votes")
@Votes.myVotes = (userId) ->
	if(userId)
		Votes.find({user: userId})
	else
		[]
@Votes.myVotesInGroup = (groupId, userId) ->
	if(userId)
		Votes.find({group: groupId, user: userId})
	else
		[]
@Votes.currentVotes = () ->
	Votes.find({active: true, voted: {$gte: cutoffTime()}})
	
@Votes.currentInGroup = (groupId) ->
	Votes.find({group: groupId, active: true, voted: {$gte: cutoffTime()}})

if(Meteor.isServer)
	Meteor.publish("myGroups", @Groups.recent)
	Meteor.publish("selectedRoom", (slug) ->
		Groups.find({slug: slug}))
	Meteor.publish("groupVotes", (slug) ->
		g = Groups.findOne({slug: slug})
		Votes.currentInGroup(g._id)
	)

	Meteor.publish("myVotes", (slug) ->
		if(slug)
			g = Groups.findOne({slug: slug})

			Votes.myVotesInGroup(g._id, @userId)
	)

	Meteor.methods({
		'addGroup': (name) ->
			slug = URLify2(name)
			g = Groups.findOne({slug: slug})

			if(!g)
				id = Groups.insert({
					name: name,
					slug: slug
				})
				g = Groups.findOne(id)

			g

		'vote': (group, restaurant) ->
			g = Groups.findOne({slug: group})
			existing = Votes.findOne({group: g._id, active: true, user: @userId, voted: {$gte: cutoffTime()}})

			if(existing)
				Votes.update(existing._id, {
					$set: { active: false }
				})

			Votes.insert({
				group: g._id,
				active: true,
				user: @userId || Meteor.userId(),
				name: Meteor.user().username,
				voted: new Date(),
				restaurant: restaurant})
	})


Meteor.startup(() ->
  if (Meteor.isServer)
    @Groups.remove({})

    t2 = @Groups.insert({name: 'test2', ownerId: '4JNjn9WKmkDrL8bjM', slug: 'test2'})

    t1 = @Groups.insert({name: 'test1', ownerId: 'xpHzsG6BdYaEuRnZN', slug: 'test1'})

    t3 = @Groups.insert({name: 'test3', ownerId: '4JNjn9WKmkDrL8bjM', slug: 'test3'})

    @Votes.remove({})

    @Votes.insert({group: t2, active: true, user: 'xpHzsG6BdYaEuRnZN', restaurant: "Benihana's", name: "mockData@meteor.com", voted: new Date()})

    @Votes.insert({group: t2, active: true, user: 'xpHzsG6BdYaEuRnZN', restaurant: "Boston Stoker", name: "Sheryl", voted: new Date(2013, 6, 3)})

    @Votes.insert({group: t2, active: true, user: '4JNjn9WKmkDrL8bjM', restaurant: "Chipotle", name: "brucehubbard@gmail.com", voted: new Date(2013, 6, 3)})

    @Votes.insert({group: t1, active: true, user: '4JNjn9WKmkDrL8bjM', restaurant: "Chipotle", name: "brucehubbard@gmail.com", voted: new Date(2013, 6, 3)})
)

###

Groups
	- All public for now, just need URL

Users
	- Users can create Group
	

Keep track of:
	- Groups a user has participated in
	- Votes a user has cast
	- Votes a group has cast


###