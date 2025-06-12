#!/usr/bin/env ruby

# Script to generate Fastlane session for 2FA bypass in CI/CD
# This script helps create a FASTLANE_SESSION token that can be used in GitHub Actions

require 'spaceship'

puts "🔐 Fastlane Session Generator for CI/CD"
puts "======================================="
puts ""
puts "This script will help you generate a FASTLANE_SESSION token"
puts "that can be used in GitHub Actions to bypass 2FA."
puts ""

# Get credentials
print "Enter your Apple ID (senthilkumar.m@nexware-global.com): "
apple_id = gets.chomp
apple_id = "senthilkumar.m@nexware-global.com" if apple_id.empty?

print "Enter your Apple Developer password: "
password = gets.chomp

puts ""
puts "🔑 Attempting to authenticate with Apple Developer Portal..."

begin
  # Authenticate with Apple Developer Portal
  Spaceship::Portal.login(apple_id, password)
  
  puts "✅ Successfully authenticated!"
  puts ""
  
  # Get the session token
  session_token = Spaceship::Portal.client.instance_variable_get(:@current_team_id)
  
  if session_token
    puts "🎉 Fastlane session generated successfully!"
    puts ""
    puts "Add this to your GitHub Secrets:"
    puts "================================"
    puts "Name: FASTLANE_SESSION"
    puts "Value: #{Spaceship::Portal.client.store_session}"
    puts ""
    puts "⚠️  Important: This session token will expire after some time."
    puts "   You may need to regenerate it periodically."
    puts ""
  else
    puts "❌ Failed to generate session token"
  end
  
rescue => e
  puts "❌ Authentication failed: #{e.message}"
  puts ""
  puts "💡 Troubleshooting:"
  puts "   1. Make sure your Apple ID and password are correct"
  puts "   2. Check if 2FA is enabled on your account"
  puts "   3. Try running this script locally first"
  puts ""
end

puts "📚 For more information about Fastlane sessions:"
puts "   https://github.com/fastlane/fastlane/tree/master/spaceship#2-step-verification"
