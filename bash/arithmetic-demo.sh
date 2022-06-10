#!/bin/bash

# This script demonstrates doing arithmetic

 

# Get two numbers from the user

read -p "Enter a number: " num1

read -p "Enter another number: " num2

 

# Perform arithmetic on the two numbers

sum=$((num1 + num2))

echo "$num1 + $num2 = $sum"

difference=$((num1 - num2))

echo "$num1 - $num2 = $difference"

product=$((num1 * num2))

echo "$num1 * $num2 = $product"

quotient=$((num1 / num2))

echo "$num1 / $num2 = $quotient"

remainder=$((num1 % num2))

echo "$num1 % $num2 = $remainder"

fpdividend=$(bc <<< "scale=2;$num1/$num2")

echo "$num1 / $num2 = $fpdividend"

 

# Perform math on the two numbers

exponent=$((num1 ** num2))

echo "$num1 to the power of $num2 = $exponent"

root=$(bc <<< "scale=2;sqrt($num1)")

echo "The square root of $num1 = $root"
