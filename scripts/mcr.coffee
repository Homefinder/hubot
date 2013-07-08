# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot <beer> tapped on the (left|right) - sets the tap's brew
#   hubot empty (left|right) tap - empties the tap
#   hubot what is on tap - hubot shows what beers are on tap
#
# Author:
#   bhankus

class Mcr

  constructor: (@robot) ->
    @cache = {}
    if @robot.brain.data.taps
      @cache = @robot.brain.data.taps
    
  set_tap: (tap_side, beer) ->
    @cache[tap_side] = beer
    @robot.brain.data.taps = @cache
    
  get_tap: ->
    response = ""
    if !@cache || (!@cache['left'] && !@cache['right'])
      response = "I don't know, go check the kegs."
    else
      if @cache['left']
        response = "\r\n" + @cache['left'] + " is pouring from the LEFT tap."
      if @cache['right']
        response += "\r\n" + @cache['right'] + " is pouring from the RIGHT tap."
    response

tap_responses = ["Awesome, I LOVE BEER!!!", "I'm so thirsty.", "Let's go grab a beer right now!", 
                "I can't wait until 4pm.", "Cheers! Salut! Prost! Sláinte! Salud! Na zdrowie!"]

module.exports = (robot) ->
  mcr = new Mcr robot
  robot.respond /@?([\w .\-_]+) tapped on the (left|right)/i, (msg) ->
    mcr.set_tap(msg.match[2].trim(), msg.match[1].trim())
    msg.send msg.random tap_responses
  robot.respond /empty (left|right) tap/i, (msg) ->
    mcr.set_tap(msg.match[1].trim(), "Nothing")
    msg.send "Bummer."
  robot.respond /(what's|what is) the mcr project status/i, (msg) ->
    msg.send "https://circleci.com/gh/Homefinder/movingcompanyreviews.png?circle-token=e2e29dd76bdc457515900f908fedf63c646fe834"
  robot.respond /(what's|what is) on tap/i, (msg) ->
    msg.send mcr.get_tap()
  robot.hear /facepalm/i, (msg) ->
    msg.send "http://th06.deviantart.net/fs24/200H/i/2008/022/f/1/facepalm_gif_by_thatweirdo7.jpg"
  robot.hear /hammer/i, (msg) ->
    msg.send "http://divshot.github.io/geo-bootstrap/img/test/mchammer.gif"
  robot.hear /alert/i, (msg) ->
    msg.send "http://divshot.github.io/geo-bootstrap/img/test/drudgesiren.gif"
