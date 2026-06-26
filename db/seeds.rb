# db/seeds.rb
# Creates minimal seed data for development.
# Safe to run multiple times (find_or_create_by).

puts "Seeding database..."

# Default admin user
admin = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.first_name = "Admin"
  u.last_name  = "User"
  u.password = "password123"
  u.password_confirmation = "password123"
  u.admin    = true
end
puts "  admin user: #{admin.email}"

# Default regular user
user = User.find_or_create_by!(email: "user@example.com") do |u|
  u.first_name = "Regular"
  u.last_name  = "User"
  u.password = "password123"
  u.password_confirmation = "password123"
  u.admin    = false
end
puts "  regular user: #{user.email}"

daily_questions = [
  { slug: "what-made-you-smile-today", prompt: "What made you smile today?", category: "daily_life", tags: %w[quick], position: 1 },
  { slug: "what-was-the-best-part-of-your-day", prompt: "What was the best part of your day?", category: "daily_life", tags: %w[quick], position: 2 },
  { slug: "what-felt-cozy-today", prompt: "What felt cozy today?", category: "daily_life", tags: %w[bedtime], position: 3 },
  { slug: "what-did-you-notice-outside", prompt: "What did you notice outside today?", category: "daily_life", tags: %w[wonder], position: 4 },
  { slug: "what-was-one-funny-moment", prompt: "What was one funny moment from today?", category: "daily_life", tags: %w[quick], position: 5 },
  { slug: "what-do-you-want-to-tell-me-about-today", prompt: "What do you want to tell me about today?", category: "daily_life", tags: [], position: 6 },
  { slug: "what-made-today-different", prompt: "What made today different from other days?", category: "daily_life", tags: [], position: 7 },
  { slug: "what-was-a-small-good-thing", prompt: "What was a small good thing from today?", category: "daily_life", tags: %w[gratitude], position: 8 },

  { slug: "what-feeling-visited-you-today", prompt: "What feeling visited you today?", category: "feelings", tags: %w[bedtime], position: 9 },
  { slug: "what-helped-you-feel-better", prompt: "What helped you feel better today?", category: "feelings", tags: [], position: 10 },
  { slug: "what-felt-easy-and-what-felt-hard", prompt: "What felt easy today, and what felt hard?", category: "feelings", tags: [], position: 11, min_age_years: 5, age_guidance: "Works best when a child can compare two parts of a day." },
  { slug: "when-did-you-feel-proud", prompt: "When did you feel proud today?", category: "feelings", tags: [], position: 12 },
  { slug: "what-made-you-feel-cared-for", prompt: "What made you feel cared for today?", category: "feelings", tags: %w[gratitude], position: 13 },
  { slug: "what-helped-you-feel-brave", prompt: "What helped you feel brave today?", category: "feelings", tags: [], position: 14 },
  { slug: "what-does-your-heart-want-to-remember", prompt: "What does your heart want to remember about today?", category: "feelings", tags: %w[bedtime], position: 15 },

  { slug: "if-today-were-a-story-title", prompt: "If today were a story, what would the title be?", category: "imagination", tags: %w[story], position: 16, min_age_years: 4 },
  { slug: "what-would-you-build-with-anything", prompt: "If you could build anything tomorrow, what would it be?", category: "imagination", tags: %w[weekend], position: 17 },
  { slug: "what-animal-would-describe-today", prompt: "What animal would describe today?", category: "imagination", tags: %w[quick], position: 18, min_age_years: 4 },
  { slug: "if-your-toy-could-talk", prompt: "If one of your toys could talk, what would it say about today?", category: "imagination", tags: %w[story], position: 19, max_age_years: 8, age_guidance: "Best for younger children who enjoy pretend play." },
  { slug: "what-would-you-invent-for-our-family", prompt: "What would you invent for our family?", category: "imagination", tags: [], position: 20 },
  { slug: "where-should-our-imagination-go", prompt: "Where should our imagination go tonight?", category: "imagination", tags: %w[bedtime], position: 21 },
  { slug: "what-is-something-you-wondered-about-today", prompt: "What is something you wondered about today?", category: "imagination", tags: %w[wonder], position: 22 },

  { slug: "who-made-you-laugh-today", prompt: "Who made you laugh today?", category: "relationships", tags: %w[quick], position: 23 },
  { slug: "what-is-something-kind-someone-did-today", prompt: "What is something kind someone did today?", category: "relationships", tags: %w[gratitude], position: 24 },
  { slug: "how-did-you-help-someone", prompt: "How did you help someone today?", category: "relationships", tags: [], position: 25 },
  { slug: "who-did-you-like-being-near", prompt: "Who did you like being near today?", category: "relationships", tags: [], position: 26 },
  { slug: "what-should-we-do-together-soon", prompt: "What should we do together soon?", category: "relationships", tags: %w[weekend], position: 27 },
  { slug: "what-made-you-feel-connected", prompt: "What made you feel connected to someone today?", category: "relationships", tags: [], position: 28, min_age_years: 6 },
  { slug: "what-thank-you-would-you-give", prompt: "What thank-you would you give someone today?", category: "relationships", tags: %w[gratitude], position: 29 },

  { slug: "what-did-you-try-today", prompt: "What did you try today?", category: "growth", tags: %w[quick], position: 30 },
  { slug: "what-did-you-learn-by-doing", prompt: "What did you learn by doing today?", category: "growth", tags: [], position: 31 },
  { slug: "what-got-a-little-easier", prompt: "What got a little easier today?", category: "growth", tags: [], position: 32 },
  { slug: "what-did-you-keep-working-on", prompt: "What did you keep working on today?", category: "growth", tags: [], position: 33 },
  { slug: "what-would-you-like-to-try-again", prompt: "What would you like to try again?", category: "growth", tags: [], position: 34 },
  { slug: "what-surprised-you-about-yourself", prompt: "What surprised you about yourself today?", category: "growth", tags: [], position: 35, min_age_years: 6 },
  { slug: "what-did-you-figure-out", prompt: "What did you figure out today?", category: "growth", tags: %w[wonder], position: 36 },

  { slug: "what-would-you-like-to-remember-about-this-week", prompt: "What would you like to remember about this week?", category: "memory", tags: %w[weekend], position: 37 },
  { slug: "what-moment-should-we-save", prompt: "What moment from today should we save?", category: "memory", tags: %w[quick], position: 38 },
  { slug: "what-would-future-you-like-to-hear", prompt: "What would future you like to hear about today?", category: "memory", tags: [], position: 39, min_age_years: 6 },
  { slug: "what-detail-should-we-not-forget", prompt: "What detail should we not forget?", category: "memory", tags: [], position: 40 },
  { slug: "what-picture-would-you-save", prompt: "If today were a picture, what would you save in it?", category: "memory", tags: %w[story], position: 41 },
  { slug: "what-sound-would-help-us-remember", prompt: "What sound would help us remember today?", category: "memory", tags: [], position: 42 },
  { slug: "what-would-you-tell-family-about-today", prompt: "What would you tell our family about today?", category: "memory", tags: [], position: 43 },
  { slug: "if-you-could-ask-tomorrow-one-question-what-would-it-be", prompt: "If you could ask tomorrow one question, what would it be?", category: "imagination", tags: %w[wonder], position: 44 }
]

daily_questions.each do |attributes|
  question = DailyQuestion.find_or_initialize_by(slug: attributes.fetch(:slug))
  question.assign_attributes(attributes.merge(active: true))
  question.save!
end
puts "  daily questions: #{DailyQuestion.count}"

# Default space for admin
if Space.respond_to?(:find_or_create_by!)
  space = Space.find_or_create_by!(name: "Default Space") do |s|
    s.status = :active if s.respond_to?(:status=)
  end
  puts "  space: #{space.name}"
end

puts ""
puts "Done! Seed data loaded."
puts ""
puts "Login credentials:"
puts "  Admin — admin@example.com / password123"
puts "  User  — user@example.com / password123"
