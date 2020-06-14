#!/usr/bin/env bash

echo "migrating to .rb script"
exit

env=dev

runtime=ruby2.5
lambda_fn_name="$(basename `pwd`)"
code_file=lambda_fn.rb
zip_file=${code_file}.zip
entry_method=lambda_handler
owner_tag=`whoami`

usage() {
  echo "usage: $(basename $0) -c|-u [--profile] [--region]"
  echo "  -c:        create (and deploy) a new lambda function"
  echo "  -u:        update the existing lambda function"
  echo "  --profile: AWS profile to use"
  echo "  --region:  AWS profile to use"
  echo ""
  echo "notes: This script operates on the files in the current directory."
  echo "       This script will assume the lambda fn name to be the the"
  echo "       directory name (which is '${lambda_fn_name}')"
  exit 1
}

# bash 4
if ((BASH_VERSINFO[0] < 4)); then 
  echo "ERROR: Sorry, you need at least bash-4.0 to run this script." 
  echo "       (MacOS still comes with bash 3, though bash 4 is 10 yrs old, so"
  echo "        it is suggest you upgrade bash on Mac with 'brew install bash')"
  exit 1 
fi

if [ ! -f ${code_file} ]; then
  echo "ERROR: code file '${code_file}' not found in this directory!"
  exit 1
fi

if ! grep "def  *${entry_method} *(" "${code_file}" >/dev/null ; then
  echo "ERROR: Method '${entry_method}' not found in file ${code_file}!"
  exit 1
fi

while [ -n "$1" ]; do
  case "$1" in
    -u)        shift;update=true;;
    -c)        shift;create=true;;
    --profile) shift;profile="--profile $1"; shift;;
    --region)  shift;region="--region $1"; shift;;
    *)         echo "invalid option: '$1'"; usage;;
  esac
done

if [ "${update}${create}" != true ]; then
  usage
fi

echo "aws profile:"
if [ -n "$profile" ]; then
  #echo using profile: $(echo $profile | sed -e 's:--profile ::')
  echo "  $profile"
else
  if [ -n "$AWS_PROFILE" ]; then
    echo "  AWS_PROFILE:$AWS_PROFILE"
  else
    echo "  (not specified - default will be used)"
  fi
fi
aws_account=$(aws sts get-caller-identity $profile | jq .Account | sed -e 's:\"::g')
echo "  (account id: $aws_account)"

echo "aws region:"
if [ -n "$region" ]; then
  #echo using region: $(echo $region | sed -e 's:--region ::')
  echo "  $region"
else
  if [ -n "$AWS_REGION" ]; then
    echo "  AWS_REGION:$AWS_REGION"
  else
    r=$(aws configure get region $profile)
    if [ -n "$r" ]; then
      echo "  $r"
    else
      echo "  (not specified)"
    fi
  fi     
fi
echo

echo "Obtaining lambda config options from source file..."
echo "  description"
description=`cat "$code_file" | grep -i '# *Description: ' | sed -e 's|.*# *Description: *||'`
echo "  timeout"
timeout=`cat "$code_file" | grep -i '# *Timeout: ' | sed -e 's|.*# *Timeout: *||'`
echo "  iam role"
role=`cat "$code_file" | grep -i '# *IAM_Role: ' | sed -e 's|.*# *IAM_Role: *||' -e 's|ENVIRONMENT|'$env'|'`
echo "  application tag"
application_tag=`cat "$code_file" | grep -i '# *Tag_Application: ' | sed -e 's|.*# *Tag_Application: *||'`

#echo
#echo "Verifying iam role exists..."
#aws_account=$(aws sts get-caller-identity $profile | jq .Account | sed -e 's:\"::g')

full_role="arn:aws:iam::${aws_account}:role/$role"
if ! aws iam list-roles $profile | grep "$full_role" > /dev/null; then
  echo
  echo "  ERROR: non-existant iam role!"
  echo
  echo "    Role '${role}' NOT found! (in AWS account $aws_account)"
  echo
  echo "    Here are the roles (that start with 'prefix-') in that account:"
  aws iam list-roles $profile | grep "Arn" | grep 'role/prefix-' \
    | sed -e 's:\",$::' -e 's:.*/::' -e 's:^:      :'
  exit 1
fi

echo
echo "Preparing .zip deployment file..."
if [ -f Gemfile ]; then
  echo "+ bundle install..."
  bundle install
  echo "+ bundle install --deployment..."
  bundle install --deployment
fi
echo "Cleanup temporary files..."
rm -rf $zip_file .bundle vendor
echo "Creating zip file: $zip_file..."
zip -X -r $zip_file .

#echo "Checking if the lambda fn already exists..."
#if aws lambda list-functions $profile $region \
#    | grep '"FunctionName": "'$lambda_fn_name'"'; then
#  echo "  Function exists"
#else
#  echo "  Function does not exist"
#fi

if [ "$create" = true ]; then
  echo "Creating and deploying a new lambda function..."
  if aws lambda create-function $profile $region \
      --description "$description" \
      --timeout "$timeout" \
      --function-name "$lambda_fn_name" \
      --runtime "$runtime" \
      --handler "${code_file%.rb}.$entry_method" \
      --no-publish \
      --role "$full_role" \
      --zip-file "fileb://$zip_file" \
      --tags "\
Environment=${env^},\
Application=${application_tag},\
Owner=${owner_tag},\
Name=${lambda_fn_name}"; then
    echo -e "\n    function creation/deployment OK\n"
  else
    #echo -e "\n    function creation/deployment FAILED!\n"
    exit 1
  fi
fi

if [ "$update" = true ]; then
  echo "Deploying update to existing lambda function..."
  echo
  if aws lambda update-function-code $profile $region \
      --function-name $lambda_fn_name \
      --zip-file fileb://$zip_file; then
    echo -e "\n    function updated OK\n"
    exit
  else
    #echo -e "\n    function update FAILED!\n"
    exit 1
  fi
fi
