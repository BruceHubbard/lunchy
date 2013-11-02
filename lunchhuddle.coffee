Router.configure({
  layoutTemplate: 'layout'
})

Router.map(() ->
  @route('home', {
    path: '/',
    template: 'home'
    ###
    data: () ->
      kids = Children.find().fetch()
      transactions = Transactions.find({
        kidId: {$in: _.pluck(kids, '_id')}
      }).fetch()
      _.each(transactions, (t) ->
        t.which = _.find(kids, (k) -> k._id == t.kidId)
      )
      { 
        kids: kids, 
        transactions: transactions
      }
      ###
  })

  @route('add-kid', {
    path: '/g/:_name',
    template: 'group_detail',
    data: () ->
      console.log("param", @params._name)
      { group: Groups.findOne({name: @params._name}) }
  })

)