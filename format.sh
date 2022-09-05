#!/usr/bin/env bash


mint run swift-format --in-place --recursive -- \
    ./TripPlanner \
	./TUIKit \
    && echo "All done" \
    || (echo "Failed"; exit 1)
