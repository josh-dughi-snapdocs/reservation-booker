class Reservation < ApplicationRecord
  belongs_to :property
  belongs_to :user

  validates :start_date, :end_date, presence: true
  validate :start_date_cannot_be_in_past, :end_date_must_be_after_start_date
  validate :property_must_be_available

  def start_date_cannot_be_in_past
    if start_date_in_past?
      errors.add(:start_date, "must not be in the past")
    end
  end

  def end_date_must_be_after_start_date
    if end_date_after_start_date?
      errors.add(:end_date, "must not be before start date")
    end
  end

  def property_must_be_available
    if start_date.present? && end_date.present?
      if Reservation.where(property: property).
        where('end_date >= :sd and start_date <= :ed',
              sd: start_date, ed: end_date).present?
        errors.add(:property, "is not available for selected dates")
      end
    end
  end

  private

    def start_date_in_past?
      start_date.present? && start_date.to_date < Date.today
    end

    def end_date_after_start_date?
      start_date.present? &&
        end_date.present? &&
        end_date.to_date < start_date.to_date
    end

end
