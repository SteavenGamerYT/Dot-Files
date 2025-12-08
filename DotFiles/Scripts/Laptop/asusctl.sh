#!/usr/bin/env bash

echo "Setting RGB to High"
asusctl -k high
echo
echo "Setting RGB to static"
asusctl aura static 
echo
echo "Setting RGB to White"
asusctl aura static -c ffffff
echo
echo "Limiting battery charge to 80%"
asusctl -c 80