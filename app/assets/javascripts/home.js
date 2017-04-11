// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

/*$('.home').ready ->

  $('.card').on 'click', (event) ->
    $('#myModal').modal('show',$(this));
    return

  $('#myModal').on 'show.bs.modal', (event) ->
    promptCard = $(event.relatedTarget)
    promptId = promptCard.data('id')
    prompt = promptCard.find('.card-block .card-text').text()
    console.log(prompt)
    # Extract info from data-* attributes
    # If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    # Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    # savePostOnServer()
    modal = $(this)
    modal.find('.modal-title').text prompt
    return

  savePostOnServer = ->
    $.ajax(
      url: '/path/to/file'
      type: 'default GET (Other values: POST)'
      dataType: 'default: Intelligent Guess (Other values: xml, json, script, or html)'
      data: param1: 'value1').done(->
      console.log 'success'
      return
    ).fail(->
      console.log 'error'
      return
    ).always ->
      console.log 'complete'
      return
    return    

  return

#$(".home").ready(function() {
#  return alert("My example alert box.");
#  $('.card-block').on('click', function(event) {
#     alert('You clicked the Bootstrap Card');
#  });
#});*/
