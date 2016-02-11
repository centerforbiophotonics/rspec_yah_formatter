class Specify

  def initialize(examples)
    @examples = examples
  end

  def process
    lines = File.readlines(@examples.first.file_path)
    @examples.each_with_index do |e, i|
      start_line = e.metadata[:line_number]
      end_line = @examples[i+1].nil? ? lines.size : @examples[i+1].metadata[:line_number] - 1
      code_block = lines[start_line..end_line]
      spec = code_block.select { |l| l.match(/#->/) }.join('')
      if !spec.split.empty?
        formatter = Rouge::Formatters::HTML.new(css_class: 'highlight')
        lexer = Rouge::Lexers::Gherkin.new
        formatted_spec = formatter.format(lexer.lex(spec.gsub('#->', '')))
        e.set_spec(formatted_spec)
      end
    end
    @examples
  end
end
