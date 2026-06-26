require 'rails_helper'

RSpec.describe MemoryResponse, type: :model do
  describe 'associations' do
    it 'belongs to a child profile' do
      expect(MemoryResponse.reflect_on_association(:child_profile).macro).to eq(:belongs_to)
    end

    it 'belongs to a daily question' do
      expect(MemoryResponse.reflect_on_association(:daily_question).macro).to eq(:belongs_to)
    end

    it 'has one attached voice recording' do
      expect(MemoryResponse.reflect_on_attachment(:voice_recording).macro).to eq(:has_one_attached)
    end
  end

  describe 'validations' do
    it 'requires response text or a voice recording' do
      memory_response = build(:memory_response, response_text: nil)

      expect(memory_response).not_to be_valid
      expect(memory_response.errors[:base]).to include("Add a written response or a voice recording")
    end

    it 'allows audio-only memories' do
      memory_response = build(:memory_response, response_text: nil)
      memory_response.voice_recording.attach(
        io: Rails.root.join("spec/fixtures/files/sample_audio.webm").open,
        filename: "sample_audio.webm",
        content_type: "audio/webm"
      )

      expect(memory_response).to be_valid
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

    it 'rejects non-audio voice recording attachments' do
      memory_response = build(:memory_response)
      memory_response.voice_recording.attach(
        io: StringIO.new("not audio"),
        filename: "notes.txt",
        content_type: "text/plain"
      )

      expect(memory_response).not_to be_valid
      expect(memory_response.errors[:voice_recording]).to include("must be an audio file")
    end

    it 'rejects voice recordings larger than 100 MB' do
      memory_response = build(:memory_response)
      memory_response.voice_recording.attach(
        io: StringIO.new("audio"),
        filename: "large.webm",
        content_type: "audio/webm"
      )
      allow(memory_response.voice_recording).to receive(:byte_size).and_return(101.megabytes)

      expect(memory_response).not_to be_valid
      expect(memory_response.errors[:voice_recording]).to include("must be 100 MB or smaller")
    end

    it 'rejects voice recordings longer than 15 minutes when duration is provided' do
      memory_response = build(:memory_response, voice_recording_duration_seconds: 901)
      memory_response.voice_recording.attach(
        io: StringIO.new("audio"),
        filename: "long.webm",
        content_type: "audio/webm"
      )

      expect(memory_response).not_to be_valid
      expect(memory_response.errors[:voice_recording]).to include("must be 15 minutes or shorter")
    end
  end
end
