hola="Hola que haces"
hola=$(echo "$hola" | sed -e 's/\(.*\)/\L\1/')
hola=$(echo "$hola" | sed -e 's/\s/+/g')
echo "$hola"
