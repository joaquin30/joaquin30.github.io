html=$(cat header.txt)
footer=$"</body>\n</html>"

for file in md/*
do
	name=${file:12}
	name=$(basename "$name" ".md")
	aux=$(echo "$name" | sed -e 's/\(.*\)/\L\1/')
	aux=$(echo "$aux" | sed -e 's/\s/_/g')
	footer=$(printf "<a href=\"${aux}\">${name}</a><br>\n${footer}")
	pandoc -s "$file" -o "${aux}.html"
done

html+=$footer
echo "$html" > index.html
git add --all
git commit -m "`date`"
git push -u origin main 

