"It does the thing." Example

v 0.1

####################################
# 1.) Make server with terraform.
# 
# 2.) Popluate server with ansible.
####################################

####################################################################
##  https://developers.digitalocean.com/documentation/v2/
#
## Set variables for curl command. Add these into the 00_vars.yaml as well
# export TOKEN=<token>
# export CHIKEN=<username>
####################################################################

####################################################################
# Get the ID's to fill in 00_vars.yaml ( may have to install "jq" )
####################################################################
curl -s -X GET -H "Content-Type: application/json" -H "Authorizatiottps://api.digitalocean.com/v2/account/keys" | jq -C . | egrep -A 1 id



