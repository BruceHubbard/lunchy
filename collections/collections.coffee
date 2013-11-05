@Groups = new Meteor.Collection("Groups")
@Votes = new Meteor.Collection("Votes")

@Groups.recent = () ->
	if(Meteor.userId)
		Groups.find({ownerId: @userId || Meteor.userId()})

if(Meteor.isServer)
	Meteor.publish("myRooms", @Groups.recent)
	Meteor.publish("selectedRoom", (slug) ->
		Groups.find({slug: slug}))

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
	})


Meteor.startup(() ->
  if (Meteor.isServer)
    @Groups.remove({})

    @Groups.insert({name: 'test2', ownerId: '4JNjn9WKmkDrL8bjM', slug: 'test2'})
    @Groups.insert({name: 'test1', ownerId: null, slug: 'test1'})
    @Groups.insert({name: 'test3', ownerId: '4JNjn9WKmkDrL8bjM', slug: 'test3'})
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