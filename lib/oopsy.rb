class Oopsy
  attr_reader :klass, :message, :backtrace, :highlighted_source, :explanation, :backtrace_message

  def initialize(exception, file_path)
    @exception = exception
    @file_path = file_path
    unless @exception.nil?
      @klass = @exception.class
      @message = @exception.message.encode('utf-8')
      @backtrace = Array(@exception.backtrace)
      @backtrace_message = @backtrace.select { |r| r.match(@file_path) }.join('').encode('utf-8')
      @highlighted_source = process_source
      @explanation = process_message
    end
  end

  private

def os
    @os ||= (
      host_os = RbConfig::CONFIG['host_os']
      case host_os
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        :windows
      when /darwin|mac os/
        :macosx
      when /linux/
        :linux
      when /solaris|bsd/
        :unix
      else
        raise Exception, "unknown os: #{host_os.inspect}"
      end
    )
  end

  def process_source
    data = @backtrace_message.split(':')
    unless data.empty?
    if os == :windows
      file_path = data[0] + ':' + data[1]
      line_number = data[2].to_i
    else
       file_path = data.first
       line_number = data[1].to_i
    end
    lines = File.readlines(file_path)
    start_line = line_number-2
    end_line = line_number+3
    source = lines[start_line..end_line].join("").sub(lines[line_number-1].chomp, "--->#{lines[line_number-1].chomp}")

    formatter = Rouge::Formatters::HTML.new(css_class: 'highlight', line_numbers: true, start_line: start_line+1)
    lexer = Rouge::Lexers::Ruby.new
    formatter.format(lexer.lex(source.encode('utf-8')))
    end
  end

  def process_message
    formatter = Rouge::Formatters::HTML.new(css_class: 'highlight')
    lexer = Rouge::Lexers::Ruby.new
    formatter.format(lexer.lex(@message))
  end

end
