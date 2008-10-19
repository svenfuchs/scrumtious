
class Test::Unit::TestCase
  def assert_updated(record, *attr_names)
    old_attributes = record.attributes
    yield
    new_attributes = record.reload.attributes

    if attr_names.empty?
      assert_not_equal old_attributes, new_attributes, "should have changed #{record}"
    else
      attr_names.map!(&:to_s)
      changed = attr_names.select do |attr_name|
        raise "unknown attribute #{attr_name.inspect}" unless record.attributes.has_key? attr_name
        old_attributes[attr_name] != new_attributes[attr_name]
      end
      msg = "should have changed the attributes #{attr_names.inspect}, but only found changes to #{changed.inspect} (#{record})"
      assert_equal attr_names, changed, msg
    end
  end
end