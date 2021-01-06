html=$(cat header.txt)
footer="</body></html>"

for file in md/*
do
	name=${file:12}
	name=$(basename "$name" ".md")
	footer=$(echo "<a href=\"${aux}\">${name}</a><br>${footer}")
	name=$(echo "$name" | sed -e 's/\(.*\)/\L\1/')
	name=$(echo "$name" | sed -e 's/\s/+/g')
	pandoc -s "$file" -o "${name}.html"
done

html+=$footer
echo "$html" > index.html
git add --all
git commit -m "`date`"
git push -u origin main 

