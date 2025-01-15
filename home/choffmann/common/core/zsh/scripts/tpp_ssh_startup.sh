#!/usr/bin/env bash

if ([[ "$SSH_CLIENT" == *"127.0.0.1"* ]] || [[ "$SSH_CLIENT" == *"::1"* ]]) && [ -n "$SSH_TTY" ]; then
  echo "Welcome to the server $(hostnamectl --static)"
  if [ -z "$NAME" ]; then echo "Du bist unnerwünscht"; exit; fi
    
  echo "Hello $NAME"
  sleep 1
    
  if [ -z "$TMUX" ]; then
    tmux attach -t "$NAME" || tmux new -t "$USER" -s "$NAME"
    exit 1
  fi
fi
