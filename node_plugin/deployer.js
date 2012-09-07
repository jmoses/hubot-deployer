hackers = [
  "http://hubot-assets.s3.amazonaws.com/hackers/1.gif",
  "http://hubot-assets.s3.amazonaws.com/hackers/2.gif",
  "http://hubot-assets.s3.amazonaws.com/hackers/3.gif",
  "http://hubot-assets.s3.amazonaws.com/hackers/4.gif",
  "http://hubot-assets.s3.amazonaws.com/hackers/5.gif",
  "http://hubot-assets.s3.amazonaws.com/hackers/6.gif",
  "http://hubot-assets.s3.amazonaws.com/hackers/7.gif",
]

module.exports = (robot) ->
  robot.respond /deploy (\w+) to (\w+)(?: with (\w+))?/i, (msg) ->
    msg.send 'Attempting deploy. Please hold.'
    msg.send msg.random hackers

    #hit the sinatra app to do the deploy
    msg.http("http://localhost:9292/deploy/#{msg.match[1]}/#{msg.match[2]}/#{msg.match[3]}")
    .get() (err, res, body) ->
      if res.statusCode != 200
        msg.send "Something went horribly wrong: #{body}"
      else
        msg.send 'Deployed like a boss'
        msg.send 'http://hubot-assets.s3.amazonaws.com/fuck-yeah/3.gif'
