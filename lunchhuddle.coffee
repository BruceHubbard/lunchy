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
    path: '/kids/new',
    template: 'add_kid'
  })

  @route('transactions', {
    path: '/kids/:_id',
    template: 'details',
    data: () ->
      console.log("param", @params._id)
      console.log("kid", Children.findOne(@params._id))
      #{ kid: Children.findOne(@params._id) }
  })

)