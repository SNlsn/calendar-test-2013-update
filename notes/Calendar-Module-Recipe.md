#Calendar Module Recipe #


June, 2013.

An improved calendar module for Unify2 development, using FullCalendar and jQueryUI datetime add-on, which adds a time selector to the jQueryUI calendar

##Resources##

* Bokmann [FullCalendar-Rails gem](https://github.com/bokmann/fullcalendar-rails)
* Bokmann [example project](https://github.com/bokmann/fullcalendar_assets)
* Trent Richardson [jQuery TimePicker Addon](http://trentrichardson.com/examples/timepicker/)
* RailsCasts [revised calendar episode](http://railscasts.com/episodes/213-calendars-revised)

##Development Environment:##
following rails_apps instructions [here:](http://railsapps.github.io/installing-rails.html)

- update rvm and system gem
- install Ruby 2.0.0

##General Notes ##

Bockmann's index controller action for his Event model has a bunch of stuff I don't understand using "scope." My project seems to work without that. I **did** use the "scope" stuff in the model. I don't understand it (or the lambda), but it works.

###Formating date/time strings: ###


strftime expression that looks nice (add to all event views that show time: show, edit, index):

	.strftime("%A %b. %-e, %Y, %l:%M%p")
	
 for example:

	<%= @event.starts_at.strftime("%A %b. %-e, %Y, %l:%M%p") %>

##New Project: ##

Note, the somewhat unusual syntax is from Rails_Apps - no need to make a .rvmrc file with this method

	mkdir FullCalendar-Module-06-2013
	cd FullCalendar-Module-06-2013
	rvm use ruby-2.0.0@FullCalendar-Module-06-2013 --ruby-version --create
	gem install rails --version=3.2.13
	rails new .

Open in SublimeText2, and make it a Project.

Add this to the .gitignore file Rails generates:

	# Ignore other unneeded files
	doc/
	*.swp
	*~
	.project
	.DS_Store
	*.sublime-project
	*.sublime-workspace

* rename README.rdoc to README.md and add some sane content.
* delete public/index.html

**Add** the following to the Gemfile (because there are already some items in Assets group by default):

	group :assets do
		gem 'jquery-ui-rails'
		gem 'jquery-rest-rails'
		gem 'fullcalendar-rails'
	end
	
	gem 'simple_form'
	
	group :development do
	  gem 'better_errors'
	end

* run bundle command: bundle install
* run generator:

	rails generate simple_form:install

make initial git commit:

	git init
	git add .
	git commit -m "initial commit"

* allocate fullcalendar gem assets

	* css (add before _self and _tree):

		* *= require jquery.ui.datepicker
		* *= require time-picker
		* *= require fullcalendar
		* *= require fullcalendar.print

	* and javascript (add before _tree):
		* //= require jquery.ui.datepicker
		* //= require jquery.ui.draggable
		* //= require jquery.ui.droppable
		* //= require jquery.ui.resizable
		* //= require jquery.ui.selectable
		* //= require jquery-ui-timepicker-addon
		* //=require jquery.rest
		* //= require fullcalendar

commit new to git

	git add .
	git commit -m "Project prior to generating scaffold"

generate scaffold:

	rails g scaffold assignment title description:text assignment_type starts_at:datetime clarify_start duration_hours:integer duration_minutes:integer ends_at:datetime all_day:boolean

before running migration, modify migration file to add ":default => false" to the :all_day item (which needs to be there for FullCalendar, but which we won't use):

	t.boolean :all_day, :default => false

	rake db:migrate

create a new controller (no model), calendars_controller.rb:

	class CalendarsController < ApplicationController
	  def show
	  end
	end

create a new view for that controller:

* create new folder "calendars"
* create new file show.html.erb

	<%= link_to "new assignment", new_assignment_path %>
	<div id='calendar'></div>

update routes:

	resource :calendar, :only => [:show]
	root :to => 'calendars#show'

add app>assets>javascripts file named calendar.js.coffee:

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

new stylesheet calendar.css.scss (it is **NOT** necessary to require this in application.css):

	.confirmed, .fc-agenda .confirmed .fc-event-time, .confirmed a,  .confirmed .fc-event-skin {
    background-color: #D0F6C8; /* background color */
    border-color: #ddd;     /* border color */
    color: #000;           /* text color */
    }

	.tentative, .fc-agenda .tentative .fc-event-time, .tentative a, .tentative .fc-event-skin {
	   background-color: #CBB9F1; /* background color */
	   border-color: #ddd;     /* border color */
	   color: #000;           /* text color */
	   }


	.personal, .fc-agenda .personal .fc-event-time, .personal a, .personal .fc-event-skin {
    background-color: #B3E7F0; /* background color */
    border-color: #ddd;     /* border color */
    color: #000;           /* text color */
    }

Edit assignments.helper.rb

	module AssignmentsHelper
		def assignment_type_options
		['confirmed', 'tentative', 'personal']
	   end
	   def clarify_start_options
	      ['ready at:', 'arrive at:']
	    end
	end

Then, modify these lines in the assignments _form view (also delete "all_day" and "ends_at" inputs):

	<%= f.input :assignment_type, :collection => assignment_type_options %>
	<%= f.input :starts_at, as: :string %>
	<%= f.input :clarify_start, :collection => clarify_start_options, :as => :radio_buttons %>

Replace Assignment Model code with this:

	class Assignment < ActiveRecord::Base
		attr_accessible :assignment_type, :clarify_start, :description, :duration_hours, :duration_minutes, :ends_at, :starts_at, :title

    scope :between, lambda {|start_time, end_time|
    {:conditions => ["? < starts_at < ?", Event.format_date(start_time), Event.format_date(end_time)] }
	}
  
	# create the "ends_at" value like this:
    before_save :create_end

	# need to override the json view to return what full_calendar is expecting.
	# http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
	def as_json(options = {})
    {
      :id => self.id,
      :title => self.title,
      :description => self.description || "",
      :start => starts_at.rfc822,
      :end => ends_at.rfc822,
      :allDay => self.all_day,
      :recurring => false,
      :className => self.assignment_type,
      :url => Rails.application.routes.url_helpers.assignment_path(id)
    }

	end

	def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
	end

		private
    		def create_end
      		unless starts_at.nil?
    		self.ends_at = starts_at.advance(:hours => duration_hours, :minutes => duration_minutes)
			end
	    end

	end

modify config>application.rb:

	config.time_zone = 'Eastern Time (US & Canada)'

Create (or modify) assignments.js.coffee:

	jQuery ->
		$('#assignment_starts_at').datetimepicker
    		controlType: 'select',
			hour: '9',
			dateFormat: 'yy-mm-dd',
			timeFormat: 'hh:mm TT',
			stepMinute: 15

Modify Assignment Show view:

	<p>
		<b><%= @assignment.clarify_start unless @assignment.clarify_start.nil? %></b>
		<%= @assignment.starts_at.strftime("%A %b. %-e, %Y, %l:%M%p") %>
	</p>


Try it out and then commit to git