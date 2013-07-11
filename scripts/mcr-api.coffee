
module.exports = (robot) ->
	robot.respond /review report/i, (msg) ->
    @robot.http('http://iron-serpent.herokuapp.com/api/v1/review_counts')
    .get() (err, res, body) ->
      rev_resp = JSON.parse(body)
      msg.send "Here's the reviews I counted...\r\n#{rev_resp.published_review_count} Published Reviews\r\n#{rev_resp.happy_moves_count} Happy Moves :)"
