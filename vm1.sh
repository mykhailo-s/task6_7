#!/bin/bash

# reverse proxy nginx and backend apache

#VERBOSE=true
#clear

config_file="vm1.config" # config file with initiative network parameters

# check for root
if [ "$UID" -ne 0 ]
   then echo "Error in ($0): Current user is not the root! Please restart this task under the root" >&2; exit 126;
fi

# echo "$(pwd)"

#  config_file ( no matter relative or absolute path is )
dir_of_this_script="$(cd "$(dirname "$0")"; pwd)";
# echo "$dir_of_this_script"

# config_file: is it existing?
if ! [ -f "$dir_of_this_script"/"$config_file" ]; 
   then  echo "Error 1 in ($0): Config file $dir_of_this_script/$config_file is not existing."; exit 1 ;fi


parse_config_file() {
 
# (while read -r line; do if [ -n "$line" ] ; then echo "$line"; declare "$line";  fi;  done ) <"$dir_of_this_script"/"$config_file"

  while IFS="=" read -r key value; do
   if [ -n "$key" -a -n "$value" ]; then
    case "$key" in
      '#'*) ;;
      *)
        eval "$key=\"$value\""  ;;
    esac
   fi
  done < "$dir_of_this_script"/"$config_file"

# echo "*$VLAN*"
 return 0
}


network_config() {
 if [ ${EXT_IP:-STATIC} == "STATIC" ]; then
  echo "ip link set "$EXTERNAL_IF" down"
  echo "ip addr add "$EXT_IP" dev "$IXTERNAL_IF""
  echo "ip link set "$EXTERNAL_IF" up"
 else  
  echo "ip link set "$EXTERNAL_IF" down"
  echo "ip link set "$EXTERNAL_IF" up"
 fi

echo "ip addr add "$INT_IP" dev "$INTERNAL_IF""

echo "ip link add link "$INT_IP" name "$INTERNAL_IF.$VLAN" type vlan id "$VLAN""

return 0
}

nginx_config() {

return 0
}

###############################
### Main body of the script ###
###############################

parse_config_file #  parsing of config_file 

echo "Error in ($0): Script has not been finished by author" >&2; exit 10;

network_config  # setup of networking parameters
nginx_config # setup of nginx paramaters (with certs)

# exit

