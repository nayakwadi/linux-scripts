full_date=$(date)
complete_date=$(date +"%Y-%m-%d %H-%M-%S")
just_date=$(date +"%Y-%m-%d")
just_time=$(date +"%H-%M-%S")
just_hour=$(date +"%H")
weekday=$(date +"%A")
month=$(date +"%B")


######################################
# Wed Oct 15 05:42:37 EDT 2025
# 2025-10-15 05-42-37
# 2025-10-15
# 05-42-37
# 05
# Wendesday
# October
####################################
echo $full_date
echo $complete_date
echo $just_date
echo $just_time
echo $just_hour
echo $weekday
echo $month


if [[ $just_hour -gt 0  && $just_hour -lt 12 ]]; then
    echo "GOOD MORNING!!!"
elif [[ $just_hour -ge 12 && $just_hour -lt 16 ]]; then
    echo "GOOD AFTERNOON!!!"
elif [[ $just_hour -ge 16 && $just_hour -lt 19 ]]; then 
    echo "GOOD EVENING!!!"
else 
    echo "GOOD NIGHT!!!"
fi