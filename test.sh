#!/bin/bash

##################################################################################
# function string2code() {
#     # $1 is string to be converted
#     # return variable is letter2number
#     # $1 should consist of alphabetic ascii characters, otherwise return 1
#     # Each character is converted to its position in alphabet:
#     # a=01, b=02, ..., z=26
#     # case is ignored
#     arrsum=()
#     while read line; do
#         for word in $line; do
#             sum=0
#             string=$(echo $word | tr '\r' ' ' | tr -d '\n' | tr -d ' ')
#             if [[ $string == *['!'@#\$%^\&*()_+]* ]]; then
#                 echo "ERROR: THERE ARE SPECIAL CHARACTERS IN THE FILE"
#                 return 1
#             fi
#             while [[ $string ]]; do
#                 printf -v letter2number '%d' "$((36#${string::1} - 9))"
#                 sum=$((($sum + $letter2number) % 256))
#                 string=${string:1}
#             done
#             arrsum+=("$sum")
#         done
#     done <"text.txt"
# }

# string2code
# echo "${arrsum[@]}"
# max=${arrsum[0]}
# for n in "${arrsum[@]}"; do
#     ((n > max)) && max=$n
# done
# echo "$max"
# binarymax=$(echo "obase=2;$max" | bc)
# echo "$binarymax"   # 10000010

# key was found
######################################################################

# a=01101000
# f="${a:4:8}${a:0:4}"
# echo $f
###################################################################
######## obtaining number of every letter using base-36 ###########
# stri=A
# echo "$((36#${stri::1} - 9))"
######################################################################

# binarymax=10000010
# while read line; do
#     for word in $line; do
#         for ((i = 0; i < ${#word}; i++)); do
#             AscValue=$(echo "${word:$i:1}" | tr -d "\n" | od -An -t dC)
#             BinaryAscValue=$(echo "obase=2;$AscValue" | bc)
#             if [ "$BinaryAscValue" != 1101 ]; then
#                 # echo "$(($BinaryAscValue ^ $max))"
#                 xor=$(perl -e 'printf("%.8b",oct("0b".$ARGV[0])^oct("0b".$ARGV[1]))' $binarymax $BinaryAscValue)
#                 echo -e -n "${xor:4:8}${xor:0:4} " >> enc.txt
#             else
#                 continue
#             fi
#         done
#         if [ "$BinaryAscValue" != 1101 ]; then
#                 echo -e -n "00000010 " >> enc.txt
#             else
#                 continue
#             fi
#     done

# done <"text.txt"

# 1101110
# 10000010
# 11101100

echo "$(tput bold)$(tput setaf 4)"ENTER CIPHER TEXT FILE NAME TO DECRYPT"$(tput sgr0)"
    printf "==>"
    read -r decFile
    printf "\n"

# while read line; do
#     for word in $line; do
#         k=$word
#     done
# done <"c.txt"
# key="${k:4:8}${k:0:4}"
# printf "\n"
# echo "$(tput setaf 1)"ENCRYPTION KEY WAS FOUND SUCCESSFULLY"$(tput sgr0)"
# echo "IN BINARY==>${key}"
# echo -n "IN DECIMAL==>"
# echo "$((2#$key))"
# printf "\n"

# while read l; do
#     for w in $l; do
#         if [ "${w:4:8}${w:0:4}" != "$key" ]; then
#             if [ "$w" != 00100000 ]; then
#                 ascibinary="${w:4:8}${w:0:4}"
#                 xor_2=$(perl -e 'printf("%.8b",oct("0b".$ARGV[0])^oct("0b".$ARGV[1]))' $ascibinary $key)
#             else
#                 xor_2=$w
#             fi
#             ascichar=$(echo "$xor_2" | perl -lpe '$_=pack"B*",$_')
#             echo -n "$ascichar"
#         else
#             continue
#         fi
#     done
# done <"c.txt"


# echo "001000000110111000100000" | perl -lpe '$_=pack"B*",$_'


while true; do
    echo "$(tput bold)$(tput setaf 4)"ENTER CIPHER TEXT FILE NAME TO DECRYPT -OR- ENTER -1 TO EXIT"$(tput sgr0)"
    printf "==>"
    read -r decFile
    printf "\n"

    if [ "$decFile" == "-1" ]; then
        echo 'PROGRAM ENDED'
        exit
    fi

    if [ ! -e "$decFile" ]; then
        echo "${decFile} DOES NOT EXIST ON Y0UR DIRECTORY TRY AGAIN"
        continue
    fi
    break
done