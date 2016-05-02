require 'spec_helper'

describe CreateStoreService do
  it 'creates the store with supplied parameters' do
    service = CreateStoreService.new(@params)
    service.call
  end
end
