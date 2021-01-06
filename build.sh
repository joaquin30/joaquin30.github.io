header=$(pandoc -s header.md)
header=${header::-15}
footer=$"</body>\n</html>"
for file in md/*
do
	name=${file:12}
	name=$(basename "$name" ".md")
	aux=$(echo "$name" | sed -e 's/\(.*\)/\L\1/')
	aux=$(echo "$aux" | sed -e 's/\s/_/g')
	footer=$(printf "<a href=\"${aux}.html\">${name}</a><br>\n${footer}")
	pandoc -s "$file" -o "${aux}.html"
done

header+=$footer
echo "$header" > index.html
git add --all
git commit -m "`date`"
git push -u origin main 

