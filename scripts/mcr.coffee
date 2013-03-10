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
    
  set_tap: (tap_side, beer) ->
    @cache[tap_side] = beer
    @robot.brain.data.taps = @cache
    
  clear_tap: (tap_side) ->
    @cache[tap_side] = "Nothing"
    @robot.brain.data.taps = @cache
  
  get_tap: ->
    response = ""
    if @cache
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
    mcr.clear_tap(msg.match[1].trim())
    msg.send "Bummer."
  robot.respond /(what's|what is) on tap/i, (msg) ->
    if !@robot.brain.data.taps
      msg.send "I don't know, go check the kegs."
    else
      msg.send mcr.get_tap()
  