# pyenv initialization hook
#
# You can use the following variables in this file:
# * $package       package name
# * $path          package path
# * $dependencies  package dependencies

function __pyenv_plugin_pyenv_missing_hook -d "A shadow for the pyenv command if its missing"
	printf "pyenv is not installed.  Please make sure that PYENV_ROOT is set."
end

function __pyenv_plugin_add_hook -d "Enable shadowing the real pyenv command when its missing"
	if set -qg pyenv_plugin_hook_pyenv
		return
	end
	set -g pyenv_plugin_hook_pyenv true
	functions -e pyenv
end

function __pyenv_plugin_remove_hook -d "Remove pyenv shadow function"
	if not set -qg pyenv_plugin_hook_pyenv
		return
	end
	set -eg pyenv_plugin_hook_pyenv
	functions -c __pyenv_plugin_pyenv_missing_hook pyenv
end

function __pyenv_plugin_on_state_change -d "Pyenv root variable change hook" -v PYENV_ROOT
	if not type -aq pyenv; and set -q PYENV_ROOT; and test -e $PYENV_ROOT/bin/pyenv
		__pyenv_plugin_remove_hook
		set -xg PATH $PYENV_ROOT/bin $PATH
	else
		# Pyenv doesn't exist, make sure we've hooked it
		__pyenv_plugin_add_hook
	end
end

__pyenv_plugin_on_state_change
