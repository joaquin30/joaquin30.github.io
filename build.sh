#!/bin/sh

get_stars()
{
	num_starf=$1
	num_star=$((5 - $1))
	stars=
	while [ "$num_starf" -gt 0 ]
	do
		stars=$stars"&starf;"
		num_starf=$((num_starf - 1))
	done
	
	while [ "$num_star" -gt 0 ]
	do
		stars=$stars"&star;"
		num_star=$((num_star - 1))
	done
	
	echo $stars
}

create_html()
{
	sdate=$(echo "$1" | awk '{print substr($0,8,8);}')
	sdate=$(date -d "$sdate" "+%d de %B de %Y")
	stars=$(echo "$1" | awk '{print substr($0,17,1);}')
	stars=$(get_stars "$stars")
	name=$(echo "$1" | awk '{print substr($0,19);}')
	name=$(basename "$name" .md)
	aux=$(echo "$name" | sed -e 's/\(.*\)/\L\1/' | tr " " _)
	echo "<!doctype html>
<html lang=\"es\">
<head>
<meta charset=\"utf-8\" />
<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />
<title>$name</title>
<link rel=\"stylesheet\" href=\"../src/style.css\" />
<link rel=\"icon\" href=\"../img/favicon.png\" />
</head>
<body>
<header>
<div class=\"head\">
<h2>🍿 La cloroteca</h2>
<a href=\"../index.html\">⤶ Volver al inicio</a>
</div>
<hr />
</header>
<h1>$name</h1>
<h2>$stars</h2>
<h3>$sdate</h3>
<p><img src=\"../img/$aux.jpg\" title=\"Poster de la película\" /></p>
<p><strong>Advertencia de <em>spoilers</em></strong></p>
$(pandoc "$1")
</body>
</html>" > "post/$aux.html"
}

create_files()
{
	rm post/*.html
	html_header=$(cat src/header.html)
	
	html_footer="</ul>
</body>
</html>"
	
	rss_header="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<rss version=\"2.0\">
<channel>
<title>La cloroteca</title>
<link>https://joaquin30.github.io</link>
<description>Críticas sobre películas de Claro Video</description>"
	
	rss_footer="</channel>
</rss>"

	for file in src/md/*
	do

		name=$(echo "$file" | awk '{print substr($0,19);}')
		name=$(basename "$name" .md)
		aux=$(echo "$name" | sed -e 's/\(.*\)/\L\1/' | tr " " _)
		
		html_footer="<li><a href=\"post/$aux.html\">$name</a></li>
${html_footer}"
		
		rss_footer="<item>
<title>$name</title>
<link>https://joaquin30.github.io/post/$aux.html</link>
<description>Crítica de la película \"$name\"</description>
</item>
${rss_footer}"
		
		create_html "$file"
	done

	html_header=$html_header$html_footer
	echo "$html_header" > index.html
	rss_header=$rss_header$rss_footer
	echo "$rss_header" > rss.xml
}

upload()
{
	git add --all
	git commit -m "$(date)"
	git push -u origin main
}

create_files
upload
