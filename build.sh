html=$(cat html/header.html)
footer='</body></html>'

for file in md/*
do
	name=${file:12}
	name=$(basename "$name" ".md")
	aux=$(echo "html/${name}.html")
	footer=$(echo "<a href=\"${aux}\">${name}</a><br>${footer}")
	pandoc -s "$file" -o "$aux"
done

html+=$footer
echo $html > index.html

