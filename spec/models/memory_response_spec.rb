require 'rails_helper'

RSpec.describe MemoryResponse, type: :model do
  describe 'associations' do
    it 'belongs to a child profile' do
      expect(MemoryResponse.reflect_on_association(:child_profile).macro).to eq(:belongs_to)
    end

    it 'belongs to a daily question' do
      expect(MemoryResponse.reflect_on_association(:daily_question).macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'requires response text' do
      memory_response = build(:memory_response, response_text: nil)

      expect(memory_response).not_to be_valid
      expect(memory_response.errors[:response_text]).to include("can't be blank")
    end

    it 'requires an answered date' do
      memory_response = build(:memory_response, answered_on: nil)

      expect(memory_response).not_to be_valid
      expect(memory_response.errors[:answered_on]).to include("can't be blank")
    end

    it 'requires an active daily question' do
      daily_question = build(:daily_question, active: false)
      memory_response = build(:memory_response, daily_question: daily_question)

      expect(memory_response).not_to be_valid
      expect(memory_response.errors[:daily_question]).to include("must be active")
    end
  end
end
