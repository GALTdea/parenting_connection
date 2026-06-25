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

      get child_profile_url(child_profile)

      expect(response).to be_successful
      expect(response.body).to include(child_profile.name)
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

    it "does not remove another user's child profile" do
      child_profile = create(:child_profile)

      expect do
        delete child_profile_url(child_profile)
      end.not_to change(ChildProfile, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
