class Mis::BaseController < ApplicationController

## add store_attrs to params
  def append_store_attrs options
    nested_attrs = options.select(&nested_selector).transform_values(&nested_transformer)
    options.merge(store_options).merge(nested_attrs)
  end

  def store_options
    {staffer_id: current_staffer.id, store_id: @store.id}
  end

  def nested_transformer
    -> (v) { v.is_a?(Array) ? v.map { |x| x.merge(store_options) } : v.merge(store_options) }
  end

  def nested_selector
    -> (k, v) { k.end_with?('_attributes') }
  end

end
