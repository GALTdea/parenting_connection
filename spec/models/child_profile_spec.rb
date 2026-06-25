require 'rails_helper'

RSpec.describe ChildProfile, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      expect(ChildProfile.reflect_on_association(:user).macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'requires a name' do
      child_profile = build(:child_profile, name: nil)

      expect(child_profile).not_to be_valid
      expect(child_profile.errors[:name]).to include("can't be blank")
    end

    it 'requires a birthday' do
      child_profile = build(:child_profile, birthday: nil)

      expect(child_profile).not_to be_valid
      expect(child_profile.errors[:birthday]).to include("can't be blank")
    end

    it 'does not allow a future birthday' do
      child_profile = build(:child_profile, birthday: 1.day.from_now.to_date)

      expect(child_profile).not_to be_valid
      expect(child_profile.errors[:birthday]).to include("can't be in the future")
    end
  end
end
