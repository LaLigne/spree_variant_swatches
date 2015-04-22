# require 'rails_helper'

RSpec.describe Spree::OptionValue, type: :model do
  describe "swatch" do
    it "can be nil or blank" do
      option_value = build(:option_value)
      expect(option_value.valid?).to eql(true)

      option_value.swatch = ''
      expect(option_value.valid?).to eql(true)
    end

    it "allows valid hex color values" do
      option_value = build(:option_value)

      valid_colors = [
        '#000',
        '#fff',
        '#ff0000',
        '#ffffff',
        '#bada55',
        '#c0ffee'
      ]

      valid_colors.each do |color|
        option_value.swatch = color
        expect(option_value.valid?).to eql(true)
      end
    end

    it "does not allow invalid hex color values" do
      option_value = build(:option_value)
      invalid_colors = [
        # too short
        '#00',
        # too long
        '#fffffff',
        # hex number out of range
        '#g00000',
        'purple',
        # missing hash
        '000000'
      ]

      invalid_colors.each do |color|
        option_value.swatch = color
        expect(option_value.valid?).to eql(false)
      end
    end
  end
end
