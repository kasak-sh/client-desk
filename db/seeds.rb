# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding database..."

# Create admin user (no account - system admin)
admin = User.find_or_create_by!(email: 'admin@clientdesk.com') do |u|
  u.name = 'Admin User'
  u.password = 'admin123'
  u.password_confirmation = 'admin123'
  u.role = 'admin'
  u.account = nil
end
puts "Created admin user: #{admin.email}"

# Create business accounts
account1 = Account.find_or_create_by!(name: 'Acme Corporation') do |a|
  a.status = 'active'
end
puts "Created account: #{account1.name} (slug: #{account1.slug})"

account2 = Account.find_or_create_by!(name: 'Tech Startup Inc') do |a|
  a.status = 'active'
end
puts "Created account: #{account2.name} (slug: #{account2.slug})"

# Create regular users for account 1
user1 = User.find_or_create_by!(email: 'john@acme.com') do |u|
  u.name = 'John Smith'
  u.password = 'password123'
  u.password_confirmation = 'password123'
  u.role = 'user'
  u.account = account1
end
puts "Created user: #{user1.email}"

user2 = User.find_or_create_by!(email: 'sarah@acme.com') do |u|
  u.name = 'Sarah Johnson'
  u.password = 'password123'
  u.password_confirmation = 'password123'
  u.role = 'user'
  u.account = account1
end
puts "Created user: #{user2.email}"

# Create user for account 2
user3 = User.find_or_create_by!(email: 'mike@techstartup.com') do |u|
  u.name = 'Mike Davis'
  u.password = 'password123'
  u.password_confirmation = 'password123'
  u.role = 'user'
  u.account = account2
end
puts "Created user: #{user3.email}"

# Create sample clients for account 1
clients_data = [
  { name: 'John Doe', email: 'john@example.com', phone: '555-0100', company: 'Widget Corp', notes: 'VIP client' },
  { name: 'Jane Smith', email: 'jane@example.com', phone: '555-0101', company: 'Tech Solutions', notes: 'Prefers morning meetings' },
  { name: 'Bob Johnson', email: 'bob@example.com', phone: '555-0102', company: 'Marketing Plus', notes: 'New client' },
  { name: 'Alice Williams', email: 'alice@example.com', phone: '555-0103', company: 'Design Studio', notes: 'Long-term client' },
  { name: 'Charlie Brown', email: 'charlie@example.com', phone: '555-0104', company: 'Consulting Group', notes: 'Monthly retainer' }
]

clients = clients_data.map do |client_data|
  client = account1.clients.find_or_create_by!(email: client_data[:email]) do |c|
    c.name = client_data[:name]
    c.phone = client_data[:phone]
    c.company = client_data[:company]
    c.notes = client_data[:notes]
    c.user = user1
  end
  puts "Created client: #{client.name}"
  client
end

# Create sample bookings for account 1
bookings_data = [
  { title: 'Initial Consultation', description: 'First meeting to discuss project requirements', scheduled_at: 2.days.from_now, duration_minutes: 60, status: 'pending' },
  { title: 'Project Review', description: 'Review current project progress', scheduled_at: 4.days.from_now, duration_minutes: 90, status: 'confirmed' },
  { title: 'Strategy Session', description: 'Quarterly strategy planning', scheduled_at: 1.day.from_now, duration_minutes: 120, status: 'confirmed' },
  { title: 'Follow-up Meeting', description: 'Follow up on action items', scheduled_at: 6.days.from_now, duration_minutes: 30, status: 'pending' },
  { title: 'Demo Presentation', description: 'Product demo and Q&A', scheduled_at: 3.days.from_now, duration_minutes: 45, status: 'confirmed' }
]

bookings_data.each_with_index do |booking_data, index|
  booking = account1.bookings.create!(
    title: booking_data[:title],
    description: booking_data[:description],
    scheduled_at: booking_data[:scheduled_at],
    duration_minutes: booking_data[:duration_minutes],
    status: booking_data[:status],
    client: clients[index],
    user: user1
  )
  puts "Created booking: #{booking.title}"
end

# Create a few clients for account 2
client_account2 = account2.clients.find_or_create_by!(email: 'startup@client.com') do |c|
  c.name = 'Startup Client'
  c.phone = '555-0200'
  c.company = 'Innovation Labs'
  c.notes = 'Potential partner'
  c.user = user3
end
puts "Created client: #{client_account2.name}"

puts "\n" + "=" * 70
puts "Seeding complete!"
puts "=" * 70
puts "\nAdmin Login:"
puts "  URL: http://localhost:3000/admin/login"
puts "  Email: admin@clientdesk.com"
puts "  Password: admin123"
puts "\nAccount Logins:"
puts "\n  Acme Corporation:"
puts "    URL: http://localhost:3000/#{account1.slug}/login"
puts "    Email: john@acme.com"
puts "    Password: password123"
puts "\n  Tech Startup Inc:"
puts "    URL: http://localhost:3000/#{account2.slug}/login"
puts "    Email: mike@techstartup.com"
puts "    Password: password123"
puts "\nNote: Each account has its own branded login URL using their slug."
puts "=" * 70
