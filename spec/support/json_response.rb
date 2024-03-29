require 'spec_helper'

def json_response
  JSON.parse(response.body).recursively_symbolize_keys!
end

def serialize_and_parse(object, options={})
  JSON.parse(object.active_model_serializer.new(object, options).to_json).recursively_symbolize_keys!
end

def serialize_array_and_parse(array)
  Array(array)
  JSON.parse(ArraySerializer.new(array).to_json)
end

class Hash
  def recursively_symbolize_keys!
    self.symbolize_keys!
    self.values.each do |v|
      if v.is_a? Hash
        v.recursively_symbolize_keys!
      elsif v.is_a? Array
        v.recursively_symbolize_keys!
      end
    end
    self
  end
end

class Array
  def recursively_symbolize_keys!
    self.each do |item|
      if item.is_a? Hash
        item.recursively_symbolize_keys!
      elsif item.is_a? Array
        item.recursively_symbolize_keys!
      end
    end
  end
end
