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