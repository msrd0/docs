#!/bin/bash
set -euo pipefail

user="msrd0"
base_url="https://crates.io/api/v1"
crates_io_index="https://github.com/rust-lang/crates.io-index/raw/master/"

function http_get() {
	# on ArchLinux, wget does not support https so we can't use it
	# on AlpineLinux, they've patched it to do certificate validation and enabled
	#                 https, but also it is symlinked to /usr/bin so this works as well
	/usr/bin/wget -q -O - -U "wget; bot (contact: git at msrd0 dot de)" "${@}"
}

user_id="$(http_get "$base_url/users/msrd0" | jq -r '.user.id')"

function get_crates() {
	per_page=10
	response="$(http_get "$base_url/crates?include_yanked=n&page=1&per_page=$per_page&sort=alpha&user_id=$user_id")"
	printf "%s" "$response" | jq -r '.crates[].id'
	total=$(printf "%s" "$response" | jq -r '.meta.total')
	
	idx=$per_page
	page=2
	while [ $idx -lt $total ]; do
		http_get "$base_url/crates?include_yanked=n&page=$page&per_page=$per_page&sort=alpha&user_id=$user_id" | jq -r '.crates[].id'
		idx=$((idx + per_page))
		page=$((page + 1))
	done
}
crates="$(get_crates)"

function hash_dir() {
	find "$1" -type f \
		| LC_ALL=C sort \
		| while read file; do echo "$(b3sum -l 12 --no-names "$file")  $(realpath --relative-to="$1" "$file")" ; done \
		| b3sum -l 12 --no-names
}

echo -n "# Crate Documentation " >README.md
echo '[![Build Status](https://drone.msrd0.eu/api/badges/msrd0/docs/status.svg?ref=refs/heads/main)](https://drone.msrd0.eu/msrd0/docs)' >>README.md
echo "Rust Documentation for all of my crates" >>README.md

cat >_site/index.html <<EOF
<!DOCTYPE HTML>
<html lang="en">
<head>
	<title>Crate Documentation</title>
	<meta charset="utf-8">
	<link rel="stylesheet" href="https://msrd0.de/style.css" />
	<link rel="stylesheet" href="https://msrd0.de/docs.css" />
</head>
<body>
	<div id="bg"></div>

	<div id="top">
		<a href="https://msrd0.de/datenschutz.html">Privacy</a>
	</div>

	<div id="container">
		<main>
			<div class="header">
				<h1>Crate Documentation</h1>
				<a href="https://drone.msrd0.eu/msrd0/docs">
					<img src="https://drone.msrd0.eu/api/badges/msrd0/docs/status.svg?ref=refs/heads/main" alt="Build Status" />
				</a>
			</div>
			<div id="grid">
EOF

cat >_config.yml <<EOF
safe: true
keep_files:
  - index.html
  - assets
  - dependencies
  - sources
EOF
mkdir -p _site/assets _site/dependencies _site/sources

for crate in $crates; do
	crate_escaped=$(printf "%s" $crate | tr '-' '_')
	echo -e "\e[1m => Updating crate $crate ...\e[0m"

	description="$(http_get "$base_url/crates/$crate" | jq -r '.crate.description')"
	echo >>README.md
	echo "## $crate [![$crate on crates.io](https://img.shields.io/crates/v/$crate.svg)](https://crates.io/crates/$crate) ![downloads](https://img.shields.io/crates/d/$crate.svg)" >>README.md
	echo "$description" >>README.md
	echo "  - $crate" >>_config.yml
	cat >>_site/index.html <<EOF
				<div class="header" id="$crate">
					<h2>$crate</h2>
					<a href="https://crates.io/crates/$crate">
						<img src="https://img.shields.io/crates/v/$crate.svg" alt="$crate on crates.io"/>
					</a>
					<img src="https://img.shields.io/crates/d/$crate.svg"/>
				</div>
				<p class="description">$description</p>
EOF
	
	test -d _site/$crate || mkdir _site/$crate
	if [ "${#crate}" == 3 ]; then
		response="$(http_get "$crates_io_index/3/${crate:0:1}/$crate")"
	else
		response="$(http_get "$crates_io_index/${crate:0:2}/${crate:2:2}/$crate")"
	fi
	versions="$(printf "%s" "$response" | jq -r 'select(.yanked == false) | .vers' | tac)"
	
	for vers in $versions; do
		echo " - Version $vers: [Documentation](_site/$crate/$vers/$crate_escaped/index.html)" >>README.md
		echo "				<div class=\"version\">Version $vers</div>" >>_site/index.html
		echo "				<a href=\"./$crate/$vers/$crate_escaped/index.html\">Documentation</a>" >>_site/index.html
		
		if [ ! -d _site/$crate/$vers ]; then
			echo -e "\e[1m  -> Documenting version $vers ...\e[0m"
			
			tmp=$(mktemp -d)
			http_get "$base_url/crates/$crate/$vers/download" | tar x -z -f - -C $tmp
			dir="$tmp/$crate-$vers"
			
			args="--manifest-path $dir/Cargo.toml"
			if [ -f $tmp/Cargo.lock ]; then
				args="$args --locked"
			fi
			
			features=($(printf "%s" "$response" | jq -r 'select(.vers == "'$vers'") | .features | to_entries[] | .key'))
			if [[ ${features[*]} =~ tokio ]] || [[ ${features[*]} =~ async[\-_]std ]] || [[ ${features[*]} =~ hyper ]]; then
				# we want to make very sure not to enable tokio and async-std based stuff at the same time
				true
			elif [[ ${features[*]} =~ (^|[[:space:]])full([[:space:]]|$) ]]; then
				args="$args --no-default-features --features full"
			else
				args="$args --all-features"
			fi
			
			bash -exuc "RUSTDOCFLAGS='--default-theme ayu -A renamed_and_removed_lints' cargo doc $args"
			
			mv $dir/target/doc _site/$crate/$vers
			rm -rf $tmp

			echo -e "\e[1m  -> Extracting assets of version $vers ...\e[0m"
			rm _site/$crate/$vers/.lock
			find _site/$crate/$vers/ -maxdepth 1 -type f | while read file; do
				hash=$(b3sum -l 12 --no-names "$file")
				asset=_site/assets/$hash
				test -f $asset || cp "$file" $asset
				rm "$file"
				ln -s ../../assets/$hash "$file"
			done

			echo -e "\e[1m  -> Extracting dependencies of version $vers ...\e[0m"
			find _site/$crate/$vers -maxdepth 2 -name index.html -not -path "*/$crate_escaped/index.html" | while read file; do
				dir="$(dirname "$file")"
				hash=$(hash_dir "$dir")
				dep="$(basename "$dir")-$hash"
				test -d "_site/dependencies/$dep" || cp -R "$dir" "_site/dependencies/$dep"
				rm -rf "$dir"
				ln -s "../../dependencies/$dep" "$dir"
			done
			find _site/$crate/$vers/src -mindepth 1 -maxdepth 1 -type d -not -name $crate_escaped | while read dir; do
				hash=$(hash_dir "$dir")
				src="$(basename "$dir")-$hash"
				test -d "_site/sources/$src" || cp -R "$dir" "_site/sources/$src"
				rm -rf "$dir"
				ln -s "../../../sources/$src" "$dir"
			done

			git add _site/$crate/$vers _site/{assets,dependencies,sources}
			git commit -q -m "add documentation for $crate $vers" \
				--author "drone-msrd0-eu[bot] <noreply@drone.msrd0.eu>"
			git push "https://$GITHUB_TOKEN@github.com/msrd0/docs"
		fi
	done
done

cat >>_site/index.html <<EOF
			</div>
		</main>
	</div>
</body>
</html>
EOF

if ! git diff --exit-code _site/index.html README.md _config.yml &>/dev/null;  then
	git add _site/index.html README.md _config.yml 
	git commit -q -m "update readme and config" \
		--author "drone-msrd0-eu[bot] <noreply@drone.msrd0.eu>"
	git push "https://$GITHUB_TOKEN@github.com/msrd0/docs"
fi

# there shouldn't be any changed files left over
git status
git diff --exit-code
