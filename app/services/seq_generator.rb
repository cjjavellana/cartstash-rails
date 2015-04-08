# A singleton sequence generator
# This does not work if we are deploying the application
# to multiple servers. It would be advisable to deploy a separate
# sequence generator service i.e. Zookeper, Twitter snowflake, etc
class SeqGenerator
  include Singleton

  def initialize
    @semaphore = Mutex.new
  end

  def generate_sequence(type, prefix=nil)
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