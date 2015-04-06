class  SequenceService
  @semaphore = Mutex.new

  def self.generate_sequence(type, prefix=nil)
    @semaphore.synchronize {
     seq = Sequence.find_by_name(type)
     seq.value += 1
     seq.save

     val = seq.value
     unless prefix.nil?
       "#{prefix}-#{val}"
     else
       "#{val}"
     end
    }
  end

end