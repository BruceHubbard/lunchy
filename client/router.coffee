Meteor.subscribe('myGroups')
Meteor.subscribe('myVotes')

Accounts.ui.config({
  passwordSignupFields: 'USERNAME_AND_EMAIL'
})

Router.configure({
  layoutTemplate: 'layout'
})

Router.map(() ->
  @route('home', {
    path: '/',
    template: 'home',
    data: () ->
      {
        recent: () ->
          votes = Votes.find({user: Meteor.userId()}).fetch()
          _.uniq(_.pluck(votes, 'group'))
      }
  })

  @route('detail', {
    path: '/g/:_slug',
    load: () -> 
      Session.set("slug", @params._slug)
    before: () ->
      this.subscribe('groupVotes', Session.get('slug'))
      this.subscribe('recentMessages', Session.get('slug'))
      this.subscribe('peopleInGroup', Session.get('slug'))

    template: 'group_detail',
    data: () ->
      { 
        myVotes: () ->
          votes = Votes.find({
            user: Meteor.userId(),
            group: Session.get('slug')
          }).fetch()
          if votes
            _.uniq(_.pluck(votes, 'restaurant'))
          else 
            []
        messages: Messages.find({}, {sort: {posted: -1}}).fetch(),
        people: Meteor.users.find().fetch()
      }
  })

)
