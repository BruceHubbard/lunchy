Meteor.subscribe('myGroups')

Router.configure({
  layoutTemplate: 'layout'
})

Router.map(() ->
  @route('home', {
    path: '/',
    template: 'home',
    data: () ->
      {recent: Groups.find().fetch()}
  })

  @route('detail', {
    path: '/g/:_slug',
    load: () -> 
      Session.set("slug", @params._slug)
    before: () ->
      this.subscribe('selectedRoom', Session.get('slug'))
      this.subscribe('groupVotes', Session.get('slug'))
      this.subscribe('myVotes', Session.get('slug'))

    template: 'group_detail',
    data: () ->
      { 
        group: Groups.findOne({slug: @params._slug}),
        myVotes: () ->
          votes = Votes.myVotes(Meteor.userId()).fetch()
          if votes
            _.uniq(_.pluck(votes, 'restaurant'))
          else 
            []
      }
  })

)