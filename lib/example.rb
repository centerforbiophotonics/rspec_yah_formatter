
require 'oopsy'

class Example

  attr_reader :description, :full_description, :run_time, :duration, :status, :exception, :file_path, :metadata, :spec

  def initialize(example)
    @description = example.description
    @full_description = example.full_description
    @execution_result = example.execution_result
    @run_time = (@execution_result.run_time).round(5)
    @duration = @execution_result.run_time.to_s(:rounded, precision: 5)
    @status = @execution_result.status.to_s
    @metadata = example.metadata
    @file_path = @metadata[:file_path]
    @exception = Oopsy.new(example.exception, @file_path)
    @spec = nil
  end

  def has_exception?
    !@exception.klass.nil?
  end

  def has_spec?
    !@spec.nil?
  end

  def set_spec(spec)
    @spec = spec
  end

  def klass(prefix='label-')
    class_map = {passed: "#{prefix}success", failed: "#{prefix}danger", pending: "#{prefix}warning"}
    class_map[@status.to_sym]
  end

end
