class EventWeekly < ApplicationRecord
  belongs_to :event
  #Date.commercial(2010, week_number, 1)

  def partial_week_update(date)
    day = date.to_date.wday

    if day == 1
        sunday = false
      elsif day == 2
        sunday = false
        monday = false
      elsif day == 3
        sunday = false
        monday = false
        tuesday = false
      elsif day == 4
        sunday = false
        monday = false
        tuesday = false
        wednesday = false
      elsif day == 5
        sunday = false
        monday = false
        tuesday = false
        wednesday = false
        thursday = false
      elsif day == 6
        sunday = false
        monday = false
        tuesday = false
        wednesday = false
        thursday = false
        friday = false
      end
  end

  def beg_week_delete(date)
    day = date.wday

    if day == 6
      saturday = false
    elsif day == 5
      saturday = false
      friday = false 
    elsif day == 4
      saturday = false
      friday = false
      thursday = false
    elsif day == 3
      saturday = false
      friday = false
      thursday = false
      wednesday = false
    elsif day == 2
      saturday = false
      friday = false
      thursday = false
      wednesday = false
      tuesday = false
    elsif day == 1
      saturday = false
      friday = false
      thursday = false
      wednesday = false
      tuesday = false
      monday = false
    elsif day == 0
      saturday = false
      friday = false
      thursday = false
      wednesday = false
      tuesday = false
      monday = false
      sunday = false
    end
  end

end
