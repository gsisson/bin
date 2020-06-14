#!/usr/bin/env ruby

ACCOUNTS={
 'ACCOUNT_ID_HERE' => 'account-alias',
}

env='dev'

runtime='ruby2.5'
LAMBDA_FN_NAME=File.basename(ENV['PWD'])
code_file='lambda_fn.rb'
zip_file="#{code_file}.zip"
entry_method='lambda_handler'
owner_tag=ENV['USER']

def usage(msg = nil)
  STDERR.puts msg if msg
  STDERR.puts "usage: #{File.basename(__FILE__)} -c|-u [--profile] [--region]"
  STDERR.puts "  -c:        create (and deploy) a new lambda function"
  STDERR.puts "  -u:        update the existing lambda function"
  STDERR.puts "  --profile: AWS profile to use"
  STDERR.puts "  --region:  AWS region to use"
  STDERR.puts ""
  STDERR.puts "notes: This script operates on the files in the current directory."
  STDERR.puts "       This script will assume the lambda fn name will be the"
  STDERR.puts "       same as the directory name (which is '#{LAMBDA_FN_NAME}')"
  abort
end

abort "ERROR: code file '#{code_file}' not found in this directory!" unless File.exist? code_file

if File.open(code_file).grep(/def  *#{entry_method} *\(/).size == 0
  abort "ERROR: Method '#{entry_method}' not found in file #{code_file}!"
end

update=false
create=false
while ARGV.size > 0 do
  case ARGV[0]
    when '-c'
      create=true
    when '-u'
      update=true
    when '--profile'
      usage "ERROR --profile needs an argument!" if ARGV[1].nil?
      profile="--profile #{ARGV[1]}"; ARGV.shift
    when '--region'
      usage "ERROR --region needs an argument!" if ARGV[1].nil?
      region="--region #{ARGV[1]}"; ARGV.shift
    else
      usage "ERROR: invalid option: '#{ARGV[0]}'"
  end
  ARGV.shift
end

if ! ( update ^ create )
  usage "ERROR: must specify -c or -u"
end
  
def show_profile_region_account(profile, region, account)
  puts "aws profile:"
  if profile
    puts "  #{profile}"
  else
    if ENV['AWS_PROFILE']
      puts "  AWS_PROFILE:#{ENV['AWS_PROFILE']}"
    else
      puts "  (not specified - default will be used)"
    end
  end
  puts "aws region:"
  if region
    puts "  #{region}"
  else
    if ENV['AWS_REGION']
      puts "  AWS_REGION:#{ENV['AWS_REGION']}"
    else
      the_region=`aws configure get region #{profile}`
      if the_region.size != 0
        puts "  #{the_region}"
      else
        puts "  (not specified)"
      end
    end
  end
  puts "account id:"
  puts "  #{account}"
end

def get_config_value_from_file(pattern, code_file)
  matches=File.open(code_file).grep(/# *#{pattern}: /i)
  if matches[0]
    return matches[0].sub(/.*# *#{pattern}: */,'').chomp
  end
  abort "\n\nERROR: pattern '# #{pattern}:' not found in file '#{code_file}'"
end

aws_account=`aws sts get-caller-identity #{profile} | jq .Account | sed -e 's:\"::g'`.chomp
show_profile_region_account(profile, region, aws_account)

puts 'Obtaining lambda config options from source file...'
config_items = ['Description','Timeout','IAM_Role','Tag_Application']
config = {}
config_items.each do |config_item|
  config_value=get_config_value_from_file(config_item, code_file)
  config[config_item] = config_value
end

config['IAM_Role']=config['IAM_Role'].sub('ENVIRONMENT',env)
config.each do |k, v|
  puts "  option:  #{k}"
  puts "    value: #{v}"
end

full_role="arn:aws:iam::#{aws_account}:role/#{config['IAM_Role']}"
available_roles=`aws iam list-roles #{profile}`.split("\n")
matches=available_roles.select do |line|
  /#{full_role}/.match?(line)
end
if matches.size != 1
  STDERR.puts "  ERROR: non-existant iam role!"
  STDERR.puts
  STDERR.puts "    Role '#{config['IAM_Role']}' NOT found! (in AWS account #{aws_account} (#{ACCOUNTS[aws_account]}))"
  STDERR.puts
  STDERR.puts "    Here are the roles (that start with 'prefix-') in that account:"
  matches=available_roles.select { |line| %r{role/prefix-}.match?(line) }
  if matches.size == 0
    STDERR.puts "      !! No roles found in account that start with 'prefix-' !!"
    abort
  end
  matches.each do |line|
    # sed -e 's:\",$::' -e 's:.*/::' -e 's:^:      :'
    # "Arn": "arn:aws:iam::910463056475:role/prefix-dev-iam-role-ops-bastion",
    # "Arn": "arn:aws:iam::910463056475:role/prefix-dev-iam-role-ops-dlm",
    # "Arn": "arn:aws:iam::910463056475:role/prefix-dev-iam-role-ops-lambda",
    STDERR.puts "      #{line.sub(/",.*/,'').sub(%r{.*\/},'')}"
  end
end

def run_cmd(cmd)
  puts "+ #{cmd}"
  system(cmd)
end

puts
puts "Cleaning up temporary files..."
run_cmd("rm -rf #{zip_file} .bundle vendor")
puts
puts "Preparing .zip deployment file..."
if File.exist?('Gemfile')
  puts ""
  puts "Gemfile found... running 'bundle' to create vendor/ and .bundle files..."
  puts ""
  run_cmd('bundle install')
  run_cmd('bundle install --deployment')
end
puts
puts "Creating zip file: #{zip_file}..."
run_cmd("zip -X -r #{zip_file} .")

if create
  puts "Creating and deploying a new lambda function..."
  run_cmd("aws lambda create-function #{profile} #{region} \
      --description '#{config['Description']}' \
      --timeout '#{config['Timeout']}' \
      --function-name '#{LAMBDA_FN_NAME}' \
      --runtime '#{runtime}' \
      --handler '#{File.basename(code_file,'.*')}.#{entry_method}' \
      --no-publish \
      --role '#{full_role}' \
      --zip-file 'fileb://#{zip_file}' \
      --tags '\
Environment=#{env.capitalize},\
Application=#{config['Tag_Application']},\
Owner=#{owner_tag},\
Name=#{LAMBDA_FN_NAME}'")
end
