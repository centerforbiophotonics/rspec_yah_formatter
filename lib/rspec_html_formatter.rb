require 'rspec/core/formatters/base_formatter'
require 'active_support'
require 'active_support/core_ext/numeric'
require 'active_support/inflector'
require 'fileutils'
require 'rouge'
require 'erb'
require 'rbconfig'

require 'example'
require 'specify'

I18n.enforce_available_locales = false

class RspecHtmlFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self, :example_passed, :example_failed,
                                   :example_pending

  REPORT_PATH = './rspec_html_reports'.freeze

  def initialize
    create_reports_dir
    create_resources_dir
    copy_resources
    @examples = []
    @passed = 0
    @failed = 0
    @pending = 0
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
    File.open("#{REPORT_PATH}/report.html", 'w') do |f|
      template_file = File.read(File.dirname(__FILE__) + '/../templates/report.erb')
      f.puts ERB.new(template_file).result(binding)
    end
  end

  private

  # Calculates the total duration and an array used by jscharts with the
  # format [[0, duration1], [1, duration2], ... ]
  def calculate_durations
    @examples = Specify.new(@examples).process
    duration_values = @examples.map(&:run_time)
    duration_values << duration_values.first if duration_values.size == 1

    @durations = @examples.each_with_index.map { |e, i| [i, e] }
    @summary_duration = duration_values.inject(:+).to_s(:rounded, precision: 5)
  end

  def create_reports_dir
    FileUtils.rm_rf(REPORT_PATH) if File.exist?(REPORT_PATH)
    FileUtils.mkpath(REPORT_PATH)
  end

  def create_resources_dir
    file_path = REPORT_PATH + '/resources'
    FileUtils.mkdir_p file_path unless File.exist?(file_path)
  end

  def copy_resources
    FileUtils.cp_r(File.dirname(__FILE__) + '/../resources', REPORT_PATH)
  end
end
