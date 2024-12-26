---
title: kill -9, lecture II
date: 2005-10-04 17:11:00.00 -8
---
```shell
#cd /var/foo/bar
#ls
CTRL-X
#rm -f *
bash: /bin/rm: Argument list too long
#fuck
-bash: fuck: command not found
#for i in *
#do
#rm $i
done
```
And the also-handy closer:

```shell
#mount -o remount,rw /
