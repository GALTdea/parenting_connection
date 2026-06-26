require 'rails_helper'

RSpec.describe "/child_profiles", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /child_profiles" do
    it "renders the signed-in user's child profiles" do
      create(:child_profile, user: user, name: "Avery")
      create(:child_profile, name: "Jordan")

      get child_profiles_url

      expect(response).to be_successful
      expect(response.body).to include("Avery")
      expect(response.body).not_to include("Jordan")
    end

    it "keeps starter account navigation out of the parent-facing shell" do
      get child_profiles_url

      expect(response).to be_successful
      expect(response.body).to include("Children")
      expect(response.body).not_to include("Spaces")
      expect(response.body).not_to include("Profile")
    end

    context "when the parent account has no display name" do
      let(:user) { create(:user, first_name: nil, last_name: nil) }

      it "falls back to parent account copy instead of a blank menu identity" do
        get child_profiles_url

        expect(response).to be_successful
        expect(response.body).to include("Parent account")
        expect(response.body).to include(user.email)
      end
    end
  end

  describe "GET /child_profiles/new" do
    it "renders a successful response" do
      get new_child_profile_url

      expect(response).to be_successful
    end
  end

  describe "POST /child_profiles" do
    it "creates a child profile owned by the signed-in user" do
      expect do
        post child_profiles_url, params: {
          child_profile: {
            name: "Avery",
            birthday: "2018-05-12"
          }
        }
      end.to change(user.child_profiles, :count).by(1)

      expect(response).to redirect_to(child_profile_url(ChildProfile.last))
      expect(flash[:notice]).to eq("Avery's memory archive is ready.")
      expect(ChildProfile.last.user).to eq(user)
    end

    it "renders validation errors without creating a child profile" do
      expect do
        post child_profiles_url, params: {
          child_profile: {
            name: "",
            birthday: ""
          }
        }
      end.not_to change(ChildProfile, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Please check the profile details.")
    end
  end

  describe "GET /child_profiles/:id" do
    it "renders a child profile owned by the signed-in user" do
      child_profile = create(:child_profile, user: user)
      daily_question = create(:daily_question, prompt: "What made you smile today?")
      create(:memory_response,
        child_profile: child_profile,
        daily_question: daily_question,
        response_text: "We read the same book twice.")

      get child_profile_url(child_profile)

      expect(response).to be_successful
      expect(response.body).to include(child_profile.name)
      expect(response.body).to include("Today's conversation")
      expect(response.body).to include("Today's question")
      expect(response.body).to include("Answer today&#39;s question")
      selection = child_profile.daily_question_selections.find_by!(selected_on: Date.current)
      expect(response.body).to include(new_child_profile_memory_response_path(child_profile, daily_question_selection_id: selection.id))
      expect(response.body).to include("What made you smile today?")
      expect(response.body).to include("We read the same book twice.")
    end

    it "prioritizes the ritual before recent memories and profile management" do
      child_profile = create(:child_profile, user: user, name: "Avery")
      daily_question = create(:daily_question, prompt: "What made you smile today?")
      create(:memory_response,
        child_profile: child_profile,
        daily_question: daily_question,
        response_text: "We read the same book twice.")

      get child_profile_url(child_profile)

      body = response.body
      expect(body.index("Today's conversation")).to be < body.index("Recent memories")
      expect(body.index("Recent memories")).to be < body.index("Profile details")
      expect(body.index("Answer today&#39;s question")).to be < body.index("Edit profile")
      expect(body.index("Answer today&#39;s question")).to be < body.index("Remove profile")
    end

    it "keeps the empty memory state focused on today's question" do
      child_profile = create(:child_profile, user: user)
      create(:daily_question, prompt: "What made you smile today?")

      get child_profile_url(child_profile)

      expect(response).to be_successful
      expect(response.body).to include("This archive will grow one conversation at a time")
      expect(response.body).to include("Answer today's question and save the words you want to remember.")
    end

    it "keeps today's question stable for the child" do
      child_profile = create(:child_profile, user: user)
      create(:daily_question, prompt: "What made you smile today?")
      create(:daily_question, prompt: "What felt cozy today?")

      get child_profile_url(child_profile)
      first_selection = child_profile.daily_question_selections.find_by!(selected_on: Date.current)

      get child_profile_url(child_profile)

      expect(child_profile.daily_question_selections.where(selected_on: Date.current).count).to eq(1)
      expect(response.body).to include(first_selection.presented_prompt)
      expect(response.body).to include(new_child_profile_memory_response_path(child_profile, daily_question_selection_id: first_selection.id))
    end

    it "renders today's question from the selected presented prompt" do
      child_profile = create(:child_profile, user: user)
      daily_question = create(:daily_question, prompt: "What made you smile today?")
      selection = create(:daily_question_selection,
        child_profile: child_profile,
        daily_question: daily_question,
        selected_on: Date.current,
        presented_prompt: "You once talked about a treehouse. What room would it need?")

      get child_profile_url(child_profile)

      expect(response).to be_successful
      expect(response.body).to include("You once talked about a treehouse. What room would it need?")
      expect(response.body).not_to include("What made you smile today?")
      expect(response.body).to include(new_child_profile_memory_response_path(child_profile, daily_question_selection_id: selection.id))
    end

    it "falls back to the daily question prompt when the selection prompt is blank" do
      child_profile = create(:child_profile, user: user)
      daily_question = create(:daily_question, prompt: "What made you smile today?")
      create(:daily_question_selection,
        child_profile: child_profile,
        daily_question: daily_question,
        selected_on: Date.current).update_column(:presented_prompt, "")

      get child_profile_url(child_profile)

      expect(response).to be_successful
      expect(response.body).to include("What made you smile today?")
    end

    it "shows a same-day selected question after it is retired" do
      child_profile = create(:child_profile, user: user)
      retired_question = create(:daily_question, prompt: "What felt cozy today?")
      create(:daily_question_selection,
        child_profile: child_profile,
        daily_question: retired_question,
        selected_on: Date.current)
      retired_question.update!(active: false)

      get child_profile_url(child_profile)

      expect(response).to be_successful
      expect(response.body).to include("What felt cozy today?")
      selection = child_profile.daily_question_selections.find_by!(selected_on: Date.current)
      expect(response.body).to include(new_child_profile_memory_response_path(child_profile, daily_question_selection_id: selection.id))
    end

    it "does not render another user's child profile" do
      child_profile = create(:child_profile)

      get child_profile_url(child_profile)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /child_profiles/:id/edit" do
    it "renders a successful response" do
      child_profile = create(:child_profile, user: user)

      get edit_child_profile_url(child_profile)

      expect(response).to be_successful
    end

    it "does not render another user's edit form" do
      child_profile = create(:child_profile)

      get edit_child_profile_url(child_profile)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /child_profiles/:id" do
    it "updates a child profile owned by the signed-in user" do
      child_profile = create(:child_profile, user: user, name: "Avery")

      patch child_profile_url(child_profile), params: {
        child_profile: {
          name: "Aves",
          birthday: child_profile.birthday
        }
      }

      expect(response).to redirect_to(child_profile_url(child_profile))
      expect(child_profile.reload.name).to eq("Aves")
    end

    it "does not update another user's child profile" do
      child_profile = create(:child_profile, name: "Avery")

      patch child_profile_url(child_profile), params: {
        child_profile: {
          name: "Aves",
          birthday: child_profile.birthday
        }
      }

      expect(response).to have_http_status(:not_found)
      expect(child_profile.reload.name).to eq("Avery")
    end
  end

  describe "DELETE /child_profiles/:id" do
    it "removes a child profile owned by the signed-in user" do
      child_profile = create(:child_profile, user: user)

      expect do
        delete child_profile_url(child_profile)
      end.to change(user.child_profiles, :count).by(-1)

      expect(response).to redirect_to(child_profiles_url)
    end

    it "removes the child profile's memory responses" do
      child_profile = create(:child_profile, user: user)
      create(:memory_response, child_profile: child_profile)

      expect do
        delete child_profile_url(child_profile)
      end.to change(MemoryResponse, :count).by(-1)
    end

    it "does not remove another user's child profile" do
      child_profile = create(:child_profile)

      expect do
        delete child_profile_url(child_profile)
      end.not_to change(ChildProfile, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
