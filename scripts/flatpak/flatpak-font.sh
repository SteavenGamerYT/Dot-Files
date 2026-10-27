#!/usr/bin/env bash
flatpak list --columns=application | grep -v Application | xargs -I {} flatpak run --command=fc-cache {} -f -v