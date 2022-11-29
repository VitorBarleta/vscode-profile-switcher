install_codeps()
{
	CODE_BIN_PATH=$(whereis code | awk -F: ' {print $NF} ');
	if [ -z "$CODE_BIN_PATH" ] ; then
		echo "Visual Studio Code is not installed or is not in the "\$PATH"";
	else
		if [ ! -d $HOME/.local/bin ] ; then
			mkdir $HOME/.local
			mkdir $HOME/.local/bin
		fi
		cp ./scripts/codeps.sh ~/.local/bin/codeps
		
		echo "PATH=\"\$HOME/.local/bin/codeps:\$PATH\"" >> $HOME/.bashrc
	fi
}

install_fish()
{
	FISH_BIN_PATH=$(whereis fish | awk -F: ' {print $NF} ');
	if [ -z "$FISH_BIN_PATH" ] ; then
		echo "Fish is not actually installed in the system.";
	else
		$( fish_add_path -aP $HOME/.local/bin );
	fi
}

while getopts if flag
do
    case "${flag}" in
        i) install_codeps ;;
        f) install_fish ;;
    esac
done
