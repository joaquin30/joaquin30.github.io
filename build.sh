html=$(cat html/header.txt)
footer=$"</body>\n</html>"

for file in md/*
do
	name=${file:12}
	name=$(basename "$name" ".md")
	aux=$(echo "html/${name}.html")
	footer=$(echo "<a href=\"${aux}\">${name}</a><br>${footer}")
	pandoc -s "$file" -o "$aux"
done

html+=$footer
echo "$html" > index.html
git add --all
git commit -m "`date`"
git push -u origin main << "joaquin30 sghM4k7cjKBv37u"

