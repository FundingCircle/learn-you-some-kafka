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

  def self.do_fragment(fragment, is_last, bind)
    print_colorized fragment
    prompt 'execute the above code and see the results'
    result = bind.eval fragment
    pp result
    puts
    prompt 'continue' unless is_last
  end

  def self.fragments
    paths = Dir.glob('fragment_*.rb').sort
    paths[0..-2].map { |path| [path, false] }
                .push([paths[-1], true])
  end

  def self.start
    print "\n"
    bind = binding
    fragments.each { |path, is_last| do_fragment IO.read(path), is_last, bind }
    congrats = '🎉 🎉 🎉  Congratulations, you’ve finished the lesson! 💪 💪 💪'
    puts Rainbow(congrats).background(:silver).bright
  end
end

InteractiveLesson.start
