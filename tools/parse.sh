DATA=$(cat README.md \
         | grep "^ \*" \
         | sed -E 's/^ \* ([0-9]+-[0-9]+-[0-9]+): (https:\/\/junk.tintagel.pl\/openbsd-daily-([a-z]+)(-.*|\.)txt)\ by @([[:print:]]+)$/\3!\1!\5!\2/' \
         | sort)

LIST=""
for i in $DATA
do
  echo $i
  dir=$(echo $i | cut -d! -f1)
  date=$(echo $i | cut -d! -f2)
  author=$(echo $i | cut -d! -f3)
  url=$(echo $i | cut -d! -f4)
  echo $dir, $date, $author
if echo $LIST | grep -v $dir 2>&1 >/dev/null
then
  cat > reads/$dir/README << __EOF
# OpenBSD-daily: $dir

 * $date: reads by $author ($url)
__EOF
else
  echo " * $date: reads by $author ($url)" >> reads/$dir/README
fi
  echo >> reads/$dir/README

  LIST="$LIST $dir"
done

# cvs -danoncvs@anoncvs.eu.openbsd.org:/cvs -qz3 checkout -D 2017-06-08 src/usr.bin/nc
