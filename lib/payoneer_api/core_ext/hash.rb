class Hash
  def delete_blank
    delete_if{|k, v| v.nil? or (v.respond_to?(:empty?) && v.empty?) or (v.instance_of?(Hash) && v.delete_blank.empty?)}
  end

  def deep_find(key)
    key?(key) ? self[key] : self.values.inject(nil) {|memo, v| memo ||= v.deep_find(key) if v.respond_to?(:deep_find) }
  end
end