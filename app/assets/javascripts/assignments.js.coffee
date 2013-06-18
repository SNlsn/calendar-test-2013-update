# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
    $('#assignment_starts_at').datetimepicker
        controlType: 'select',
        hour: '9',
        dateFormat: 'yy-mm-dd',
        timeFormat: 'hh:mm TT',
        stepMinute: 15