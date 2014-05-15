
module RestCore; end
class RestCore::Clash
  Empty = Hash.new(&(l = lambda{|_,_|Hash.new(&l).freeze})).freeze

  attr_accessor :hash
  def initialize hash
    self.hash = hash
  end

  def [] k
    if hash.key?(k)
      if (ret = hash[k]).kind_of?(Hash)
        RestCore::Clash.new(ret)
      else
        ret
      end
    else
      Empty
    end
  end

  def == rhs
    if rhs.kind_of?(RestCore::Clash)
      hash == rhs.hash
    else
      hash == rhs
    end
  end

  def respond_to_missing? msg, include_private=false
    hash.respond_to?(msg, include_private)
  end

  def method_missing msg, *args, &block
    if hash.respond_to?(msg)
      hash.public_send(msg, *args, &block)
    else
      super
    end
  end
end