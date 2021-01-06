html=$(cat header.txt)
footer=$"</body>\n</html>"

for file in md/*
do
	name=${file:12}
	name=$(basename "$name" ".md")
	file=$(echo "$name" | sed -e 's/\(.*\)/\L\1/')
	file=$(echo "$name" | sed -e 's/\s/_/g')
	footer=$(printf "<a href=\"${file}\">${name}</a><br>\n${footer}")
	pandoc -s "$file" -o "${file}.html"
done

html+=$footer
echo "$html" > index.html
git add --all
git commit -m "`date`"
git push -u origin main 

