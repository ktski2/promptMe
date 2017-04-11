# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.home').ready ->
  # dont knoe if i needsavePostOnServer = undefined
  postTimeout = undefined
  progressTimeout = undefined
  typingTimeout = undefined
  doneTypingInterval = 5000 # five seconds
  stopedTyping = 0
  userPost = ''
  removedIndex = 0

  textareaHeight = 0
  linesToRemove = 0;

  scroll_start = 0
  startchange = $('.container-fluid')
  offset = startchange.offset().top
  
  $(document).scroll ->
    scroll_start = $(this).scrollTop()
    if scroll_start > (offset - 70)
      $('#my_navbar').css 'background-color', '#11BFAE'
    else
      $('#my_navbar').css 'background-color', 'transparent'
    return

  savePostOnServer = (formClass, modal) ->
    $(formClass).submit()
    modal.modal 'hide'
    return

  progress = (timeleft, timetotal, $element) ->
    progressBarWidth = (timetotal-timeleft) * ($element.width()/timetotal)
    $element.find('#progressBar').animate({ width: progressBarWidth }, 1000, 'linear')
    if timeleft < 30
      $element.find('#progressBar').css('background-color','#F95959')
    if timeleft > 0
      progressTimeout = setTimeout (->
        progress timeleft - 1, timetotal, $element
        return
      ), 1000
    return

  typingTimer = ->
    stopedTyping++
    if stopedTyping is 3
      doneTypingInterval = 3000
    else if stopedTyping is 5
      doneTypingInterval = 1000

    typingTimeout = setTimeout (->
      console.log "heykt"
      removeLines()
      typingTimer()
      return
    ), doneTypingInterval
    return

  removeLines = ->
    console.log "removing lines"
    return

  $('.card').on 'click', (event) ->
    modalID = '#myModal' #+ event.currentTarget.id
    $(modalID).modal 'show', $(this)
    return

  $('.modal').on 'show.bs.modal', (event) ->
    linesToRemove = 1
    stopedTyping = 0
    doneTypingInterval = 5000
    userPost = ''
    removedIndex = 0

    promptCard = $(event.relatedTarget)
    promptId = promptCard.data('id')
    prompt = promptCard.find('.card-block .card-text').text()

    modal = $(this)
    
    # Put the prompt title in the modal and put the prompt id for saving
    modal.find('.modal-title').text prompt
    modal.find('#modal_prompt').val promptId
    progress(60, 60, $(this)) #300 is five minutes
    postTimeout = setTimeout (->
      formClass = '#form_for_'# + promptId
      #savePostOnServer(formClass, modal)
      return
    ), 10000
    return

  $('.modal').on 'shown.bs.modal', (event) ->
    input = $('#modal_textarea')
    textareaHeight = input.height()
    bodyHeight = $('.modal-body').height()
    input.focus().height(bodyHeight)
    typingTimer()

    input.bind 'cut copy paste', ->
      false

    input.keydown (e) ->
      if e.keyCode is 8
        return false
      return

    #on keyup, start the countdown
    input.on 'keyup', ->
      clearTimeout typingTimeout
      typingTimer()
      return

    #on keydown, clear the countdown 
    input.on 'keydown', ->
      clearTimeout typingTimeout
      return
    return

  $('.modal').on 'hidden.bs.modal', (event) ->
    # clear any text in form when modal closes
    # will need to clear the saved text too
    $('#modal_textarea').height(textareaHeight)
    $(this).find('input,textarea').val('').end()

    $('#progressBar').stop( true, true ).width(0)
    $('#progressBar').css('background-color','#11BFAE')

    clearTimeout postTimeout
    clearTimeout progressTimeout
    clearTimeout typingTimeout
    return

  return
