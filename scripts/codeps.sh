APPLICATION_NAME=codesp;
BASEPATH=$HOME/.vscode/;
USERCONFIG=$HOME/.config/Code/User;

DEFAULT_PROFILE_NAME=default;
SYMLINK_TARGET=$BASEPATH/extensions;

write_to_stderr()
{
	 echo "$APPLICATION_NAME: $@" >&2;
}

list_available_profiles()
{
	for f in $HOME/.vscode/* ; do
		if [ -d $f ]; then
			echo $f | awk -F/ '{print $NF}';
		fi
	done
}

switch_profile()
{
	if [ -d $BASEPATH/$1 ] ; then
		ln -sf $BASEPATH/$1/extensions $BASEPATH
		ln -sf $BASEPATH/$1/settings.json $USERCONFIG
	else
		write_to_stderr "\"$1\" is not a valid profile."
	fi
}

create_profile()
{
	if [ -d $BASEPATH/$1 ] ; then
		write_to_stderr "Profile \"$1\" already exists."
	else
		mkdir $BASEPATH/$1
		mkdir $BASEPATH/$1/extensions
		touch $BASEPATH/$1/settings.json
	fi
}

remove_profile()
{
	if [ $DEFAULT_PROFILE_NAME == $1 ] ; then
		write_to_stderr "Cannot delete default profile.";
	else
		if [ -d $BASEPATH/$1 ] ; then
			rm -rf $BASEPATH/$1
			if [ $(readlink $SYMLINK_TARGET | awk -F/ '{ print $(NF-1) }') == $1 ] ; then
				switch_profile $DEFAULT_PROFILE_NAME;
			fi
		else 
			write_to_stderr "Profile \"$1\" does not exist."
		fi
	fi
}

while getopts c:ls:r: flag
do
    case "${flag}" in
        c) create_profile ${OPTARG};;
    	l) list_available_profiles;;
        s) switch_profile ${OPTARG};;
        r) remove_profile ${OPTARG};;
    esac
done

