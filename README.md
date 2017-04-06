# plugin-pyenv
[![MIT License](https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square)](/LICENSE)
[![Fish Shell Version](https://img.shields.io/badge/fish-v2.2.0-007EC7.svg?style=flat-square)](https://fishshell.com)

A fish plugin that sets up you up for pyenv.

## Features
* Looks for pyenv in common places
* When pyenv is not installed, clobbers the `pyenv` command to tell you how to fix the problem
* When `PYENV_ROOT` is set, automatically sets up pyenv without the need to reload
* Hooks in pyenv completions

## Install

### Using fisherman
```fish
$ fisher Fiveside/pyenv
```


## Usage

```fish
$ pyenv
```


# License
[MIT][mit] © [Erich Healy][author] et [al][contributors]


[mit]:            https://opensource.org/licenses/MIT
[author]:         https://github.com/Fiveside
[contributors]:   https://github.com/Fiveside/plugin-pyenv/graphs/contributors

[license-badge]:  https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square
