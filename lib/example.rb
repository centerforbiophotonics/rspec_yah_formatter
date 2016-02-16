
require 'oopsy'
require 'pathname'

class Example

  attr_reader :description, :full_description, :run_time, :duration, :status,
              :exception, :file_path, :metadata, :spec

  def initialize(example, report_folder)
    @description = example.description
    @full_description = example.full_description
    @execution_result = example.execution_result
    @metadata = example.metadata
    @file_path = @metadata[:file_path]
    @exception = Oopsy.new(example.exception, @file_path)
    @spec = nil
    @report_folder = report_folder
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

  def klass(prefix = 'label-')
    class_map = { passed: "#{prefix}success", failed: "#{prefix}danger", pending: "#{prefix}warning" }
    class_map[status.to_sym]
  end

  def screenshot
    return nil unless @metadata[:screenshot]

    unless File.exist?(@metadata[:screenshot])
      puts "The screenshot '#{@metadata[:screenshot]}' does not exist"
    end

    path = Pathname.new(File.dirname(@report_folder))
    Pathname.new(@metadata[:screenshot]).relative_path_from(path).to_s
  end

  def run_time
    (@execution_result.run_time).round(5)
  end

  def duration
    @execution_result.run_time.to_s(:rounded, precision: 5)
  end
  def status
    @execution_result.status.to_s
  end
end
