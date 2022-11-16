#auth=账号：密码
auth=transmission:transmission
#host=路由ip地址：端口
host=192.168.1.1:9091
tips="No active torrent"
app=/usr/sbin/transmission-remote
#本文件，tracker.txt和transmission-remote存放位置
basefdr=/mnt/hdd/transplus
apx=$basefdr/transmission-remote
trackerslist=$basefdr/trackers.txt

add_trackers() {
	torrent_hash=$1
	id=$2
	if [ -f $trackerslist ]; then
		for tracker in $(cat $trackerslist) ; do
			if $app "$host"  --auth="$auth" --torrent "${torrent_hash}" -td "${tracker}" | grep -q 'success'; then
			    echo ' skiped.'
			else
			    echo ' added .'
			fi
		done
	else
	    echo "trackers.txt lost" $trackerslist
	fi
}

if [ ! -f "$app" ]; then
	cp $apx $app
	chmod 777 $app
fi

ids="$($app "$host"  --auth="$auth" --list | grep -vE 'Seeding|Stopped|Finished|[[:space:]]100%[[:space:]]' | grep '^ ' | awk '{ print $1 }')"
for id in $ids ; do
	    hash="$($app "$host"  --auth="$auth" --torrent "$id" --info | grep '^  Hash: ' | awk '{ print $2 }')"
	    torrent_name="$($app "$host"  --auth="$auth" --torrent "$id" --info | grep '^  Name: ' |cut -c 9-)"
	    echo $(date "+%Y-%m-%d %H:%M:%S")" - Adding trackers for $torrent_name..."
		    add_trackers "$hash" "$id"
	    tips="done"
done

echo $tipsdone
done

echo $tipss
