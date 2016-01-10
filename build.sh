#!/bin/bash
rm -rf Packages
swift build --clean
swift build
