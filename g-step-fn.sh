if [ $# != 1 ]; then
  echo "usage: $(basename $0) ACCOUNT_ID|all"
  exit 1
fi

if [ $1 = "-" ]; then
  while read acct; do
    acct="${acct%,}"
    acct="${acct%\"}"
    acct="${acct# *}"
    acct="${acct#\"}"
    if [ "$accts" != "" ]; then
      accts="${accts},"
    fi
    accts="$accts \"$acct\""
  done
else
  if [ $1 = "all" ]; then
    acct="all"
  else
    acct="$1"
    acct="${acct%,}"
    acct="${acct%\"}"
    acct="${acct# *}"
    acct="${acct#\"}"
    accts="\"$acct\""
  fi
fi

if [ "$acct" = all ]; then
  cat <<-EOF
	{
	  "include": [
	    {
	      "type": "all"
	    }
	  ]
	}
	EOF
else
  cat <<-EOF
	{
	  "include": [
	    {
	      "type": "accounts",
	      "target_value": [
	EOF
  for acct in $accts; do
echo "	        ${acct}"
  done
  cat <<-EOF
	      ]
	    }
	  ]
	}
	EOF
fi
