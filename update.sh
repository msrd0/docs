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

echo -n "# Crate Documentation " >README.md
echo '[![Build Status](https://drone.msrd0.eu/api/badges/msrd0/docs/status.svg?ref=refs/heads/main)](https://drone.msrd0.eu/msrd0/docs)' >>README.md
echo "Rust Documentation for all of my crates" >>README.md

for crate in $crates; do
	echo -e "\e[1m => Updating crate $crate ...\e[0m"

	echo >>README.md
	echo "## $crate [![$crate on crates.io](https://img.shields.io/crates/v/$crate.svg)](https://crates.io/crates/$crate) ![downloads](https://img.shields.io/crates/d/$crate.svg)" >>README.md
	
	test -d $crate || mkdir $crate
	response="$(http_get "$crates_io_index/${crate:0:2}/${crate:2:2}/$crate")"
	versions="$(printf "%s" "$response" | jq -r 'select(.yanked == false) | .vers')"
	
	for vers in $versions; do
		echo " - Version $vers: [Documentation]($crate/$vers/$crate/index.html)" >>README.md
		
		test ! -d $crate/$vers || continue
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
		
		mv $dir/target/doc $crate/$vers
		rm -rf $tmp

		git add $crate/$vers
		git commit -q -m "add documentation for $crate $vers" \
			--author "drone-msrd0-eu[bot] <noreply@drone.msrd0.eu>"
		git push "https://$GITHUB_TOKEN@github.com/msrd0/docs"
	done
done

git add -A
git commit -q -m "update readme" \
	--author "drone-msrd0-eu[bot] <noreply@drone.msrd0.eu>"
git push "https://$GITHUB_TOKEN@github.com/msrd0/docs"
