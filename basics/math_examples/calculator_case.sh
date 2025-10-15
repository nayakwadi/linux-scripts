#!/bin/bash
#######################################
# Purpose: Just basic calculator with 2 inputs from user
# Logic: Execute add, subtract, multiply, division 

set -xeo

#Get input from user
echo "Please enter 2 NON ZERO  numbers"
read a
read b
echo "Please choose operator from below:"
echo "1 for addition"
echo "2 for subtraction"
echo "3 for multiplication"
echo "4 for division"
read ch

# # case with basic integer operations, no decimal point calculations
# case $ch in 
#     1) res=$((a+b));;
#     2) res=$((a-b));;
#     3) res=$((a*b));;
#     4) res=$((a/b));;
# esac

#case with precision including floating numbers
# bc stands for Basic Calculator — it’s a command-line calculator utility available on most Unix/Linux systems.
case $ch in 
    1) res=$(echo "$a + $b" | bc) ;;
    2) res=$(echo "$a - $b" | bc) ;;
    3) res=$(echo "$a * $b" | bc) ;;
    4) res=$(echo "$a / $b" | bc) ;;
    *) echo "Invalid choice" 
esac

echo "Result is: $res"
