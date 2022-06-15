#!/bin/bash
#This script prints a welcome message to the user

#Part 1: Define two variables, one for the user's name and one for the current date and time

name=
date=

#Part 2: Use the read command to prompt the user for their name

read -p "Enter your name: " name

#Part 3: Use the date command to store the current date and time in the date variable

date=$(date)

#Part 4: Use the printf command to print the welcome message

printf "Welcome $name! Today is $date"
