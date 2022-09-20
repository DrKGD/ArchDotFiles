#!/bin/bash

# Kill all instances of shutter
killall -q shutter >/dev/null 2>&1 || true

# Start shutter minimized
shutter --min_at_startup
