#!/bin/bash
#delete误操作后的数据修复
#必须先从binlog中抽取出相应的日志到文件,文件名如：logfilename

#1.先执行:
sed -i -e 's/### //' -e 's/DELETE FROM/INSERT INTO/'  logfilename

#2.
sed -i '/INSERT INTO/{n;s/WHERE/VALUES(/}' logfilename

#3.先修改最后一列,示例为第26列:
sed -i -r 's/ @26=(.*)/\1);/' logfilename

#4.再修改其余列,示例为第1-25列:
sed -i -r 's/ @[0-9]+=(.*)/\1,/' logfilename


