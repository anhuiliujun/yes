class CreateStafferService
  include Serviceable

  attr_reader :staffer

  def initialize(staffer)
    @staffer = staffer
  end

  def call
    @staffer.transaction do
      @staffer.save!
      @staffer.update!(fullname: @staffer.fullname)
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
