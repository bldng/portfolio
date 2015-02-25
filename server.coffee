express    = require 'express'
favicon    = require 'serve-favicon'
wit        = require 'node-wit'
rp         = require 'request-promise'
vocabulary = require './data/vocabulary.json'
Client     = require 'node-wolfram'
sentiment  = require 'sentiment'
bodyParser = require 'body-parser'


sentiment_options = {'no':0, 'never': 0, 'hell': 0, 'fuck': -.5, 'sucks': 0, 'fucking': 0, 'sorry': 1, 'apologise': 1, 'apologised': 1, 'apologises': 1, 'apologising': 1, 'apologize': 1, 'apologized': 1, 'apologizes': 1, 'apologizing': 1, 'apology': 1}

# load you API keys here
secret  = require './data/secrets.json'
wit     = secret.wit
twilio  = secret.twilio
Wolfram = new Client(secret.wolfram)

client = require('twilio')(secret.twilio.sid, secret.twilio.token)

app = express()
app.use require('cors')()
# app.use express.compress()
app.use(favicon(__dirname + '/portfolio/public/favicon.ico'))
app.use(express.static(__dirname + '/portfolio/public'))
app.use( bodyParser.json() )
app.use(bodyParser.urlencoded({extended: true}))

app.get '/', (req, res) ->
	res.sendfile __dirname + '/portfolio/public'


app.get '/api', (req, res) ->

	# uri example with context
	# api?body=yes&context={"state":"show_projects"}	

	message = req.query.body
	ip = req.ip
	state = if req.query.state then '&context={"state":"'+req.query.state+'"}' else ''
	checkprofanity = sentiment message, sentiment_options
	profanity = checkprofanity.comparative

	options =
		uri : 'https://api.wit.ai/message?v=201410226&access_token='+wit+'&q='+message.toLowerCase()+state

	if profanity < -0

		response = {}
		# {"_text":"hi","intent":"greeting","entities":{},"confidence":0.81,"category":"default","reply":"what can I do for you?"}
		response.intent = 'sailor'
		response.confidence= 1
		response.category = 'default'
		response.reply = pickSentence 'sailor'

		console.log ip + ' said: ' + message + ' (' + profanity + ')    ==> ' + response.intent
		res.json response

	else
		rp(options)
			.then((response)->
				parsed = JSON.parse response
				result = parsed.outcomes[0]

				intent     = result.intent
				confidence = result.confidence
				category   = if result.entities.category then result.entities.category[0].value else 'default'

				console.log ip + ' said: ' + message + ' (' + profanity + ')    ==> ' + intent

				result.category = category

				if confidence > .4 && intent != 'wolfram'
					result.reply =  pickSentence(intent, category)
					res.json result

				else if confidence > .4 && intent = 'wolfram'
					Wolfram.query message, (err, wolframresult) ->
						if err?
							console.log err
						else
							if wolframresult.queryresult.pod != undefined
								result.reply = wolframresult.queryresult.pod[1].subpod[0].plaintext
							else
								# console.log wolframresult.queryresult.didyoumeans[1]
								result.reply = 'Nothing. Damn.'
							respond()


				else if intent = 'yes_sorry'
					pickSentence(intent)
					respond

				else if intent = 'no_sorry'
					pickSentence(intent)
					respond

				else if intent = 'compliment'
					pickSentence(intent)
					respond

				else
					result.reply =  pickSentence('not-sure', category)
					res.json result
			
				respond = ()->
					res.json result				
				)
			.catch(console.error)

app.post '/api2', (req, res) ->
	content = req.query.message

	client.sendMessage {
		to: '+41793914458'
		from: '+14804850583'
		body: content
	}, (err, responseData) ->
		if err
			console.log err
		else
			# console.log responseData.from
			console.log responseData.body
			res.send 'message sent.'
			# res.json responseData


pickSentence = (key, category) ->
	# console.log key
	if vocabulary[key] != undefined
		sentence_pool = vocabulary[key]
		random = Math.floor(Math.random() * vocabulary[key].length + 0)
		sentence = vocabulary[key][random]
		return sentence.replace "${category}", category
	else
		return "Sorry, I don't know what say"

server = app.listen process.env.PORT || 61987, ->
	host = server.address().address
	port = server.address().port
	console.log 'Example app listening at http://%s:%s', host, port