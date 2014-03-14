# Description:
#   funnel report.  we want to know
#     - how many moves we created, and how many visits it tool
#     - how many of those moves we got opted in to text on their move day
#     - how many moves left a voice review
# Commands:
#   hubot funnel - Shows a simple MCR visits to moves funnel
#   

GA = require('googleanalytics')
util = require('util')
#require('date-utils');        

module.exports = (robot) ->
  robot.respond /funnel/i, (msg) ->
    msg.send "Getting funnel stats from MCR databse..."
    url = 'https://dataclips.heroku.com/ftkconyzevsaywmihjrpilwjojwm.json'
    @robot.http(url)
    .get() (err, res, body) ->
      if res.statusCode == 302
#        msg.send "url changed, following new one"
#        msg.send res.headers.location
        url = res.headers.location
        msg.http(url).get() (err, res, body) ->
          rev_resp = JSON.parse(body)
          msg.send "Funnel Report\n"+
          "-------------\n"+
          "Yesterday:        Moves: #{rev_resp.values[1][1]}\n"+
          "Today:            Moves: #{rev_resp.values[0][1]}"

#        config = { "user": "dgehrett@homefinder.com", "password": "Charl1e0616" }
#        ga = new GA.GA(config);
#        ga.login (err, token) ->
#          yesterday = Date.yesterday().toYMD("-")
#          today = Date.today().toYMD("-")
#          options = {
#              'ids': 'ga:67098210',
#              'start-date': yesterday,
#              'end-date': yesterday,
#              'metrics': 'ga:visits',
#          }
          # [{"metrics":[{"ga:visits":478,"ga:pageviews":688}],"dimensions":[{}]}]
#          ga.get(options, (err, entries) ->
#            visits = entries[0]["metrics"][0]["ga:visits"]
#            msg.send "We got #{visits} visits on #{yesterday} \n"    
#          )
