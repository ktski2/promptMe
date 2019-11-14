$(document).on("turbolinks:load", function() {
  var doneTypingInterval, lastRemovedIndex, linesToRemove, offset, postTimeout, progress, progressTimeout, removeLines, savePostOnServer, clearTimeoutHandle, scroll_start, startchange, stopedTyping, typingTimeout, typingTimer, userPostToSave;

  scroll_start = 0;
  startchange = $('.container-fluid');
  offset = startchange.offset();

  // Line removal variables
  var preRemoveHtml = '<del>';//'<span class="removed_wrap"><span class="removed_text">';
  var postRemoveHtml = '</del>';//'</span></span>';

  $(document).scroll(function() {
    if ($('.home').length && !$('#mobileCarousel').length) {
      scroll_start = $(this).scrollTop();
      if (startchange.length && scroll_start > (offset.top - 70)) {
        $('#my_navbar').css('background-color', '#11BFAE');
      } else {
        $('#my_navbar').css('background-color', 'transparent');
      }
    } else {
      return;
    }
  });

  initialiizeVars = function() {
    postTimeout = null;
    progressTimeout = null;
    typingTimeout = null;

    doneTypingInterval = 5000;
    stopedTyping = 0;
    linesToRemove = 1;

    lastRemovedIndex = 0;
    userPostToSave = [];
    stopedTyping = 0;
  };
  // Actually submit the form or redirect to the log-in page if the user is not signed in
  savePostOnServer = function(formClass, modal) {
    var currentText = $('#myModal').find('#modal_textarea').val();
    if (currentText.trim().length != 0) {
      var workingArray = currentText.replace(/(<([^>]+)>)/ig, '').replace(/([.?!])/g, "$1|").split("|");
      var temp = userPostToSave.concat(workingArray.slice(lastRemovedIndex));
      userPostToSave = temp;
    }

    $('#myModal').find('#modal_textarea').val(userPostToSave.join(''));
    $(formClass).submit();
    modal.modal('hide');
  };

  clearTimeoutHandle = function(timeoutHandle) {
    if(timeoutHandle){
      clearTimeout(timeoutHandle);
      timeoutHandle = null;
    }
  };

  showModal = function(response) {
    $('#myModal').modal('show', response);
  };

  progress = function(timeleft, timetotal, $element) {
    var progressBarWidth;
    progressBarWidth = (timetotal - timeleft) * ($element.width() / timetotal);
    $element.find('#progress').animate({
      width: progressBarWidth
    }, 1000, 'linear');
    if (timeleft < 30) {
      $element.find('#progress').css('background-color', '#F95959');
    }
    if (timeleft > 0) {
      clearTimeoutHandle(progressTimeout);
      progressTimeout = setTimeout((function() {
        progress(timeleft - 1, timetotal, $element);
      }), 1000);
    }
  };

  typingTimer = function() {
    if (stopedTyping === 3) {
      doneTypingInterval = 3000;
     } //else if (stopedTyping === 5) {
    //   doneTypingInterval = 1000;
    // }
    clearTimeoutHandle(typingTimeout);
    typingTimeout = setTimeout((function() {
      stopedTyping++;
      removeLines();
      typingTimer();
    }), doneTypingInterval);
  };

  removeLines = function() {
    var currentText = $('#myModal').find('#modal_textarea').val();
    var temp;
    var index;

    // Create the array variables to manipulate textarea content
    var workingArray = currentText.replace(/(<([^>]+)>)/ig, '').replace(/([.?!])/g, "$1|").split("|");
    var workingLength = workingArray.length;

    // index of the beginning of line removal
    var start = (workingLength - linesToRemove) < 0 ? 0 : (workingLength - linesToRemove);

    // Don't do anything, the User hasn't written anything yet.
    if (currentText == '') {
      return false;
    }

    // Remove last item in array if it contains no content
    if (workingArray[workingLength - 1].trim().length === 0) {
      workingArray.pop();
      workingLength -= 1;
      start -=1 ;
    }

    // For simple case we just need to add html tags in front and after the last element of the array
    if (linesToRemove == 1) {
      workingArray[workingLength - 1] = preRemoveHtml + workingArray[workingLength - 1] + postRemoveHtml;
    } else {
      // Add the html tag to the end of appropriate array
      if (lastRemovedIndex == workingLength) {
        // No new lines, so only care about the already saved sentences
        userPostToSave[userPostToSave.length - 1] += postRemoveHtml;
      } else {
        workingArray[workingLength - 1] += postRemoveHtml;
      }

      // need to add the pretag in the appropriate array
      if (start < lastRemovedIndex) {
        // We have to remove lines that have already been saved  off.
        index = userPostToSave.length - (workingLength - linesToRemove + lastRemovedIndex) + 1;
        if (index >= userPostToSave.length) {
          // This is the case where we are trying to remove more or the same amount that we have in our
          // working array and some or all of the values have already been added to the saved post
          userPostToSave[start] = preRemoveHtml + userPostToSave[start];
        } else {
          var currIndex = userPostToSave.indexOf(workingArray[start]);
          var difference = userPostToSave.slice(0,currIndex).filter(x => !workingArray.includes(x));
          userPostToSave[start + difference.length] = preRemoveHtml + userPostToSave[start + difference.length];
        }
      } else {
        workingArray[start] = preRemoveHtml + workingArray[start];
      }
    }

    // Add the new lines plus those with html to signify they were removed
    if (lastRemovedIndex != workingLength) {
      temp = userPostToSave.concat(workingArray.slice(lastRemovedIndex));
      userPostToSave = temp;
    }

    // Remove the desired lines from the working array
    workingArray.splice(start, linesToRemove);
    // Reset the text area with the working array less the lines removed
    $('#modal_textarea').val(workingArray.join(''));

    // Increase the number of lines to remove and update the lastRemovedIndex
    lastRemovedIndex = workingLength - linesToRemove;
    linesToRemove++;
  };

  $('.card').on('click', function(event) {
    var modalID;
    modalID = '#myModal';
    $(modalID).modal('show', $(this));
  });

  $('#myModal').on('show.bs.modal', function(event) {
    var modal, prompt, promptCard, promptId, userID;
    initialiizeVars();

    promptCard = $(event.relatedTarget);
    promptId = promptCard.data('id') || event.relatedTarget.id;
    prompt = promptCard.find('.card-body .card-text').text() || event.relatedTarget.content;

    modal = $(this);
    modal.find('.modal-title').text(prompt);
    modal.find('#modal_prompt').val(promptId);
    userID = modal.find('#post_user_id').val();

    // start typing timer
    typingTimer();
    progress(300, 300, modal);

    clearTimeoutHandle(postTimeout);
    postTimeout = setTimeout((function() {
      var formClass;
      formClass = '#form_for_';

      if (userID != 2) {
        savePostOnServer(formClass, modal);
      } else {
        clearTimeoutHandle(postTimeout);
        clearTimeoutHandle(progressTimeout);
        clearTimeoutHandle(typingTimeout);

        $('#myModal_body').addClass("no-display");
        $('.save_options').css({
          display: 'inherit'
        });
      }
    }), 300000);//300000
  });

  $("html").on("keyup", function(e) {
    if(e.keyCode === 27 && $('#myModal_body').hasClass("no-display")) {
      $('#myModal_body').removeClass("no-display");
      $('.save_options').css({
        display: 'none'
      });
      $('#myModal').modal('hide');
    }
  });

  $('#myModal').on('shown.bs.modal', function(event) {
    var bodyHeight, input;
    input = $('#modal_textarea');
    bodyHeight = $('.modal-body').height();
    input.focus().height(bodyHeight);
    typingTimer();

    input.bind('cut copy paste', function() {
      return false;
    });
    input.keydown(function(e) {
      if (e.keyCode === 8) {
        return false;
      }
    });
    input.on('keyup', function() {
      typingTimer();
    });
    input.on('keydown', function() {
      clearTimeoutHandle(typingTimeout);
    });
  });
  $('#myModal').on('hidden.bs.modal', function(event) {
    // Sets the textarea height back to it's initial state
    $('#modal_textarea').height('initial');
    var userID = $(this).find('#post_user_id').val();
    if (userID === 2) {
      $('#myModal_body').removeClass("no-display")
      $('.save_options').css({
        display: 'none'
      });
    }
    $(this).find('form')[0].reset();
    $('#progressBar').stop(true, true).width(0);
    $('#progressBar').css('background-color', '#11BFAE');
    clearTimeoutHandle(postTimeout);
    clearTimeoutHandle(progressTimeout);
    clearTimeoutHandle(typingTimeout);
  });

  $('.download-button').on('click', function(event) {
    console.log('here');
    var modal = $('#myModal');
    var title = modal.find('.modal-title').text();
    var post = modal.find('#modal_textarea').val();
    $('input[name=pprompt]').val(title);
    $('input[name=ptext]').val(post);
    $('.button_form').submit();
    modal.modal('hide');
  });

  $('#creat_account_button').on('click', function(event) {
    modal = $(this);
    formClass = '#form_for_';
    savePostOnServer(formClass, modal);
  });

  $('#how_button').on('click', function(event) {
    $('#howModal').modal('show');
  });

  $('#random-post').on('click', function(event) {
    var userID = $('#post_user_id').val();
    event.preventDefault();
    $.ajax({
      method: "GET",
      url: "random_post",
      data: { user_id: userID },
      dataType: 'json'
    }).done(function(response) {
      showModal(response);
    });
  });
});
