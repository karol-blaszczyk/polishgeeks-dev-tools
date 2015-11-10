require 'spec_helper'

RSpec.describe PolishGeeks::DevTools::Commands::Base do
  subject { described_class.new }

  describe '#execute' do
    let(:error) { PolishGeeks::DevTools::Errors::NotImplementedError }
    it { expect { subject.execute }. to raise_error(error) }
  end

  describe '#valid?' do
    let(:error) { PolishGeeks::DevTools::Errors::NotImplementedError }
    it { expect { subject.valid? }. to raise_error(error) }
  end

  describe '#error_message' do
    let(:output) { rand.to_s }

    before do
      subject.instance_variable_set('@output', output)
    end

    it 'by default should equal raw output' do
      expect(subject.error_message).to eq output
    end
  end

  describe '#ensure_executable!' do
    context 'when there are validators' do
      let(:validator_class) { PolishGeeks::DevTools::Validators::Base }

      before do
        expect(described_class)
          .to receive(:validators)
          .and_return([validator_class])

        expect_any_instance_of(validator_class)
          .to receive(:valid?)
          .and_return(true)
      end

      it { expect { subject.ensure_executable! }.not_to raise_error }
    end

    context 'when we dont require any validators' do
      before do
        expect(described_class)
          .to receive(:validators)
          .and_return([])
      end

      it { expect { subject.ensure_executable! }.not_to raise_error }
    end
  end
end