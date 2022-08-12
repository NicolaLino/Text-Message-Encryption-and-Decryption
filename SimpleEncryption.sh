#!/bin/bash

function encryption() {
    arrsum=()

    while read line; do

        for word in $line; do
            sum=0
            string=$(echo "$word" | tr '\r' ' ' | tr -d '\n' | tr -d ' ')
            if [[ $string == *[,.'!'@\#\$%^\&*()_+]* ]]; then
                printf "\n"
                echo "$(tput setaf 1)"ERROR: THERE ARE SPECIAL CHARACTERS IN THE FILE!""
                printf "\n"
                exit 1
                return 1
            fi
            while [[ $string ]]; do
                printf -v letter2number '%d' "$((36#${string::1} - 9))"
                sum=$((($sum + $letter2number) % 256))
                string=${string:1}
            done
            arrsum+=("$sum")
        done
    done <"$fileName"

    # echo "${arrsum[@]}"
    max=${arrsum[0]}

    for n in "${arrsum[@]}"; do
        ((n > max)) && max=$n
    done

    printf "\n"
    echo "$(tput setaf 1)"ENCRYPTION KEY WAS GENERATED SUCCESSFULLY"$(tput sgr0)"
    echo "IN DECIMAL==>${max}"
    binarymax=$(echo "obase=2;$max" | bc)
    echo "IN BINARY==>${binarymax}"
    printf "\n"
    echo "$(tput bold)$(tput setaf 4)"ENTER A FILE NAME YOU WANT TO SAVE CIPHER TEXT INTO"$(tput sgr0)"
    printf "==>"
    read -r encFile
    printf "\n"

    echo -n "" >"$encFile" #empty the file

    while read line; do

        for word in $line; do

            for ((i = 0; i < ${#word}; i++)); do

                AscValue=$(echo "${word:$i:1}" | tr -d "\n" | od -An -t dC)
                BinaryAscValue=$(echo "obase=2;$AscValue" | bc)

                if [ "$BinaryAscValue" != 1101 ]; then
                    # echo "$(($BinaryAscValue ^ $max))"
                    xor=$(perl -e 'printf("%.8b",oct("0b".$ARGV[0])^oct("0b".$ARGV[1]))' $binarymax $BinaryAscValue)
                    echo -e -n "${xor:4:8}${xor:0:4} " >>"$encFile"
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

    echo -e -n "${binarymax:4:8}${binarymax:0:4} \n" >>"$encFile"
    # echo -e "\n"
}


function decryption() {
    echo "$(tput bold)$(tput setaf 4)"ENTER CIPHER TEXT FILE NAME TO DECRYPT"$(tput sgr0)"
    printf "==>"
    read -r decFile
    printf "\n"

    while read -r line; do
        for word in $line; do
            k=$word
        done
    done <"$decFile"


    key="${k:4:8}${k:0:4}"
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


    while read -r l; do
        for w in $l; do
            if [ "${w:4:8}${w:0:4}" != "$key" ]; then
                if [ "$w" != 00100000 ]; then
                    ascibinary="${w:4:8}${w:0:4}"
                    xor_2=$(perl -e 'printf("%.8b",oct("0b".$ARGV[0])^oct("0b".$ARGV[1]))' $ascibinary $key)
                else
                    xor_2=$w
                fi
                ascichar=$(echo "$xor_2" | perl -lpe '$_=pack"B*",$_')
                echo -e -n "$ascichar" >>"$plainfile"
            else
                continue
            fi
        done
    done <"$decFile"

}



echo "$(tput bold)$(tput setaf 2)"------------------------------------------------------""

echo "---------------------- WELCOME! -----------------------"

echo ""-------------------------------------------------------"$(tput sgr0)"

echo "$(tput setaf 4)"PLEASE ENTER A FILE NAME YOU WANT TO READ -OR- ENTER -1 TO EXIT""

while true; do
    printf "==>"
    read -r fileName
    echo $(tput sgr0)

    if [ "$fileName" == "-1" ]; then
        echo 'PROGRAM ENDED'
        exit
    fi

    if [ ! -e "$fileName" ]; then
        echo "${fileName} DOES NOT EXIST ON Y0UR DIRECTORY TRY AGAIN"
        continue
    fi
    break
done

while true; do
    echo "$(tput bold)$(tput setaf 2)"-------------------------------------------------------""
    echo 'E. Encrypt The File'
    echo 'D. Decrypt The File'
    echo 'Q. EXIT'
    echo ""-------------------------------------------------------"$(tput sgr0)"
    echo -n "==>"
    read -r choice
    
    toUpper=$(echo -e "${choice}" | tr '[:lower:]' '[:upper:]')

    case $toUpper in

    
    \
    E) encryption $fileName ;;
    D) decryption ;;
    Q) break ;;

    esac

done

echo "$(tput bold)$(tput setaf 6)"THANK YOU"$(tput sgr0)"
