# optimizar imagenes
for file in src/origin/*
do
	name=${file:11}
	name=$(basename "$name" ".png")
	name=$(basename "$name" ".jpg")
	name=$(basename "$name" ".jpeg")
	convert "$file" -resize 480 -quality 50 "img/${name}.webp"
done

# crear los archivos .html
header=$(pandoc -s src/header.md)
header=${header::-15}
footer=$"</body>\n</html>"
for file in src/md/*
do
	name=${file:16}
	name=$(basename "$name" ".md")
	aux=$(echo "$name" | sed -e 's/\(.*\)/\L\1/')
	aux=$(echo "$aux" | sed -e 's/\s/_/g')
	footer=$(printf "<a href=\"post/${aux}.html\">${name}</a><br>\n${footer}")
	pandoc -s "$file" -o "post/${aux}.html"
done

header+=$footer
echo "$header" > index.html

# subir el sitio web
git add --all
git commit -m "`date`"
git push -u origin main 

