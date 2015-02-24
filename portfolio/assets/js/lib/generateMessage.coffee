module.exports = (message, sender, type) ->
	if type == 'linklist'
		console.log 'received: '+message.length
		messageString = ''
		for item in message
			messageString += '<li><a href=#'+item.title+'>' +item.title+'</a></li>'
		messageToDisplay = '<div class="'+sender+" "+type+'">'+messageString+'</div>'

	else if type == 'numerical'
		messageToDisplay = '<div class="'+sender+" "+type+'">'+message[0].answer+'</div>'

	else if type == 'all-projects'
		messageString = '<h3>Gerhard Bliedung<br>Experience Designer, Zurich</h3><h4>All projects:</h4><div class="all-projects--close">✕</div>'
		for item in message
			messageString += '<li><a href=#'+item.title+'>' +item.title+'</a> '+item.tag+'</li>'
		messageString += '<h4>Contact:</h4><li>Email: <a href="mailto:hello@gerhardbliedung.com">hello@gerhardbliedung.com</a></li>'
		messageToDisplay = '<div class="'+sender+" "+type+'">'+messageString+'</div>'

	else if type == 'wolfram'
		formatted = message.toString().replace(/[|]/g,':').replace(/\(.+?\)/g,'')
		messageToDisplay = '<div class="numerical '+sender+'">'+formatted+'</div>'

	else
		messageToDisplay = '<div class='+sender+'>'+message+'</div>'

	return messageToDisplay