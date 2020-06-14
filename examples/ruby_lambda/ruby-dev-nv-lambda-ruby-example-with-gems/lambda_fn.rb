#!/usr/bin/env ruby

# Description: Example Ruby Lambda function (examine tags on instances and volumes)
# Timeout: 10
# IAM_Role: prefix-ENVIRONMENT-iam-role-ops-lambda
# Tag_Application: DevOps

require 'json'
require 'aws-sdk' # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/index.html
require 'fib'

def lambda_handler(event:, context:)
  puts "======================"
  puts "Sample Ruby Lambda app!"
  puts "======================"
  puts "Sample call to uploaded library 'fib':"
  puts "  The largest fibonocci number less than 65 is:"
  puts "    #{65.closest_fibonacci}"
  ec2 = Aws::EC2::Resource.new(region: 'us-east-1')
  puts "----------------------"
  puts "instances tagged as environment 'Dev'"
  ec2.instances({filters: [{name: 'tag:Environment', values: ['Dev']}]}).each do |i|
    puts "  instance id: #{i.id}"
    puts "        state: #{i.state.name}"
  end
  puts "----------------------"
  puts "Volumes and their tags"
  ec2.volumes.each do |vol|
    puts "  volume: #{vol.volume_id}"
    vol.tags.each do |tag|
      puts "    #{tag.key} = #{tag.value}"
    end
  end
  puts "----------------------"
  puts "volumes with no 'Owner' tag:"
  ec2.volumes.select do |vol|
    vol.tags.select { |tag| tag.key == "Owner" }.size == 0
  end.each do |vol|
    puts "  #{vol.volume_id}"
  end
  puts "======================"
  { statusCode: 200, body: JSON.generate('Lambda function completed successfully.') }
end
