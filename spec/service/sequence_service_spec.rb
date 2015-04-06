require 'rails_helper'

describe SeqGenerator do
  fixtures :sequences

  describe "Sequence generation" do

    it "succeeds when there is no duplicate" do
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

      final_seq_list = []
      sequences.each do |seq|
        final_seq_list.concat seq
      end

      # Ensure that we have generated 50 items
      expect(final_seq_list.length).to eq(50)

      # Ensure that there is no duplicate
      result = final_seq_list.detect { |e| final_seq_list.rindex(e) != final_seq_list.index(e) }
      expect(result).to eq(nil)

    end # it ... do

    it "fails when there is a duplicate" do
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

      final_seq_list = []
      sequences.each do |seq|
        final_seq_list.concat seq
      end

      #disrupt the sequences by inserting a duplicate
      final_seq_list.push(final_seq_list[final_seq_list.length - 1])

      result = final_seq_list.detect { |e| final_seq_list.rindex(e) != final_seq_list.index(e) }
      expect(result).to_not eq(nil)
    end
  end

end