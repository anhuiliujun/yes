class CreateOperationLogService
  include Serviceable

  def initialize(operation_log)
    @operation_log = operation_log
  end

  def call
    @operation_log.transaction do
      @operation_log.save!
      @operation_log.resource.toggle_available!
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
