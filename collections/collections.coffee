@Groups = new Meteor.Collection("Groups")
@Votes = new Meteor.Collection("Votes")

@Groups.recent = () ->
	if(Meteor.userId)
		Groups.find({ownerId: @userId || Meteor.userId()})

if(Meteor.isServer)
	Meteor.publish("myRooms", @Groups.recent)
	Meteor.publish("selectedRoom", (slug) ->
		Groups.find({slug: slug}))
	Meteor.publish("votes", (slug) ->
		g = Groups.findOne({slug: slug})
		now = new Date()
		cutoff = new Date()
		cutoff.setHours(cutoff.getHours() - 6)

		Votes.find({group: g._id, voted: {$gte: cutoff}})
	)

	Meteor.methods({
		'addGroup': (name) ->
			slug = URLify2(name)
			g = Groups.findOne({slug: slug})

			if(!g)
				id = Groups.insert({
					name: name,
					ownerId: @userId || Meteor.userId()
					slug: slug
				})
				g = Groups.findOne(id)

			g

		'vote': (group, restaurant) ->
			g = Groups.findOne({slug: group})

			Votes.insert({
				group: g._id,
				user: @userId || Meteor.userId(),
				name: Meteor.user().emails[0].address,
				voted: new Date(),
				restaurant: restaurant})
	})


Meteor.startup(() ->
  if (Meteor.isServer)
    @Groups.remove({})

    t2 = @Groups.insert({name: 'test2', ownerId: '4JNjn9WKmkDrL8bjM', slug: 'test2'})
    t1 = @Groups.insert({name: 'test1', ownerId: null, slug: 'test1'})
    t3 = @Groups.insert({name: 'test3', ownerId: '4JNjn9WKmkDrL8bjM', slug: 'test3'})

    @Votes.insert({group: t2, user: null, restaurant: "Benihana's", name: "Sheryl", voted: new Date()})
    @Votes.insert({group: t2, user: null, restaurant: "Boston Stoker", name: "Sheryl", voted: new Date(2013, 6, 3)})
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