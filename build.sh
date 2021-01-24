#!/bin/sh
for file in src/origin/*
do
	name=${file:11}
	name=$(basename "$name" ".png")
	name=$(basename "$name" ".jpg")
	name=$(basename "$name" ".jpeg")
	convert "$file" -quality 50 -resize 480 "img/${name}.webp"
done

rm post/*.html
html_header=$(pandoc -s --css=style.css -V lang=es -V highlighting-css= --mathjax --to=html5 src/header.md)
html_header=${html_header::-15}
html_footer=$(printf "</ul>\n</body>\n</html>")
rss_header=$(printf "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n<rss version=\"2.0\">\n<channel>\n  <title>La cloroteca</title>\n  <link>https://joaquin30.github.io</link>\n  <description>Críticas sobre películas de Claro Video</description>\n")
rss_footer=$(printf "</channel>\n</rss>")

for file in src/md/*
do
	name=${file:16}
	name=$(basename "$name" ".md")
	aux=$(echo "$name" | sed -e 's/\(.*\)/\L\1/')
	aux=$(echo "$aux" | sed -e 's/\s/_/g')
	html_footer=$(printf "<li><a href=\"post/${aux}.html\">${name}</a></li>\n${html_footer}")
	rss_footer=$(printf "  <item>\n    <title>${name}</title>\n    <link>https://joaquin30.github.io/post/${aux}</link>\n    <description>Crítica de la película \"${name}\"</description>\n  </item>\n${rss_footer}")
	pandoc -s --css=../style.css -V lang=es -V highlighting-css= --mathjax --to=html5 "$file" -o "post/${aux}.html"
done

html_header+="<ul>"
html_header+=$html_footer
echo "$html_header" > index.html
rss_header+=$rss_footer
echo "$rss_header" > rss.xml
git add --all
git commit -m "`date`"
git push -u origin main 

