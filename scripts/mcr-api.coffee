# Description:
#   A way to interact with the MCR API.
#
# Commands:
#   hubot review report - Shows total MCR published reviews and happy moves

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
      i = 0
      while i < locs.length
        results_msg += "#{locs[i].company.company_name}: #{locs[i].company.profile_url}\r\n"
        i++
        
      msg.send results_msg
