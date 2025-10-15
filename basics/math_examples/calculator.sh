#!/bin/bash
#######################################
# Purpose: Just basic calculator with 2 inputs from user
# Logic: Execute add, subtract, multiply, division 

set -xeo

#Get input from user
echo "Please enter 2 NON ZERO int numbers"
read a
read b
echo "Basic calculator values are:"
echo "Additon: $((a + b))"
echo "Subtraction:$((a-b))"
echo "Multiplication:$((a*b))"
echo "NonZeroDivision:$((a/b))"