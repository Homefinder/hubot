# Dependencies:
#   None
#
# Configuration:
#   TANGO_PLATFORM_NAME
#   TANGO_PLATFORM_KEY
#   TANGO_TEST_PLATFORM_NAME
#   TANGO_TEST_PLATFORM_KEY
#
# Commands:
#   hubot what is our tango card balance?
#   hubot what is our test tango card balance?
#   hubot show tango the money
#
# Author:
#   bhankus

module.exports = (robot) ->
  robot.respond /(what's|what is) (the|our) tango card balance/i, (msg) ->
    user = process.env.TANGO_PLATFORM_NAME
    pass = process.env.TANGO_PLATFORM_KEY
    auth = 'Basic ' + new Buffer(user + ':' + pass).toString('base64');
    msg.http("https://api.tangocard.com/raas/v1/accounts/Reviewers/ReviewIncentives")
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            msg.send "Our balance is $#{JSON.parse(body).account.available_balance/100}"
          else
            msg.send "OH NO somthing broke!"

  robot.respond /show tango the money/i, (msg) ->
    user = process.env.TANGO_TEST_PLATFORM_NAME
    pass = process.env.TANGO_TEST_PLATFORM_KEY
    auth = 'Basic ' + new Buffer(user + ':' + pass).toString('base64');
    data = {customer: "Reviewers", account_identifier: "ReviewIncentives", amount: 10000, client_ip: "38.88.48.146", credit_card: {number: "4111111111111111", security_code: "123", expiration: "03/15", billing_address: {f_name: "Move", l_name: "Master", address: "20 N Wacker Dr", city: "Chicago", state: "IL", zip: "60602", country: "USA", email: "bhankus+funds@homefinder.com"}}}
    msg.http("https://sandbox.tangocard.com/raas/v1/funds")
      .headers(Authorization: auth, Accept: 'application/json')
      .post(JSON.stringify data) (err, res, body) ->
        switch res.statusCode
          when 200
            msg.send "I flashed a Benjamin"
          else
            msg.send "OH NO somthing broke!"

  robot.respond /(what's|what is) (the|our) (sandbox|test) tango card balance/i, (msg) ->
    user = process.env.TANGO_TEST_PLATFORM_NAME
    pass = process.env.TANGO_TEST_PLATFORM_KEY
    auth = 'Basic ' + new Buffer(user + ':' + pass).toString('base64');
    msg.http("https://sandbox.tangocard.com/raas/v1/accounts/Reviewers/ReviewIncentives")
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            msg.send "Our sandbox balance is $#{JSON.parse(body).account.available_balance/100}"
          else
            msg.send "OH NO somthing broke!"