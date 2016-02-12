require 'rspec/core/formatters/base_formatter'
require 'active_support'
require 'active_support/core_ext/numeric'
require 'active_support/inflector'
require 'fileutils'
require 'rouge'
require 'erb'
require 'rbconfig'
require 'example'

I18n.enforce_available_locales = false

class RspecYahFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self, :example_passed, :example_failed,
                                   :example_pending

  def initialize(io_standard_output)
    @examples = []
    @passed = 0
    @failed = 0
    @pending = 0
    unless io_standard_output.is_a?(File)
      raise 'You should specify a file with the --out option, STDOUT cannot be used with this formatter'
    end
    @io_standard_output = io_standard_output
    copy_resources
  end

  def example_passed(notification)
    @passed += 1
    @examples << Example.new(notification.example)
  end

  def example_failed(notification)
    @failed += 1
    @examples << Example.new(notification.example)
  end

  def example_pending(notification)
    @pending += 1
    @examples << Example.new(notification.example)
  end

  def close(notification)
    calculate_durations
    File.open(@io_standard_output, 'w') do |f|
      template_file = File.read(File.dirname(__FILE__) + '/../templates/report.erb')
      f.puts ERB.new(template_file).result(binding)
    end
  end

  private

  # Calculates the total duration and an array used by jscharts with the
  # format [[0, duration1], [1, duration2], ... ]
  def calculate_durations
    duration_values = @examples.map(&:run_time)
    duration_values << duration_values.first if duration_values.size == 1

    @durations = duration_values.each_with_index.map { |e, i| [i, e] }
    @summary_duration = duration_values.inject(:+).to_s(:rounded, precision: 5)
  end

  def copy_resources
    FileUtils.cp_r(File.dirname(__FILE__) + '/../resources', File.dirname(@io_standard_output))
  end
end
