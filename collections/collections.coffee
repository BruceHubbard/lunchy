cutoffTime = () ->
	cutoff = new Date()
	cutoff.setHours(cutoff.getHours() - 5)
	cutoff

@Votes = new Meteor.Collection("Votes")
@Votes.myVotes = (userId) ->
	if(userId)
		Votes.find({user: userId})
	else
		[]
@Votes.myVotesInGroup = (groupSlug, userId) ->
	if(userId)
		Votes.find({group: groupSlug, user: userId})
	else
		[]
@Votes.currentVotes = (slug) ->
	Votes.find({active: true, group: slug, voted: {$gte: cutoffTime()}})
	
@Votes.currentInGroup = (groupId) ->
	Votes.find({group: groupId, active: true, voted: {$gte: cutoffTime()}})

if(Meteor.isServer)
	Meteor.publish("groupVotes", (slug) ->
		Votes.currentInGroup(slug)
	)

	Meteor.publish("myVotes", () ->
		if(Meteor.userId)
			Votes.myVotes(@userId)
	)

	Meteor.methods({
		'vote': (group, restaurant) ->
			existing = Votes.findOne({group: group, active: true, user: @userId, voted: {$gte: cutoffTime()}})

			if(existing)
				Votes.update(existing._id, {
					$set: { active: false }
				})

			Votes.insert({
				group: group,
				active: true,
				user: @userId || Meteor.userId(),
				name: Meteor.user().username,
				voted: new Date(),
				restaurant: restaurant})
	})

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