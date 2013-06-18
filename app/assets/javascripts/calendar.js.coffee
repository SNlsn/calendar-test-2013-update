$(document).ready ->  
    $('#calendar').fullCalendar
    editable: false,
    allDaySlot: false,
    header:
        left: 'prev,next today',
        center: 'title',
        right: 'month,agendaWeek,agendaDay'
    defaultView: 'agendaWeek',
    firstHour: 8,
    height: 500,
    slotMinutes: 30,

    eventSources: [{
        url: '/assignments',
        ignoreTimezone: false
    }],

    timeFormat: 'h:mm t{ - h:mm t} ',
    dragOpacity: "0.5"

    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
        updateEvent(event);

    eventResize: (event, dayDelta, minuteDelta, revertFunc) ->
        updateEvent(event);


    updateEvent = (the_event) ->
        $.update "/assignments/" + the_event.id,
    event: 
        title: the_event.title,
        starts_at: "" + the_event.start,
        ends_at: "" + the_event.end,
        description: the_event.description