# Description:
#   A way to interact with the MCR API.
#
# Commands:
#   hubot review report - Shows total MCR published reviews and happy moves
#   hubot find movers near <query> - Returns moving companies near the given location (zip code, city/state, address)

# GA = require('googleanalytics')
# util = require('util')
# require('date-utils');        

module.exports = (robot) ->
	robot.respond /review report/i, (msg) ->
    @robot.http('http://iron-serpent.herokuapp.com/api/v1/review_counts')
    .get() (err, res, body) ->
      rev_resp = JSON.parse(body)
      msg.send "Here's the reviews I counted...\r\n#{rev_resp.published_review_count} Published Reviews\r\n#{rev_resp.happy_moves_count} Happy Moves :)"

  robot.respond /find movers near (.*)/i, (msg) ->
    @robot.http("http://iron-serpent.herokuapp.com/api/v1/near_location?query=#{msg.match[1].replace(/[\s]/, "-")}")
    .get() (err, res, body) ->
      locs = JSON.parse(body)
      results_msg = "Here's what I found near #{msg.match[1]}...\r\n"
      if locs.length <= 0
        results_msg = "I didnt' find any movers near #{msg.match[1]}"
      else
        i = 0
        while i < locs.length
          results_msg += "#{locs[i].company.company_name}: #{locs[i].company.profile_url}\r\n"
          i++
        
      msg.send results_msg


  # Artsy Editorial
  #
  # Get Page stats from google analytics
  # robot.hear /stats (.*)http:\/\/movingcompanyreviews.com\/(.*)/i, (msg) ->
  #   url = msg.match[0]
  #   config = { "user": "dgehrett@homefinder.com", "password": "Charl1e0616" }
  # 
  #   ga = new GA.GA(config);
  # 
  #   ga.login (err, token) ->
  # 
  #     start_date = Date.yesterday().toYMD("-")
  #     end_date = Date.today().toYMD("-")
  # 
  #     # support custom ranges
  #     if url.indexOf("stats http") == -1
  #       range = url.split(" http://movingcompanyreviews.com/")[0].split("stats ")[-1..][0].trim()
  # 
  #       if range is "week"
  #         start_date = Date.today().add({ weeks: -1 }).toYMD("-")
  # 
  #       if range is "month"
  #         start_date = Date.today().add({ months: -1 }).toYMD("-")
  # 
  #       if range is "year"
  #         start_date = Date.today().add({ years: -1 }).toYMD("-")
  # 
  # 
  #     path = url.split("http://movingcompanyreviews.com")[-1..]
  # 
  #     options = {
  #         'ids': 'ga:67098210',
  #         'start-date': start_date,
  #         'end-date': end_date,
  #         'filters': "ga:pagePath==#{path}",
  #         'metrics': 'ga:visits, ga:pageviews',
  #     }
  # 
  #     # [{"metrics":[{"ga:visits":478,"ga:pageviews":688}],"dimensions":[{}]}]
  # 
  #     ga.get(options, (err, entries) ->
  # 
  #       visits = entries[0]["metrics"][0]["ga:visits"]
  #       pageviews = entries[0]["metrics"][0]["ga:pageviews"]
  # 
  #       msg.send "/#{path} recieved #{visits} visits and #{pageviews} pageviews."    
  #     )
