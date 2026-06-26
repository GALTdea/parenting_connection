require "rails_helper"

RSpec.describe "Public experience", type: :request do
  describe "GET /" do
    it "renders a product-aligned landing page without starter template copy" do
      get root_url

      expect(response).to be_successful
      expect(response.body).to include("Parenting Connection")
      expect(response.body).to include("Preserve the conversations that reveal who your child is becoming.")
      expect(response.body).to include("Start a private archive")
      expect(response.body).not_to include("My Rails Starter")
      expect(response.body).not_to include("Sample landing page")
      expect(response.body).not_to include("Example pricing")
    end
  end

  describe "GET /users/sign_in" do
    it "renders product auth branding without starter copy" do
      get new_user_session_url

      expect(response).to be_successful
      expect(response.body).to include("Parenting Connection")
      expect(response.body).to include("Welcome back")
      expect(response.body).to include("A private place for the conversations you want to remember.")
      expect(response.body).not_to include("My Rails Starter")
      expect(response.body).not_to include("Login to your account")
    end
  end

  describe "GET /users/sign_up" do
    it "renders private archive copy without collecting a parent name" do
      get new_user_registration_url

      expect(response).to be_successful
      expect(response.body).to include("Create your private archive")
      expect(response.body).not_to include("My Rails Starter")
      expect(response.body).not_to include("Create new account")
      expect(response.body).not_to include("First name")
      expect(response.body).not_to include("Last name")
    end
  end
end
