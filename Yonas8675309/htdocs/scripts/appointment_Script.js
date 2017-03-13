$(document).ready(function() {
    getAppointments();
    bindEvents();
});


function bindEvents() {
    $('#new-button, #cancel-button').click(function(event) {
        event.preventDefault();
        toggleForm(event.currentTarget);
    });

    $('#search-button').click(function(event) {
        event.preventDefault();
        var searchTerm = $('#search-term').val();
        getAppointments(searchTerm);
    });

    $('#add-button').click(function (event) {
        event.preventDefault();
        validateForm();
    });
}

function getAppointments(term) {
    var searchTerm = term || '';
    var ajaxURL = '';

    $.get('http://localhost:/appointments/?q=' + searchTerm)
     .then(function(jsonData) {
        updateResultsTable(jsonData);
      });
}



function updateResultsTable(results) {
    var resultsTable = $('#results-table tbody'),
        markUp = '',
        singleResult = null;
    
    for(i = 0; i < results.length; i++) {
        singleResult = results[i];
        markUp += "<tr><td>" + singleResult.date + "</td><td>" + singleResult.time + "</td><td>" + singleResult.description + "</td></tr>";
    }
    //let's make sure we have a an empty table first
    resultsTable.empty();
    resultsTable.append(markUp);
}


function toggleForm(target) {
    var $form = $('#new-form'),
		$errorContainer = $('.error-list'),
        $newButton = $('#new-button'),
        $clickedButton = $(target);

        if($clickedButton.is('#new-button')) {
            $clickedButton.hide();
            $form.removeClass('hidden');
        } else {
            $form.addClass('hidden');
			$form.trigger('reset');
			$errorContainer.empty();
            $newButton.show();
        }
}
function validateForm() {
    var $form = $('#new-form'),
    	$inputs = $form.find('input[type="text"]'),
		errorMessages = [];

    $inputs.each(function () {
        var error = '',
            inputVal = $(this).val().trim(),
            inputName = $(this).attr('name'),
            inputType = $(this).attr('type');

            if(inputVal.length <= 0) {
              error = inputName + ' is required';
              errorMessages.push(error);
            }
    });

	if(errorMessages.length <= 0) {
		$form.submit();						
	} else {
	    displayError(errorMessages);
	}
}
function displayError(errorMessages) {
	var $errorContainer = $('.error-list');
	
	$errorContainer.empty();
	for(var i = 0; i < errorMessages.length; i++ ) {
		$errorContainer.append('<li>'+errorMessages[i]+'</li>');
	}

	$errorContainer.show();
}
