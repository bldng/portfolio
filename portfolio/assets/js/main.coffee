get       = require './lib/getMessage'
page      = require 'page'
content   = require '../../public/js/content.json'
global.$  = require 'jquery'
textFit   = require './vendor/textFit.min.js'
itemslide = require './vendor/itemslide.min.js'
fastclick = require 'fastclick'

global.context = ''
askAfter = 20
projectVisible = false

isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)

page '/', (ctx)->
	ctx.handled = true
	hash = ctx.hash.toString()
	props = content.projects.items.filter( (item) ->
		return item.title == hash
	)
	if props.length > 0
		projectVisible = true
		$('.content').html templates['project']({'props': props[0]})
		# $('.content').fadeIn()
		# $('.content').removeClass 'hidden'
		$('.main').addClass 'hidden'
		$('.slider').slick({dots: true, speed: 500, dotsClass: 'slider--dots', arrows: false, respondTo: 'slider'})
		fitHeader = () ->
			textFit $('.content--title') , {minFontSize:10, maxFontSize: 800, alignHoriz: true, reProcess: true}
		setTimeout(fitHeader, 100)
		$(document).scrollTop(0)


	else
		projectVisible = false
		# $('.content').fadeOut()
		# $('.content').addClass 'hidden'
		$('.content').html('')
		$('.main').removeClass 'hidden video'
		if hash.length > 0
			tellError = () ->
				$( ".conversation" ).append "<div class='bot'>Well, this is awkward. I can't find the page you wanted :(</div>"
			setTimeout(tellError, 4000)
		focus = () ->
			$('.conversation--input').focus() if !isMobile
		setTimeout(focus, 2500)
		# console.log('/');
page()


$(document).ajaxStart(->
	# console.log 'started'
	$('.spinner').removeClass('hidden')
).ajaxStop ->
	# console.log 'fin'
	$('.spinner').addClass('hidden')


$( "#talk" ).on 'submit', ( event ) ->
	event.preventDefault()
	console.log 'context: '+context+ '.'
	clientMessage =  $( ".conversation--input" ).val()
	if clientMessage.replace(/\s/g,"") != ""
		$( ".conversation" ).append( '<div class=human>'+clientMessage+'</div>' )
		get clientMessage
		$( ".conversation--input" ).val('')
		$( ".conversation--input" ).blur() if isMobile

	else
		$( ".conversation--input" ).val('')


	if $('.conversation').children().length == askAfter
		if global.context.length == 0 && $('#contactForm').length == 0
			global.context = 'ask_feedback'
			askFeedback = () ->
				$( ".conversation" ).append '<div class="bot--delay">Could you do me a small favor?</div>'
			setTimeout(askFeedback, 2000)




$( '.conversation' ).on 'submit', '#contactForm',  (event) ->
	event.preventDefault()
	messageToSend =  $( ".send--textarea" ).val()
	# super lame regex, as contact information is not neccessary
	mail = new RegExp(/([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9._-]+)/ig)
	phone = new RegExp(/\d{3}/)
	if messageToSend.replace(/\s/g,"") != ""
		if mail.test(messageToSend) || phone.test(messageToSend) || $('input[name="submitValue"]').val() == 'true'
			console.log 'send'
			# $( '.conversation .numerical:last').prev('.bot').andSelf().hide('fast').remove()
			$('#contactForm').remove()
			$('.temporary').remove() if $('.temporary')
			$( ".conversation" ).append '<div class="bot">Fwoosh!</div>'
			$.post( "/message", { message: messageToSend }, (data)->
				console.log data
				)
			global.context = ''
		else
			global.context = 'send_message'
			$( ".conversation" ).append '<div class="bot temporary">It seems you left no contact information. Send anyway?</div>'
			$(".conversation--input").focus()
	else
		$( ".send--textarea" ).val('')

$( '.conversation' ).on 'submit', '#feedbackForm',  (event) ->
	event.preventDefault()
	messageToSend =  $( ".feedback--textarea" ).val()
	if messageToSend.replace(/\s/g,"") != ""
		console.log 'sent feedback:' + messageToSend
		$('.feedbackform').remove()
		global.context = ''
		$.post( "/message", { message: messageToSend }, (data)->
			console.log data
			)
		$( ".conversation" ).append '<div class="bot">I will forward it immediately! Thank you :)</div>'
	else
		$( ".feedback--textarea" ).val('')


$('.main').on 'click', () ->
	if $(this).hasClass('hidden')
		$(this).removeClass 'hidden'
		document.location.href = '#'
		$('.conversation--input').focus()

$('.conversation').on 'click', '.all-projects--close',  () ->
	$(this).remove()
	$('.all-projects h3, .all-projects h4').remove()
	$('.all-projects').removeClass('all-projects').addClass('linklist')
	$('.conversation--input').focus()

$('.conversation--input').on 'focus', () ->
	scrollToBottom()

$('.main').on 'click', '.conversation--input', () ->
	if $('.all-projects')
		$('.all-projects').removeClass('all-projects').addClass('linklist')
		$('.conversation--input').focus()


# Start conversation
fastclick(document.body)
greet = () ->
	if (/msie|trident/i).test(navigator.userAgent)
    	$('.conversation').append '<div class="bot">Internet Explorer. Why wou...</div>'
    	$('.conversation').append '<div class="bot--delay">Nevermind, Hi!</div>'
    else
    	if localStorage.getItem('projects') != null
    		$('.conversation').append '<div class="bot">Hi! Welcome back :)</div>'
    	else
    		$('.conversation').append '<div class="bot">Hey!</div>'

    # $('.conversation--input').focus() if !isMobile
setTimeout(greet, 1600)


$('.hide-button').on
  mouseenter: ->
    $('.main.hidden').addClass 'hide-temporary'
  mouseleave: ->
    $('.main.hidden').removeClass 'hide-temporary'


$('.conversation').bind "DOMSubtreeModified", () ->
	# $(document).scrollTop( $(document).height() )
	scrollToBottom()

scrollToBottom = () ->
	if !projectVisible
		$('html, body').animate({scrollTop: $(document).height() }, 800)
