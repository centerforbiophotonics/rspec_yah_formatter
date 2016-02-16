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

# Formatter that builds a pretty html report, and includes a screenshot if it
# is included in the example metadata.
class RspecYahFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self, :example_passed, :example_failed,
                                   :example_pending

  def initialize(out_file)
    @examples = []
    @passed = 0
    @failed = 0
    @pending = 0
    if !out_file.is_a?(File)
      raise 'You should specify a html file with the --out option, STDOUT cannot be used with this formatter'
    end
    @out_file = out_file
  end

  def example_passed(notification)
    @passed += 1
    @examples << Example.new(notification.example, @out_file)
  end

  def example_failed(notification)
    @failed += 1
    @examples << Example.new(notification.example, @out_file)
  end

  def example_pending(notification)
    @pending += 1
    @examples << Example.new(notification.example, @out_file)
  end

  def close(_notification)
    calculate_durations
    File.open(@out_file, 'w') do |file|
      template_file = File.read(File.dirname(__FILE__) + '/../templates/report.erb')
      file.puts ERB.new(template_file).result(binding)
    end
    copy_resources
  end

  private

  # Calculates the total duration and an array used by jscharts with the
  # format [[0, duration1], [1, duration2], ... ]
  def calculate_durations
    duration_values = @examples.map(&:run_time)
    duration_values << duration_values.first if duration_values.size == 1

    @durations = duration_values.each_with_index.map { |e, i| [i, e] }
    @summary_duration = duration_values.inject(:+).to_f.to_s(:rounded, precision: 5)
  end

  # Copies resources to the same folder where the report will be saved
  def copy_resources
    FileUtils.cp_r(File.dirname(__FILE__) + '/../resources', File.dirname(@out_file))
  end
end
