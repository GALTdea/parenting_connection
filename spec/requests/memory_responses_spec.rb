require 'rails_helper'

RSpec.describe "/child_profiles/:child_profile_id/memory_responses", type: :request do
  let(:user) { create(:user) }
  let(:child_profile) { create(:child_profile, user:) }
  let(:daily_question) { create(:daily_question, prompt: "What made you smile today?") }

  before { sign_in user }

  describe "GET /new" do
    it "renders the response form for a child profile owned by the signed-in user" do
      daily_question

      get new_child_profile_memory_response_url(child_profile)

      expect(response).to be_successful
      expect(response.body).to include("Capture a response for #{child_profile.name}")
      expect(response.body).to include("What made you smile today?")
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
      expect(child_profile.memory_responses.last.response_text).to eq("We made pancakes and I flipped one.")
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
