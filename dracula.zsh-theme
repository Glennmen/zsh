# Dracula Theme v1.2.5
#
# https://github.com/dracula/dracula-theme
#
# Copyright 2016, All rights reserved
#
# Code licensed under the MIT license
# http://zenorocha.mit-license.org
#
# @author Zeno Rocha <hi@zenorocha.com>

# Options

# Set dracula display time to 1 to show the date
DRACULA_DISPLAY_TIME=${DRACULA_DISPLAY_TIME:-0}

# Which symbols to use.
# Valid modes are:
#   'auto': if in a GUI terminal, enable symbols, this is the default
#   'ascii': forces ASCII-only symbols
#   'glyph': forces use of glyph symbols
DRACULA_SYMBOL_MODE=${DRACULA_SYMBOL_MODE:-'auto'}

# Default symbols
DRACULA_DEFAULT_GLYPH_START=${DRACULA_DEFAULT_GLYPH_START:-'➜'}
DRACULA_DEFAULT_ASCII_START=${DRACULA_DEFAULT_ASCII_START:-'->'}

DRACULA_DEFAULT_GLYPH_GITDIRTY=${DRACULA_DEFAULT_GLYPH_GITDIRTY:-'✗'}
DRACULA_DEFAULT_ASCII_GITDIRTY=${DRACULA_DEFAULT_ASCII_GITDIRTY:-'x'}

DRACULA_DEFAULT_GLYPH_GITCLEAN=${DRACULA_DEFAULT_GLYPH_GITCLEAN:-'✔'}
DRACULA_DEFAULT_ASCII_GITCLEAN=${DRACULA_DEFAULT_ASCII_GITCLEAN:-''}

typeset -g DRACULA_SYMBOL_START
typeset -g DRACULA_SYMBOL_GITCLEAN
typeset -g DRACULA_SYMBOL_GITDIRTY

dracula_set_symbols() {
  case "$1" in
    'auto')
      case $TERM in
        *bsd)
          dracula_set_symbols ascii
          ;;
        linux)
          dracula_set_symbols ascii
          ;;
        *)
          dracula_set_symbols glyph
          ;;
      esac
      ;;
    'ascii')
      DRACULA_SYMBOL_START="$DRACULA_DEFAULT_ASCII_START"
      DRACULA_SYMBOL_GITCLEAN="$DRACULA_DEFAULT_ASCII_GITCLEAN"
      DRACULA_SYMBOL_GITDIRTY="$DRACULA_DEFAULT_ASCII_GITDIRTY"
      ;;
    'glyph')
      DRACULA_SYMBOL_START="$DRACULA_DEFAULT_GLYPH_START"
      DRACULA_SYMBOL_GITCLEAN="$DRACULA_DEFAULT_GLYPH_GITCLEAN"
      DRACULA_SYMBOL_GITDIRTY="$DRACULA_DEFAULT_GLYPH_GITDIRTY"
      ;;
    *)
      >&2 echo "DRACULA_SYMBOL_MODE does not have a valid value: it is set to $DRACULA_SYMBOL_MODE
      Valid modes are:
      auto: if in a GUI terminal, enable symbols, this is the default
      ascii: forces ASCII-only symbols
      glyph: forces use of glyph symbols"
      ;;
  esac
}

dracula_set_symbols "$DRACULA_SYMBOL_MODE"

# locale specific time format
dracula_time_segment() {
  if (( DRACULA_DISPLAY_TIME )); then
    local time_fmt="%D{%l:%M%p}"
    
    if locale -c LC_TIME -k | grep 'am_pm=";"'; then
      time_fmt="%D{%k:M}"
    fi

    echo -n $time_fmt
  fi
}

# Slightly faster git_prompt_info when not in a git repo
# Note that this is a stand-in improvement until I get async implemented.
dracula_git_segment() {
  [[ -d .git ]] && git_prompt_info
}

local ret_status="%(?:%{$fg_bold[green]%}${DRACULA_SYMBOL_START}:%{$fg_bold[red]%}${DRACULA_SYMBOL_START})"

PROMPT='${ret_status}'
PROMPT+='%{$fg_bold[green]%}$(dracula_time_segment) '
PROMPT+='%{$fg_bold[blue]%}%c '
PROMPT+='$(dracula_git_segment)% '
PROMPT+='%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_CLEAN=") %{$fg_bold[green]%}${DRACULA_SYMBOL_GITCLEAN} "
ZSH_THEME_GIT_PROMPT_DIRTY=") %{$fg_bold[yellow]%}${DRACULA_SYMBOL_GITDIRTY} "
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

# vim: set filetype=zsh :
