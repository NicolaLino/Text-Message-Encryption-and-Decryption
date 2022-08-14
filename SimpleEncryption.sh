#!/bin/bash

function encryption() {
    arrsum=() # array to store the sum of characters numbers

    while read -r line; do # loop in every line in the file

        for word in $line; do
            sum=0
            string=$(echo "$word" | tr '\r' ' ' | tr -d '\n' | tr -d ' ') # remove any spaces or newline in a word
            if [[ $string == *[,.'!'@\#\$%^\&*()_+]* ]]; then             # check for special characters in the file and return an error in exist
                printf "\n"
                echo "$(tput setaf 1)"ERROR: THERE ARE SPECIAL CHARACTERS IN THE FILE!""
                printf "\n"
                exit 1
                return 1
            fi
            #loop through every letter in a word
            while [[ $string ]]; do
                printf -v letter2number '%d' "$((36#${string::1} - 9))" # converting every letter to number using base-36
                sum=$(($sum + $letter2number))                          # sum of all letters
                string=${string:1}                                      # increment to next letter in a word
            done
            mod=$(($sum % 256))
            arrsum+=("$mod") # add the 256 mod of the sum to the array
        done
    done <"$fileName"

    # echo "${arrsum[@]}"
    #find the max number in the array which is the key
    max=${arrsum[0]}
    for n in "${arrsum[@]}"; do
        ((n > max)) && max=$n
    done
    # echo "$max"
    printf "\n"
    echo "$(tput setaf 1)"ENCRYPTION KEY WAS GENERATED SUCCESSFULLY"$(tput sgr0)"
    echo "IN DECIMAL==>${max}"
    binarymax=$(echo "obase=2;$max" | bc)     # convert key from decimal to binary
    binarymax=$(printf "%08d\n" "$binarymax") # always 8 bits
    echo "IN BINARY==>${binarymax}"
    printf "\n"
    echo "$(tput bold)$(tput setaf 4)"ENTER A FILE NAME YOU WANT TO SAVE CIPHER TEXT INTO"$(tput sgr0)"
    printf "==>"
    read -r encFile
    printf "\n"

    echo -n "" >"$encFile" #empty the file

    while read -r line; do

        for word in $line; do

            for ((i = 0; i < ${#word}; i++)); do # loop for each letter in the file

                AscValue=$(echo "${word:$i:1}" | tr -d "\n" | od -An -t dC) # find the ascii value of the letter
                BinaryAscValue=$(echo "obase=2;$AscValue" | bc)             # convert it to binary

                if [ "$BinaryAscValue" != 1101 ]; then
                    # echo "$(($BinaryAscValue ^ $max))"
                    xor=$(perl -e 'printf("%.8b",oct("0b".$ARGV[0])^oct("0b".$ARGV[1]))' $binarymax $BinaryAscValue) #XOR key with ascii binary of the letter
                    echo -e -n "${xor:4:8}${xor:0:4} " >>"$encFile"                                                  # flip first 4 bits with last 4 bits
                else
                    continue
                fi
            done

            if [ "$BinaryAscValue" != 1101 ]; then
                echo -e -n "00100000 " >>"$encFile"
            else
                continue
            fi

        done
    done <"$fileName"

    echo -e -n "${binarymax:4:8}${binarymax:0:4} \n" >>"$encFile" # add encryption key to the end of the file after fliping first 4 bits with last 4 bits
    # echo -e "\n"
}

function decryption() {

    while true; do #open cipher file
        echo "$(tput bold)$(tput setaf 4)"ENTER CIPHER TEXT FILE NAME TO DECRYPT -OR- ENTER -1 TO EXIT"$(tput sgr0)"
        printf "==>"
        read -r decFile
        printf "\n"

        if [ "$decFile" == "-1" ]; then
            echo "$(tput setaf 6)"PROGRAM ENDED"$(tput sgr0)"
            exit
        fi

        if [ ! -e "$decFile" ]; then
            echo "$(tput setaf 1)""${decFile}" DOES NOT EXIST ON Y0UR DIRECTORY TRY AGAIN"$(tput sgr0)"
            continue
        fi
        break
    done

    while read -r line; do # find encryption key
        for word in $line; do
            k=$word
        done
    done <"$decFile"

    key="${k:4:8}${k:0:4}" # flip the key bits
    printf "\n"
    echo "$(tput setaf 1)"ENCRYPTION KEY WAS FOUND SUCCESSFULLY"$(tput sgr0)"
    echo "IN BINARY==>${key}"
    echo -n "IN DECIMAL==>"
    echo "$((2#$key))"
    printf "\n"

    echo "$(tput bold)$(tput setaf 4)"ENTER A FILE NAME YOU WANT TO SAVE PLAIN TEXT INTO"$(tput sgr0)"
    printf "==>"
    read -r plainfile
    
    printf "\n"

    # loop through the file to decrypt
    while read -r l; do

        for w in $l; do

            if [ "${w:4:8}${w:0:4}" != "$key" ]; then
                if [ "$w" != 00100000 ]; then
                    ascibinary="${w:4:8}${w:0:4}"
                    xor_2=$(perl -e 'printf("%.8b",oct("0b".$ARGV[0])^oct("0b".$ARGV[1]))' $ascibinary $key) #XOR key with ascii binary of the letter
                else
                    xor_2=$w
                fi
                ascichar=$(echo "$xor_2" | perl -lpe '$_=pack"B*",$_') # convert from binary ascii to letter
                echo -e -n "$ascichar" >>"$plainfile"
            else
                continue
            fi
        done
    done <"$decFile"

}

clear

echo "$(tput bold)$(tput setaf 2)" -------------------------------------------------------""

echo "|                                                       |"

echo "|         TEXT MESSAGE ENCRYPTION / DECRYPTION          |"

echo "|                                                       |"

echo "" -------------------------------------------------------"$(tput sgr0)"

echo "$(tput setaf 4)"PLEASE ENTER A FILE NAME YOU WANT TO READ -OR- ENTER -1 TO EXIT""

while true; do
    printf "==>"
    read -r fileName
    echo $(tput sgr0)

    if [ "$fileName" == "-1" ]; then
        echo "$(tput setaf 6)"PROGRAM ENDED"$(tput sgr0)"
        exit
    fi

    if [ ! -e "$fileName" ]; then
        echo "$(tput setaf 1)""${fileName}" DOES NOT EXIST ON Y0UR DIRECTORY TRY AGAIN"$(tput sgr0)"
        continue
    fi
    break
done

while true; do
    echo "$(tput bold)$(tput setaf 2)" -------------------------------------------------------""
    echo "|                                                       |"
    echo '|  E. Encrypt The File                                  |'
    echo '|  D. Decrypt The File                                  |'
    echo '|  Q. EXIT                                              |'
    echo "|                                                       |"
    echo "" -------------------------------------------------------"$(tput sgr0)"
    echo -n "==>"
    read -r choice

    toUpper=$(echo -e "${choice}" | tr '[:lower:]' '[:upper:]')

    case $toUpper in

    \
        \
        \
        E) encryption $fileName ;;
    D) decryption ;;
    Q) break ;;

    esac

done

echo "$(tput bold)$(tput setaf 6)"THANK YOU"$(tput sgr0)"
