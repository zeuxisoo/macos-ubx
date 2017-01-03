# Ubx

A ubx application for macOS application

## Development

Install the cocoapods

	sudo gem install cocoapods
	
Install the dependencies

	pod install
	
Start the workspace in project directory

	cd ubx
	open Ubx.xcworkspace
	
Run the project by commands

	# Clean the project
	Shift+Command+K
	
	# Build the project
	Command+B
	
	# Run the project
	Command+R

## Release

Signing

	1. Click on the Ubx
	2. General > Targets (Ubx)
	3. Signing > Select account

Build app

	# Menu bar > Product > Build for > Profiling
	Shift+Command+I
	
Create dmg

	cd ./Scripts
	make clean
	make dmg