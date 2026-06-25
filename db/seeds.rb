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
  "What made you smile today?",
  "What is something you wondered about today?",
  "What would you like to remember about this week?",
  "What was the best part of your day?",
  "What is something kind someone did today?",
  "If you could ask tomorrow one question, what would it be?"
]

daily_questions.each.with_index(1) do |prompt, position|
  DailyQuestion.find_or_create_by!(prompt:) do |question|
    question.position = position
    question.active = true
  end
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
