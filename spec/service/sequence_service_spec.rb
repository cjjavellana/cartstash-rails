require 'rails_helper'

describe SeqGenerator do

  describe "Sequence generation" do

    before(:all) do
      # create the sequences
      create(:membership_sequence)
      create(:payment_sequence)
    end

    it "succeeds when there is no duplicate" do
      seq_list = generate_sequences

      # Ensure that we have generated 50 items
      expect(seq_list.length).to eq(50)

      # Ensure that there is no duplicate
      expect(has_duplicate(seq_list)).to be_nil

    end # it ... do

    it "fails when there is a duplicate" do
      seq_list = generate_sequences
      #disrupt the sequences by inserting a duplicate
      seq_list.push(seq_list[seq_list.length - 1])
      expect(has_duplicate(seq_list)).to_not be_nil
    end
  end

  private
    def has_duplicate(seq_list)
      seq_list.detect { |e| seq_list.rindex(e) != seq_list.index(e) }
    end

    def generate_sequences
      seq_generator = SeqGenerator.instance
      sequences = []
      threads = (1..5).map do |i|
        Thread.new(i) do
          val = []
          (1..10).each do |j|
            type = ((j % 2) == 0) ? "payment" : "membership"
            seq = seq_generator.generate_sequence type
            val.push("#{type}-#{seq}")
          end
          sequences.push(val)
        end # thread.new
      end # (1..5).map

      threads.each do |t|
        t.join
      end # threads.each

      seq_aggregator = []
      sequences.each do |seq|
        seq_aggregator.concat seq
      end

      seq_aggregator
    end

end