#!/bin/bash -

##
# Varialbes
##
DOWNLOAD_FILE="/tmp/tmux_net_speed.download"
UPLOAD_FILE="/tmp/tmux_net_speed.upload"

get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value="$(tmux show-option -gqv "$option")"
	if [[ -z "$option_value" ]]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

set_tmux_option() {
	local option=$1
	local value=$2
	tmux set-option -gq "$option" "$value"
}

get_velocity()
{
    local new_value=$1
    local old_value=$2

    # Consts
    local THOUSAND=1024
    local MILLION=1048576

    local vel=$(( new_value - old_value ))
    local velKB=$(( vel / THOUSAND ))
    local velMB=$(( vel / MILLION ))

    if [[ $velMB != 0 ]] ; then
        displayValue=`echo "scale=2;$vel/$MILLION" | bc`
        echo -n "$displayValue MB/s"
    elif [[ $velKB != 0 ]] ; then
        displayValue=`echo "scale=2;$vel/$THOUSAND" | bc`
        echo -n "$displayValue KB/s"
    else
        echo -n "$vel B/s";
    fi
}

# Reads from value from file. If file does not exist,
# is empty, or not readable, starts back at 0
read_file()
{
   local path="$1"
   local val=0

   if [[ ! -f "$path" ]] ; then
       echo $val
       return
   elif [[ ! -r "$path" ]]; then
       echo $val
       return
   fi

   # Ok, file exists and is readdable. Check contents
   tmp=$(< "$path")
   if [[ "x${tmp}" == "x" ]] ; then
       echo $val
       return
   fi

   # else all good, echo value
   echo $tmp
}

# Update values in file
write_file()
{
   local path="$1"
   local val="$2"

   # TODO Add error checking
   echo "$val" > "$path"
}

sum_speed()
{
    local column=$1

    # Get the network interfaces needed
    declare -a interfaces=()
        for interface in /sys/class/net/*; do
            intf=$(basename $interface)
            if [[ $intf == eth* || $intf == wl* || $intf == en* ]]; then
                interfaces+=("$intf");
            fi
        done

    local line=""
    local val=0
    for intf in ${interfaces[@]} ; do
        line=$(cat /proc/net/dev | grep "$intf" | cut -d':' -f 2)
        speed="$(echo -n $line | cut -d' ' -f $column)"
        let val+=${speed:=0}
    done

    echo $val
}

is_osx() {
	[ $(uname) == "Darwin" ]
}

is_cygwin() {
	command -v WMIC > /dev/null
}

command_exists() {
	local command="$1"
	type "$command" >/dev/null 2>&1
}
