#!/bin/sh
set -e
#
# This script is meant for quick & easy install via:
#   'curl -sSL https://get.daoCloud.io/daomonit | sh -s [DaoCloudToken]'
# or:
#   'wget -qO- https://get.daoCloud.io/daomonit| sh -s [DaoCloudToken]'
#

if [ -z "$1" ]
then
    echo 'Error: you should install daomonit with token, like:'
    echo 'curl -sSL https://get.daoCloud.io/daomonit | sh -s [DaoCloudToken]'
    exit 0
fi

arg_token=$1
arg_server=$2
arg_id=$3

url='https://get.daocloud.io/daomonit'

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

case "$(uname -m)" in
	*64)
		;;
	*)
		echo >&2 'Error: you are not using a 64bit platform.'
		echo >&2 'Daomonit currently only supports 64bit platforms.'
		exit 1
		;;
esac

# if command_exists daomonit ; then
# 	echo >&2 'Warning: "daomonit" command appears to already exist.'
# 	echo >&2 'Please ensure that you do not already have daomonit installed.'
# 	echo >&2 'You may press Ctrl+C now to abort this process and rectify this situation.'
# 	( set -x; sleep 20 )
# fi

user="$(id -un 2>/dev/null || true)"

sh_c='sh -c'
if [ "$user" != 'root' ]; then
	if command_exists sudo; then
		sh_c='sudo -E sh -c'
	elif command_exists su; then
		sh_c='su -c'
	else
		echo >&2 'Error: this installer needs the ability to run commands as root.'
		echo >&2 'We are unable to find either "sudo" or "su" available to make this happen.'
	fi
fi

curl=''
if command_exists curl; then
	curl='curl --retry 20 --retry-delay 5 -L'
else
	echo >&2 'Error: this installer needs curl. You should install curl first.'
	exit 1
# elif command_exists wget; then
	# curl='wget -qO-'
# elif command_exists busybox && busybox --list-modules | grep -q wget; then
	# curl='busybox wget -qO-'
fi

check_daomonit () {
	 
	if ps ax | grep -v grep | grep "daomonit " > /dev/null
	then
	    echo "Daomonit service running.Stop daomonit"
	    $sh_c "service daomonit stop"
	fi
	 
}

check_daomonit

# perform some very rudimentary platform detection
lsb_dist=''
if command_exists lsb_release; then
	lsb_dist="$(lsb_release -si)"
fi
if [ -z "$lsb_dist" ] && [ -r /etc/lsb-release ]; then
	lsb_dist="$(. /etc/lsb-release && echo "$DISTRIB_ID")"
fi
if [ -z "$lsb_dist" ] && [ -r /etc/debian_version ]; then
	lsb_dist='debian'
fi
if [ -z "$lsb_dist" ] && [ -r /etc/fedora-release ]; then
	lsb_dist='fedora'
fi
if [ -z "$lsb_dist" ] && [ -r /etc/os-release ]; then
	lsb_dist="$(. /etc/os-release && echo "$ID")"
fi
if [ -z "$lsb_dist" ] && [ -r /etc/centos-release ]; then
	lsb_dist="$(cat /etc/*-release | head -n1 | cut -d " " -f1)"
fi
if [ -z "$lsb_dist" ] && [ -r /etc/redhat-release ]; then
	lsb_dist="$(cat /etc/*-release | head -n1 | cut -d " " -f1)"
fi
lsb_dist="$(echo $lsb_dist | cut -d " " -f1)"

lsb_version=""
if [ -r /etc/os-release ]; then
	lsb_version="$(. /etc/os-release && echo "$VERSION_ID")"
fi

update_default_config() {
	echo " * Configuring Daomonit..."

	$sh_c "/usr/local/bin/daomonit -token=$arg_token save-config"
	
		# $sh_c "$curl ${url}/daomonit.yml > /etc/daocloud/daomonit.yml "
		# $sh_c "sed -i \"s/token: /token: ${1}/g\" /etc/daocloud/daomonit.yml "
	# fi

	$sh_c "rm -rf /etc/default/daomonit"
	if [ ! -z "$arg_server" ]
	then
	    $sh_c "echo \"DAOMONIT_OPTS=\\\"-server $arg_server\\\"\" > /etc/default/daomonit"
	fi
}

start_daomonit () {
	echo " * Configuring Daomonit Mirror..."
	need_docker_restart=false
	exit_status=0
	if [ ! -z "$arg_id" ]
	then
		if $sh_c "/usr/local/bin/daomonit -token=$arg_token -server=$arg_server -id=$arg_id config-mirror"
		then
			need_docker_restart=true
		fi
	elif [ ! -z "$arg_server" ]
	then
		if $sh_c "/usr/local/bin/daomonit -token=$arg_token -server=$arg_server config-mirror"
		then
			need_docker_restart=true
		fi
	else
		if $sh_c "/usr/local/bin/daomonit -token=$arg_token config-mirror"
		then
			need_docker_restart=true
		fi
	fi
	echo " * Start Daomonit..."
	$sh_c "service daomonit start"

	if command_exists /usr/local/bin/daomonit; then
		
		echo
		echo "You can view daomonit log at /var/log/daomonit.log"
		echo "And You can Start or Stop daomonit with: service daomonit start/stop/restart/status"
		echo

		echo "*********************************************************************"
		echo "*********************************************************************"
		echo "***"
		echo "***  Installed and Started Daomonit $(daomonit version)"
		echo "***"

		if $need_docker_restart
		then
			echo "***  NOTICE: "
			echo "***  You need to restart your docker to Enable the Docker Mirror by: "
			echo "***     service docker restart"
			echo "***"				
		fi 

		echo "*********************************************************************"
		echo "*********************************************************************"
		echo
		
	fi
}

not_support () {
	echo
	echo "Daomonit not support ${lsb_dist} ${lsb_version} now"
	echo
	exit 0
}

generate_monit_script() {
    cat  <<EOF >/etc/monit/conf.d/daomonit
check process daomonit with pidfile /var/run/daomonit-ssd.pid
  start program = "/etc/init.d/daomonit start"
  stop program = "/etc/init.d/daomonit stop"
EOF
    echo "monit script created successfully at /etc/monit/conf.d/daomonit"
}

lsb_dist="$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')"
case "$lsb_dist" in
	gentoo|boot2docker|amzn|linuxmint)
		not_support
		;;
	fedora|centos)
		(
			echo " * Installing Daomonit..."

			# set -x

			echo " * Downloading Daomonit from ${url}/daomonit.x86_64.rpm"
			$sh_c "$curl -o /tmp/daomonit.x86_64.rpm ${url}/daomonit.x86_64.rpm"
			if command_exists /usr/local/bin/daomonit; then
				$sh_c "rpm -ev daomonit"
			fi
			$sh_c "rpm -Uvh /tmp/daomonit.x86_64.rpm"

			update_default_config
			
			start_daomonit
		)
		exit 0
		;;


	ubuntu|debian)
		(

			# if [ "$lsb_version" = '15.04' ]; then
			# 	(
			# 		not_support
			# 	)
			# fi

			echo " * Installing Daomonit..."

			# set -x

			echo " * Downloading Daomonit from ${url}/daomonit_amd64.deb"
			$sh_c "$curl -o /tmp/daomonit_amd64.deb ${url}/daomonit_amd64.deb"
			$sh_c "dpkg -i /tmp/daomonit_amd64.deb"

			update_default_config
			
			start_daomonit

			if [ "$lsb_dist" = 'debian' ]; then
				(
					set -x
					$sh_c 'sleep 3; apt-get update; apt-get install monit'
					generate_monit_script
					$sh_c 'service monit restart'
				)
			fi

		)
		exit 0
		;;

esac

cat >&2 <<'EOF'

  Your platform is not yet have a package for Daomonit.
  We would support as soon as possbile.

EOF
exit 1