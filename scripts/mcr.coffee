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
#   hubot MCR urls - list the URLs for different MCR environments
#
# Author:
#   bhankus

class Mcr

  constructor: (@robot) ->
    @cache = {}
    @robot.brain.on 'loaded', =>
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
  robot.respond /(.*)? state license for (\D{2})/i, (msg) ->
    if licenses[msg.match[2]]? && licenses[msg.match[2]] != ''
      msg.send "All of the answers you seek are here...\r\n#{licenses[msg.match[2]]}"
    else
      msg.send "I don't know anything about that one, try the yellow pages."
      
  robot.hear "pizzaflip", (msg) ->
    "http://gifrific.com/wp-content/uploads/2012/10/Walter-White-Throws-Pizza-on-Roof-Breaking-Bad.gif"
    
  robot.respond /MCR urls/i, (msg) ->
    msg.send "Production: http://www.movingcompanyreviews.com \n"+
      "Staging: http://movingcompanyreviews-stage.herokuapp.com \n" +
      "RFQ: http://mcr-rfq.herokuapp.com"

  robot.hear /nothing to see here/i, (msg) ->
    msg.send "http://i.minus.com/imswkJCIVORfd.gif"
  
  robot.hear "i can't", (msg) ->
    msg.send "http://www.reactiongifs.com/wp-content/uploads/2013/03/cant.gif"

  robot.respond /done|finished/i  , (msg) ->
    msg.send msg.random done_images

  robot.hear /i'm out|mic drop/i  , (msg) ->
    msg.send msg.random done_images

  robot.respond /taco/i  , (msg) ->
    msg.send msg.random taco_images
    
  robot.respond /what would tom smykowski think?/i, (msg) ->
    msg.send "http://i.qkme.me/3sgisk.jpg"

done_images = [
  "http://25.media.tumblr.com/tumblr_me3vm1DRDm1qhszhwo1_500.gif",
  "http://25.media.tumblr.com/tumblr_m3rtyerfHZ1qir45xo1_500.gif",
  "http://awesomelyluvvie.com/wp-content/uploads/2013/01/DropsMic2.gif",
  "http://media.giphy.com/media/ZOLcVvXARqWk0/original.gif",
  "http://media3.giphy.com/media/m4dwPQkkDvnji/original.gif",
  "http://25.media.tumblr.com/53f2cbe5c4af195219ca471f370602fc/tumblr_mnwu4kjNqq1qjvx17o2_250.gif"
  ]
  
taco_images = [
  "http://awesomegifs.com/wp-content/uploads/psycho-potter-taco-fling.gif",
  "http://gifrific.com/wp-content/uploads/2013/01/Shaq-Eating-Tacos-Taco-Bell-Commercial.gif",
  "http://img4.joyreactor.com/pics/comment/comics-nedroid-taco-389544.gif"
  ]

licenses = {
  "AK": "",
  "AL": "",
  "AR": "Need to request a list (I have a copy)",
  "AZ": "",
  "CA": "https://delaps1.cpuc.ca.gov/pls/public_cpuc/f?p=203:35:904049993834501::NO:RP::",
  "CO": "http://www.dora.state.co.us/pls/real/PUC_Permit.Search_Form",
  "CT": "No online, have to call for their household goods search. Can search business, http://www.concord-sots.ct.gov/CONCORD/online?sn=InquiryServlet&eid=99",
  "DC": "Federal",
  "DE": "https://dorweb.revenue.delaware.gov/bussrch/",
  "FL": "https://csapp.800helpfla.com/cspublicapp/businesssearch/BusinessSearch.aspx",
  "GA": "http://www.gamccd.net/HGLicensedMovers.aspx",
  "HI": "Loads extremely slow - http://dms.puc.hawaii.gov/dms/ActiveMotorCarriersReport.jsp",
  "IA": "",
  "ID": "Business Lookup - http://www.accessidaho.org/public/sos/corp/search.html?ScriptForm.startstep=crit",
  "IL": "http://www.icc.illinois.gov/utility/hgsearch.aspx",
  "IN": "Business Entity Search - https://secure.in.gov/sos/online_corps/name_search.aspx",
  "KS": "http://www.kcc.state.ks.us/trans/mcsearch.cgi",
  "KY": "http://transportation.ky.gov/Motor-Carriers/Documents/HouseholdGoodsCarriers.pdf https://apps.transportation.ky.gov/MCI/Home.aspx",
  "LA": "http://lpscstar.louisiana.gov/star/portal/lpsc/page/TranDocs/portal.aspx",
  "MA": "http://www.env.state.ma.us/DPU_FileRoom/frmTransportationSP.aspx",
  "MD": "http://www.mdmovers.org/rmp-currently-qualified-members.php",
  "ME": "",
  "MI": "http://www.dleg.state.mi.us/mpsc/motor/act_rules/hhg_stat.pdf",
  "MN": "",
  "MS": "",
  "MO": "http://www.modot.org/mcs/HHG/documents/HHGMovers4.4.13.pdf",
  "MT": "http://psc.mt.gov/transportation/pdf/MotorCarrierAuthorityList.pdf",
  "NC": "http://www.ncuc.net/consumer/carriers.pdf",
  "ND": "http://www.dot.nd.gov/dotnet2/submitinfo/submitinfo.aspx?pageID=contact-mv",
  "NE": "http://www.psc.nebraska.gov/tran/tran_household_cert.html",
  "NH": "",
  "NJ": "https://newjersey.mylicense.com/verification/Search.aspx?facility=Y",
  "NM": "http://www.nmprc.state.nm.us/transportation/docs/2093_001_NOA_PO.pdf",
  "NY": "Select your mover with care. Make sure the carrier is licensed by the Commissioner of Transportation. For verification call (800) 786-5368, or e-mail us at nymoving@dot.state.ny.us. When checking on a mover please provide their exact name, and if available, NYDOT number.",
  "NV": "http://tsa.nv.gov/ActiveCertificatesTable.asp?nNo=5",
  "OH": "http://www.puco.ohio.gov/apps/hhglist/index.cfm",
  "OK": "ftp://ftp.occeweb.com/TR_DATA/MCApplicantList/Household_Goods_MC.pdf  http://www.occeweb.com/tr/TRLists.htm",
  "OR": "http://www.oregon.gov/ODOT/MCT/Pages/MOVERS.aspx#Authorized_Movers",
  "PE": "http://www.puc.state.pa.us/transport/motor/pdf/HHG_Operators.pdf",
  "RI": "http://www.ripuc.org/utilityinfo/motorcarriers/Moving%20Companies%20Feb.%202013.pdf",
  "SC": "http://dms.psc.sc.gov/dockets/",
  "SD": "",
  "TN": "",
  "TX": "http://apps.dot.state.tx.us/apps/mccs/mccs_frame_search_collector.htm",
  "UT": "",
  "VA": "https://www.dmv.virginia.gov/apps/mcs/default.aspx",
  "VT": "",
  "WA": "http://www.utc.wa.gov/regulatedIndustries/transportation/householdGoods/Pages/PermittedCarriersHouseholdGoods.aspx",
  "WI": "",
  "WV": "",
  "WY": ""
}
