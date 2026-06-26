require 'rails_helper'

RSpec.describe "/child_profiles/:child_profile_id/memory_responses", type: :request do
  let(:user) { create(:user) }
  let(:child_profile) { create(:child_profile, user:) }
  let(:daily_question) { create(:daily_question, prompt: "What made you smile today?") }
  let(:audio_upload) do
    Rack::Test::UploadedFile.new(
      Rails.root.join("spec/fixtures/files/sample_audio.webm"),
      "audio/webm"
    )
  end

  before { sign_in user }

  describe "GET /" do
    it "renders the selected child's private memory archive" do
      create(:memory_response,
        child_profile: child_profile,
        daily_question: daily_question,
        response_text: "We made pancakes and I flipped one.",
        answered_on: Date.new(2026, 6, 24))

      get child_profile_memory_responses_url(child_profile)

      expect(response).to be_successful
      expect(response.body).to include("#{child_profile.name}'s saved responses")
      expect(response.body).to include("June 2026")
      expect(response.body).to include("What made you smile today?")
      expect(response.body).to include("We made pancakes and I flipped one.")
    end

    it "renders a gentle empty state with capture navigation" do
      get child_profile_memory_responses_url(child_profile)

      expect(response).to be_successful
      expect(response.body).to include("This archive will grow one conversation at a time")
      expect(response.body).to include("Capture the first memory")
    end

    it "orders responses by answered date and created time" do
      older_question = create(:daily_question, prompt: "What felt special in May?")
      older_response = create(:memory_response,
        child_profile: child_profile,
        daily_question: older_question,
        response_text: "The garden had tiny tomatoes.",
        answered_on: Date.new(2026, 5, 30))
      earlier_created_response = create(:memory_response,
        child_profile: child_profile,
        daily_question: daily_question,
        response_text: "We built a couch fort.",
        answered_on: Date.new(2026, 6, 24),
        created_at: Time.zone.local(2026, 6, 24, 9, 0, 0))
      later_created_response = create(:memory_response,
        child_profile: child_profile,
        daily_question: create(:daily_question, prompt: "What made today cozy?"),
        response_text: "We read under the blanket.",
        answered_on: Date.new(2026, 6, 24),
        created_at: Time.zone.local(2026, 6, 24, 10, 0, 0))

      get child_profile_memory_responses_url(child_profile)

      body = response.body
      expect(body.index(later_created_response.response_text)).to be < body.index(earlier_created_response.response_text)
      expect(body.index(earlier_created_response.response_text)).to be < body.index(older_response.response_text)
    end

    it "includes responses for the selected child only" do
      other_child_profile = create(:child_profile, user: user, name: "Riley")
      create(:memory_response,
        child_profile: child_profile,
        daily_question: daily_question,
        response_text: "This belongs in Avery's archive.")
      create(:memory_response,
        child_profile: other_child_profile,
        response_text: "This belongs in Riley's archive.")

      get child_profile_memory_responses_url(child_profile)

      expect(response.body).to include("This belongs in Avery&#39;s archive.")
      expect(response.body).not_to include("This belongs in Riley&#39;s archive.")
    end

    it "does not render another user's child archive" do
      other_child_profile = create(:child_profile)

      get child_profile_memory_responses_url(other_child_profile)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /:id" do
    it "renders a memory response for the selected child" do
      memory_response = create(:memory_response,
        child_profile: child_profile,
        daily_question: daily_question,
        response_text: "We made pancakes and I flipped one.",
        answered_on: Date.new(2026, 6, 25))

      get child_profile_memory_response_url(child_profile, memory_response)

      expect(response).to be_successful
      expect(response.body).to include("What made you smile today?")
      expect(response.body).to include("We made pancakes and I flipped one.")
      expect(response.body).to include("June 25, 2026")
    end

    it "renders private playback for a memory with voice" do
      memory_response = create(:memory_response,
        child_profile: child_profile,
        daily_question: daily_question,
        response_text: "Listen to this moment.")
      memory_response.voice_recording.attach(audio_upload)

      get child_profile_memory_response_url(child_profile, memory_response)

      expect(response).to be_successful
      expect(response.body).to include("Voice recording saved with this memory")
      expect(response.body).to include(voice_recording_child_profile_memory_response_path(child_profile, memory_response))
      expect(response.body).not_to include("/rails/active_storage")
    end

    it "does not render another user's memory response" do
      other_child_profile = create(:child_profile)
      memory_response = create(:memory_response, child_profile: other_child_profile)

      get child_profile_memory_response_url(other_child_profile, memory_response)

      expect(response).to have_http_status(:not_found)
    end

    it "does not access a response through the wrong child profile" do
      other_child_profile = create(:child_profile, user: user, name: "Riley")
      memory_response = create(:memory_response, child_profile: other_child_profile)

      get child_profile_memory_response_url(child_profile, memory_response)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /:id/voice_recording" do
    it "serves the voice recording for the authorized parent" do
      memory_response = create(:memory_response, child_profile: child_profile)
      memory_response.voice_recording.attach(audio_upload)

      get voice_recording_child_profile_memory_response_url(child_profile, memory_response)

      expect(response).to be_successful
      expect(response.media_type).to eq("audio/webm")
      expect(response.body).to eq("sample audio fixture\n")
      expect(response.headers["Cache-Control"]).to include("no-store")
    end

    it "does not serve another parent's voice recording" do
      other_child_profile = create(:child_profile)
      memory_response = create(:memory_response, child_profile: other_child_profile)
      memory_response.voice_recording.attach(audio_upload)

      get voice_recording_child_profile_memory_response_url(other_child_profile, memory_response)

      expect(response).to have_http_status(:not_found)
    end

    it "does not serve a recording through the wrong child profile" do
      other_child_profile = create(:child_profile, user: user, name: "Riley")
      memory_response = create(:memory_response, child_profile: other_child_profile)
      memory_response.voice_recording.attach(audio_upload)

      get voice_recording_child_profile_memory_response_url(child_profile, memory_response)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /new" do
    it "renders the response form for a child profile owned by the signed-in user" do
      daily_question

      get new_child_profile_memory_response_url(child_profile)

      expect(response).to be_successful
      expect(response.body).to include("Capture a response for #{child_profile.name}")
      expect(response.body).to include("What made you smile today?")
      expect(response.body).to include("Record a voice memory")
      expect(response.body).to include("Audio file")
    end

    it "does not render the form for another user's child profile" do
      other_child_profile = create(:child_profile)

      get new_child_profile_memory_response_url(other_child_profile)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /" do
    it "creates a response for a child profile owned by the signed-in user" do
      expect do
        post child_profile_memory_responses_url(child_profile), params: {
          memory_response: {
            daily_question_id: daily_question.id,
            response_text: "We made pancakes and I flipped one.",
            answered_on: "2026-06-25"
          }
        }
      end.to change(child_profile.memory_responses, :count).by(1)

      expect(response).to redirect_to(child_profile_url(child_profile))
      expect(flash[:notice]).to eq("Saved to #{child_profile.name}'s memory archive. Come back tomorrow for another question.")
      expect(child_profile.memory_responses.last.response_text).to eq("We made pancakes and I flipped one.")
    end

    it "creates an audio-only response for a child profile owned by the signed-in user" do
      expect do
        post child_profile_memory_responses_url(child_profile), params: {
          memory_response: {
            daily_question_id: daily_question.id,
            response_text: "",
            answered_on: "2026-06-25",
            voice_recording: audio_upload,
            voice_recording_duration_seconds: "12"
          }
        }
      end.to change(child_profile.memory_responses, :count).by(1)

      memory_response = child_profile.memory_responses.last
      expect(response).to redirect_to(child_profile_url(child_profile))
      expect(memory_response.response_text).to eq("")
      expect(memory_response.voice_recording).to be_attached
    end

    it "renders validation errors without losing the entered response" do
      daily_question

      expect do
        post child_profile_memory_responses_url(child_profile), params: {
          memory_response: {
            daily_question_id: "",
            response_text: "I want this text to stay visible.",
            answered_on: ""
          }
        }
      end.not_to change(MemoryResponse, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Please check the response.")
      expect(response.body).to include("I want this text to stay visible.")
    end

    it "rejects an invalid audio upload with a clear error" do
      invalid_upload = Rack::Test::UploadedFile.new(
        Rails.root.join("spec/fixtures/files/sample_audio.webm"),
        "text/plain"
      )

      expect do
        post child_profile_memory_responses_url(child_profile), params: {
          memory_response: {
            daily_question_id: daily_question.id,
            response_text: "",
            answered_on: "2026-06-25",
            voice_recording: invalid_upload
          }
        }
      end.not_to change(MemoryResponse, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Voice recording must be an audio file")
    end

    it "does not create a response for another user's child profile" do
      other_child_profile = create(:child_profile)

      expect do
        post child_profile_memory_responses_url(other_child_profile), params: {
          memory_response: {
            daily_question_id: daily_question.id,
            response_text: "This should not be saved.",
            answered_on: "2026-06-25"
          }
        }
      end.not_to change(MemoryResponse, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
