# pyenv initialization hook
# globals: pyenv_plugin_hook_pyenv, pyenv_plugin_initialized

function __pyenv_plugin_pyenv_missing_hook -d "A shadow for the pyenv command if its missing"
  echo "pyenv is not installed."
  echo
  echo "Ensure sure that PYENV_ROOT is set to pyenv's location or"
  echo "that pyenv is installed in its default location"
  echo
  echo "To install pyenv automatically, run pyenv_install"
  echo
end

function pyenv_install -d "Automatically install pyenv for the current user"
  set -l g "https://github.com/yyuu"
  set -l root "$HOME/.local/share/pyenv"
  mkdir -p "$root"

  function checkout -n url dest
    git clone (printf "https://github.com/yyuu/%s" "$url") (printf "$root/%s" "$dest")
  end

  checkout "pyenv.git" ""
  checkout "pyenv-installer.git" "plugins/pyenv-installer"
  checkout "pyenv-update.git" "plugins/pyenv-update"
  checkout "pyenv-virtualenv.git" "plugins/pyenv-virtualenv"
  checkout "pyenv-which-ext.git" "plugins/pyenv-which-ext"

  set -xUg PYENV_ROOT $root
  echo "TODO!"
end

function __pyenv_plugin_add_hook -d "Enable shadowing the real pyenv command when its missing"
  if set -qg pyenv_plugin_hook_pyenv
    return
  end
  set -g pyenv_plugin_hook_pyenv true
  functions -c __pyenv_plugin_pyenv_missing_hook pyenv
end

function __pyenv_plugin_remove_hook -d "Remove pyenv shadow function"
  if not set -qg pyenv_plugin_hook_pyenv
    return
  end
  set -eg pyenv_plugin_hook_pyenv
  functions -e pyenv
end

function __pyenv_plugin_on_state_change -d "Pyenv root variable change hook" -v PYENV_ROOT
  # is pyenv installed in a default location without setting up pyenv_root?
  if not set -q PYENV_ROOT; and test -e $HOME/.pyenv/bin/pyenv
    # Causes a recursive call here.
    set -xg PYENV_ROOT $HOME/.pyenv/bin/pyenv
    return
  end

  if not type -aq pyenv; and set -q PYENV_ROOT; and test -e $PYENV_ROOT/bin/pyenv
    __pyenv_plugin_remove_hook
    set -xg PATH $PYENV_ROOT/bin $PATH
    if status is-interactive
      source (pyenv init - | psub)
      source (pyenv virtualenv-init | psub)
    end
  else
    # Pyenv doesn't exist, make sure we've hooked it
    __pyenv_plugin_add_hook
  end
end

__pyenv_plugin_on_state_change
