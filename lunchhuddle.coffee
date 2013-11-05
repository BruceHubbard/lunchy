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
    template: 'group_detail',
    data: () ->
      console.log("param", @params._slug)
      { group: Groups.findOne({slug: @params._slug}) }
  })

)
