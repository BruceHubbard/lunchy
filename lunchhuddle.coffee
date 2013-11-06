Router.configure({
  layoutTemplate: 'layout'
})

Router.map(() ->
  @route('home', {
    path: '/',
    template: 'home',
    before: () ->
      this.subscribe('myRooms').wait()
    data: () ->
      {recent: Groups.recent().fetch()}
  })

  @route('detail', {
    path: '/g/:_slug',
    load: () -> 
      Session.set("slug", @params._slug)
    before: () ->
      this.subscribe('selectedRoom', Session.get('slug'))
      this.subscribe('votes', Session.get('slug'))
      this.subscribe('myVotes')
    template: 'group_detail',
    data: () ->
      { 
        group: Groups.findOne({slug: @params._slug}),
        myVotes: Votes.myVotes()
        #votes: Votes.find().fetch()
      }
  })

)
