require 'rainbow'
require 'rouge'

# An interactive Ruby lesson.
module InteractiveLesson
  # NB: this is duplicated in test_unit.rb. We haven’t yet crossed the Rule of
  # Three threshold, though, so this is fine.
  def self.print_colorized(fragment)
    formatter = Rouge::Formatters::Terminal256.new
    lexer = Rouge::Lexers::Ruby.new
    puts formatter.format lexer.lex fragment
  end

  def self.prompt(str)
    puts Rainbow("—— Press ⏎ to #{str} ——").background(:silver)
    STDIN.gets
  end

  def self.do_fragment(code, is_last, bind)
    print_colorized code
    prompt 'execute the above code and see the results'
    result = bind.eval code
    pp result
    puts
    prompt 'continue' unless is_last
  end

  def self.remove_test_assertions(code)
    marker_index = code.index '# TEST_ASSERTIONS #'
    if marker_index
      code[0..marker_index - 2] # Remove the test marker and the extra newline.
    else
      code
    end
  end

  def self.read_fragments
    Dir.glob('fragment_*.rb')
       .sort # It’s very important to run the fragments in order.
       .map { |path| IO.read path }
       .map { |code| remove_test_assertions code }
  end

  def self.start
    print "\n"

    code_fragments = read_fragments

    bind = binding
    code_fragments.each_with_index
                  .map { |code, i| [code, i == code_fragments.length - 1] }
                  .each { |code, is_last| do_fragment code, is_last, bind }

    congrats = '🎉 🎉 🎉  Congratulations, you’ve finished the lesson! 💪 💪 💪'
    puts Rainbow(congrats).background(:silver).bright
  end
end

InteractiveLesson.start
