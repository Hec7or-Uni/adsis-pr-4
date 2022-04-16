#!/usr/bin/bash
if [ $# -eq 3 ]
then
    while IFS= read -r ip
    do  
        ssh -n as@${ip} "exit" &> /dev/null
        if [ $? -eq 0 ] 
        then 
            scp practica3.sh ./$2 as@${ip}:~/ &> /dev/null
            ssh -n as@${ip} "sudo ./practica3.sh $1 ./$2 && rm practica3.sh ./$2 && exit"
        else echo "${ip} no es accesible"
        fi
    done < $3
else echo "Numero incorrecto de parametros"
fi