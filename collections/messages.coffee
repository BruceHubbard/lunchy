cutoffTime = () ->
	cutoff = new Date()
	cutoff.setHours(cutoff.getHours() - 5)
	cutoff

@Messages = new Meteor.Collection("Messages")

if(Meteor.isServer)
	Meteor.publish("recentMessages", (slug) ->
		Messages.find({group: slug, posted: {$gte: cutoffTime()}}))

	Meteor.methods({
		'addMessage': (groupSlug, message) ->
			Messages.insert({
				group: groupSlug,
				user: @userId,
				name: Meteor.user().username,
				posted: new Date(),
				message: message})
	})
