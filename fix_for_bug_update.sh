#!/bin/bash
#update误操作后的数据修复
#必须先从binlog中抽取出相应的日志到文件,文件名如：logfilename

#1.先执行:
sed -i -e 's/WHERE/set/' -e 's/SET/where/' -e 's/### //' logfilename

#2.修改,以更正set后的列名,并保证其后面正确跟随符号","(set的最后一列不跟)：
#示例(还原第1、2列,因第1列唯一,而第2列被误修改):
sed -i -r '/set/{:1;n;/@1=/{s/@1=(.*)/id=\1,/;b};b1}' logfilename
sed -i -r '/set/{:1;n;/@2=/{s/@2=(.*)/prodid=\1/;b};b1}' logfilename

#3.修改,以更正where后的列名,并保证其后面正确跟随"and"(where的最后一列不跟)：
#示例(以第1、2列值作为条件):
sed -i -r '/where/{:1;n;/@1=/{s/@1=(.*)/id=\1 and/;b};b1}' logfilename
sed -i -r '/where/{:1;n;/@2=/{s/@2=(.*)/prodid=\1;/;b};b1}' logfilename

#4.删除多余的行(即没必要修改的行),也就是包含@且其后面跟随数字然后是"="的行：
sed -i -r '/@[0-9]+=/d' logfilename
