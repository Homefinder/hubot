# Dependencies:
#   None
#
# Configuration:
#   TANGO_PLATFORM_NAME
#   TANGO_PLATFORM_KEY
#
# Commands:
#   hubot what is our tango card balance?
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