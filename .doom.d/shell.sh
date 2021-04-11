#!/usr/bin/env bash
set -euo pipefail
# Terminate already running bar instances
killall -q polybar
polybar
