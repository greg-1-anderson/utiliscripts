testfolder=ts

rm -rf $testfolder

#mkdir -p $testfolder/history/hourly
mkdir -p $testfolder/history/daily
mkdir -p $testfolder/history/weekly
mkdir -p $testfolder/history/monthly

for testmonth in 01 02 03 04 05 06 07 08 09 10 11 12; do
  for testday in 01 02 04 05 07 08 09 10 11 12 14 18 19 20 24 28 ; do
    testhour=$((112 - 1$testmonth))
    testminute=$((159 - 1$testday))
    testdate="2013-$testmonth-$testday $testhour:$testminute"
    echo $testdate
    touch --date="$testdate" "$testfolder/test.sql"
    migratehistories --quiet --migrating "$testfolder/test.sql" --history-root "$testfolder/history" --target-extension .sql
  done
done
find $testfolder | sort > /tmp/actualresult.txt
cat << __EOF__ > /tmp/expectedresult.txt
ts
ts/history
ts/history/daily
ts/history/daily/2013-12-24_00:35.sql
ts/history/daily/2013-12-28_00:31.sql
ts/history/monthly
ts/history/monthly/2013-06-24_06:35.sql
ts/history/monthly/2013-07-28_05:31.sql
ts/history/monthly/2013-09-01_03:58.sql
ts/history/monthly/2013-10-10_02:49.sql
ts/history/monthly/2013-11-12_01:47.sql
ts/history/quarterly
ts/history/quarterly/2013-01-01_11:58.sql
ts/history/quarterly/2013-05-20_07:39.sql
ts/history/weekly
ts/history/weekly/2013-11-20_01:39.sql
ts/history/weekly/2013-11-28_01:31.sql
ts/history/weekly/2013-12-10_00:49.sql
ts/history/weekly/2013-12-20_00:39.sql
__EOF__
diff -Nup /tmp/expectedresult.txt /tmp/actualresult.txt > /tmp/diffresult.txt

if [ -s /tmp/diffresult.txt ] ; then
  echo "*** TEST FAILED ****"
  cat /tmp/diffresult.txt
else
  echo "Test passed"
fi
