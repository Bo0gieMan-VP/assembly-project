#!/bin/bash
######################QUESTION 1######################
question1(){
    read -p "Enter a number and a digit: " num digit
	number=$num
	counter=0
	while (( "$number" > "0" ))
	do
		dig=$( echo "$number % 10" | bc )
		if [[ $dig -eq $digit ]]
		then
			 counter=$(echo "$counter+1" | bc )
		fi
		number=$number/10;
	done

	echo "The digit $digit, appears $counter times"
}
######################QUESTION 2######################
question2(){
	read -p "Enter a number: " num 
	number=$num
	counter=0
	power=1
	sum=0
	while (( "$number" > "0" ))
	do
		dig=$( echo "$number % 10" | bc )
		if [[ $( echo "$counter%2" |bc ) -eq 0 ]]
		then
			 sum=$( echo "$sum+($dig*$power)" | bc )
			 power=$( echo "$power*10" | bc)
		fi
		counter=$(echo "$counter+1" | bc )
		number=$number/10;
	done

	echo "The new number is $sum"
}
######################QUESTION 3######################	
question3(){
	read -p "Enter two numbers: " num1 num2
	counter=0
	if [[ ${#num1} -gt ${#num2} ]]; then
		count=${#num2}
	else
		count=${#num1}
	fi
	while (( "$count" > "0" ))
	do
		digit1=$( echo "$num1%10" | bc )
		digit2=$( echo "$num2%10" | bc )
		if [[ $digit1 -eq $digit2 ]]; then
			counter=$( echo "$counter+1" | bc )		
		fi
		num1=$( echo "$num1/10" | bc )
		num2=$( echo "$num2/10" | bc )
		count=$( echo "$count-1" | bc )
	done
	echo "Total matches: $counter"
}
#########################MAIN#########################
until [[ $selection -eq 10 ]] 
do
	echo "Choose the question (1-3)"
	read -p "10 to EXIT               : " selection
	case $selection in
		1)
			question1
		;;
		2)
			question2
		;;
		3)	
			question3
		;;
		10)
			echo "Bye bye!"
		;;
		*)
			echo "Wrong input!"
		;;
	esac
done
