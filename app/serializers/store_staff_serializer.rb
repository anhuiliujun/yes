class StoreStaffSerializer < ActiveModel::Serializer
  attributes :id, :login_name, :gender, :first_name, :last_name, :work_status
end
