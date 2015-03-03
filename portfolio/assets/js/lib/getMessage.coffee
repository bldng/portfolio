say     = require './generateMessage'
content = require '../../../public/js/content.json'
projects = content.projects.items

# Yeah, I know. But it's only wrong for like 2 weeks!
calcAge = (born) ->
	d = new Date();
	n = d.getFullYear();
	a = n-1 - parseInt(born)
	return a.toString()

contact = '<form method="" id="contactForm">or you can send him a quick message:<textarea autofocus placeholder="" class="send--textarea"></textarea><button type="submit">send</button><input type="hidden" name="submitValue" value="false"/></form>'
feedback = '<form method="" id="feedbackForm"><textarea autofocus placeholder="" class="feedback--textarea"></textarea><button type="submit">send</button><input type="hidden" name="submitValue" value="false"/></form>'

about_me = [
	{answer: '185cm', tags: ['height', 'tall']},
	{answer: 'Zurich, Switzerland', tags: ['location', 'city']},
	{answer: 'Giessen, Germany', tags: ['from']},
	{answer: 'Road Cycling & Cyclocross <br/> Programming <br/> Thinking about the future of design', tags: ['hobbies']},
	{answer: '<img src="img/misc/portrait.png"/>', tags: ['look']},
	{answer: calcAge(1985), tags: ['age', 'old']},
	{answer: '18.12.1985', tags: ['birthyear']},
	{answer: '<a href="https://github.com/bldng/portfolio" target="_blank">View on github</a>', tags: ['tech']},
	{answer: 'Gerhard Bliedung. Born in Germany, then moved to Switzerland to study Interaction Design. Likes speculative design, road bikes and technology.', tags:['general']},
	{answer: '<ul><li>Interaction and UX Design</li><li>Frontend Development</li><li>Installations / Exhibitions</li></ul>', tags:['offer']},
	{answer: '<ul><li><del>LinkedIn</del></li><li><del>Facebook</del></li><li><del>twitter</del></li><li><a href="https://github.com/bldng" target="_blank">Github</a></li><li><a href="https://github.com/bldng" target="_blank">codepen</a></li></ul>', tags: ['socialmedia']},
	{answer: '<a href="img/misc/cv_web_2015.pdf" target="_blank"><img src="http://cl.ly/image/020I2T0A090J/oeOPL7tU7cJ2DXgOCuJYOibufj1yNQFfZojs5eGaPzc.png"/><br>Download</a>', tags: ['cv']},
	{answer: '<div class="longtext"><h3>Work Experience</h3><p><strong>SVS/BirdLife nature conservation centre Neeracherried</strong><br>2014<br>Planning and implementing the redesign for the interactive permanent exhibition.</p><p><strong>Product Management Intern Leica Camera AG</strong><br>Summer 2013<br>Involved with various existing and self initiated projects in the field of innovation and workflows.</p><p><strong>Spocal GmbH</strong><br>January 2012 – September 2013<br>Lead Designer at a Zurich startup. Responsible for UX / UI and branding of the student platform Spocal as well as the corporate-oriented product Beekeeper.</p><p><strong>Freelance web and graphic design</strong><br>Since 2006<br>mainly in the area of individuals and medium-sized companies.</p></div>', tags: ['references', 'work experience']},
	{answer: 'Kim & Key <3 <br> <img src="img/misc/cats.png"/>', tags: ['cats']},
	{answer: 'You can find it here: <a href="/blog" target="_blank">Blog</a>', tags: ['blog']},
	{answer: 'Via Email: <a href="mailto:hello@gerhardbliedung.com">hello@gerhardbliedung.com</a>'+contact, tags: ['contact']},
	{answer: '<div class="longtext"><p><strong>Languages</strong></p><p>Human – Human</p><ul><li>German ( mother Tongue )</li><li>English ( fluent in speech and writing )</li></ul><p>Human – Machine</p><ul><li>Javascript ( Node.js, jQuery, three.js, Angular, babel )</li><li>browserify / webpack</li><li>build tools</li><li>templating</li><li>css preprocessors</li><li>Java, C++ ( Processing, Arduino)</li></ul><p><strong>Skills</strong></p><p>Software</p><ul><li>Adobe CC Suite ( Ps, Ai, In, Ae )</li><li>Sketch</li><li>Git</li><li>Cinema 4d &amp; blender</li></ul><p>Additional Skills</p><ul><li>Digital and analog illustrations</li><li>Physical Prototyping</li><li>Robotics ( Dynamixel / Arduino )</li><li>Calligraphy</li></ul></div>', tags: ['skills']},
	{answer: 'Zurich University of the Arts,<br> graduated in 2014', tags: ['university']},
	{answer: '<b>Bachelor of Arts in Product and Industrial Design with a Specialization in Interaction Design</b><br>Zurich University of the Arts<br><small>', tags: ['degree']}
]

module.exports = (message) ->

	cleanedMessage = message.replace '#', ''

	url = '/api?body='+cleanedMessage+'&state='+context

	api_reply = $.getJSON url, (data) ->
		if data.intent == 'projects'
			category = data.category.toLowerCase()
			filteredProjects = []

			if category == 'all'
				for item in projects
					filteredProjects.push({title: item.title, tag: item.tags[0]})
				$( ".conversation" ).append say( 'These are all projects I could find:', 'bot')
				$( ".conversation" ).append say( filteredProjects , 'bot--delay', 'linklist' )

			else if category == 'random'
				random = Math.floor(Math.random() * projects.length + 0)
				filteredProjects.push({title: projects[random].title, tag: projects[random].tags[0]})
				$( ".conversation" ).append say( 'Here is a random project:', 'bot')
				$( ".conversation" ).append say( filteredProjects , 'bot--delay', 'linklist' )

			else
				filteredProjects = projects.filter( (item) ->
					if item.tags.indexOf( category ) > -1
						filteredProjects.push item.title
					)
				console.log filteredProjects
				if filteredProjects.length > 0
					$( ".conversation" ).append say( data.reply, 'bot' )
					$( ".conversation" ).append say( filteredProjects, 'bot--delay', 'linklist' )
				else
					$( ".conversation" ).append say( 'Sorry, there was no match for '+ category, 'bot' )

		else if data.intent == 'about_me'
			filteredInfo = []
			filteredInfo = about_me.filter( (item) ->
				if item.tags.indexOf( data.category.toLowerCase() ) > -1
					return item.answer
				)
			if filteredInfo.length < 1
				$( ".conversation" ).append say( "Sorry, I don't know. If you want to ask him, just type &laquo; contact &raquo; ", 'bot' )
			else
				$( ".conversation" ).append say( data.reply, 'bot' )
				$( ".conversation" ).append say( filteredInfo, 'bot--delay', 'numerical' )

		else if data.intent == 'yes_send'
			global.context = ''
			$('input[name="submitValue"]').val(true)
			$('#contactForm').submit()

		else if data.intent == 'sailor'
			global.context = 'sailor' if global.context.length == 0
			$( ".conversation" ).append say( data.reply, 'bot--delay' )

		else if data.intent == 'yes_sorry'
			global.context = ''
			$('body').removeClass('howdoyulikethat')
			$('.rickroll').remove()
			$( ".conversation" ).append say( data.reply, 'bot')

		else if data.intent == 'no_sorry'
			$('body').addClass('howdoyulikethat')
			# pointer-events: none on a video too mean?
			$('.conversation').append '<div class="bot numerical rickroll"><iframe style="pointer-events:auto" width="100%" height="420" src="http://www.youtube.com/embed/dQw4w9WgXcQ?autoplay=1" frameborder="0"></iframe></div>'
			$( ".conversation" ).append say( data.reply, 'bot')
			chanceToApologize = () ->
				global.context = ''
				console.log 'too late'
			setTimeout(chanceToApologize, 25000)

		else if data.intent == 'no_send'
			global.context = ''
			$('.send--textarea').focus()

		else if data.intent == 'yes_feedback'
			global.context = ''
			$( ".conversation" ).append "<div class='bot feedbackform'>Would you mind sending a short Feedback? This would be awesome!</div><div class='bot numerical feedbackform'>"+feedback+"</div>"

		else if data.intent == 'no_feedback'
			global.context = ''
			$( ".conversation" ).append say( 'No problem! Maybe some other time.', 'bot' )

		else if data.intent == 'bye'
			global.context = ''
			$( ".conversation" ).append say( data.reply, 'bot')
			stillThere = () ->
				global.context = ''
				$( ".conversation" ).append say( 'Uh, you are still here ...', 'bot' )
			setTimeout(stillThere, 8000)

		else if data.intent == 'unhappy'
			allProjects = []
			for item in projects
				allProjects.push({title: item.title, tag: item.tags[0]})
			$( ".conversation" ).append say( data.reply, 'bot')
			$( ".conversation" ).append say( allProjects , 'bot--delay', 'all-projects' )
			$( ".conversation--input").blur()

		else if data.intent == 'wolfram'
			$( ".conversation" ).append say( 'Wolfram alpha says:', 'bot' )
			$( ".conversation" ).append say( data.reply, 'bot--delay', 'wolfram' )

		else
			$( ".conversation" ).append say( data.reply, 'bot')

		localStorage.setItem('projects', projects.length )
