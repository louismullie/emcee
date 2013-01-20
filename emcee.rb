# Rap lyric generator using Markov Chains.
# 
# Inspired from Dominik Bhaton's submission
# at http://www.rubyquiz.com/quiz74.html.
class Emcee
  
  def initialize(order, max_length = 40)

    @order, @range = order, -order..-1
    @sentences, @max_length = {}, max_length
    @beginnings, @freq = [], {}

  end

  public
  
  def rehearse(text)

    sentences = text.split("\n")
    sentences.each do |sent|
      next if sent == ''
      next if @sentences[sent]
      next if sent.size <= @order
      learn_line(sent)
      @sentences[sent] = sent
    end

  end

  def rhyme

    length, retries = 0, 10
    words = @beginnings.sample
    while words.size < 12
      break if retries < 1
      prev = words[@range]
      last_gram = prev.map(&:to_s)
      if next_gram = follows(last_gram)
        words << next_gram
        length += next_gram.size
      else
        retries -= 1
      end
    end

    format(words.join(' '))

  end
  
  def rap(number = 4)
    
    rhymes, count = [], 0
    
    while count < number
      current = rhyme || []
      rhymes << current; count += 1
    end 
    
    rhymes.join("\n")
    
  end

  private

  def learn_line(sentence)

    words = sentence.split(/\s+/)
    return unless words.size > 5

    buf = []

    words.each do |word|
      buf << word.to_s
      next unless buf.size == @order + 1
      (@freq[buf[0..-2]] ||= []) << buf[-1]
      buf.shift
    end

    @beginnings << words[0..@order].map(&:to_s)

  end

  def follows(words)
    
    arr = @freq[words]
    arr && arr.sample
    
  end

  def format(str)
    
    re = /([^A-Za-z])i([^A-Za-z])/
    str.capitalize.gsub(re) { $1+'I'+$2 }
    
  end

end