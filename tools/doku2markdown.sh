#!/bin/bash
#
# 2016-11-04 
# doku2markdown.sh
#
# 将dokuwiki标签替换成markdown标签
#


# DOKU_PAGE=$PATH/pages

[ "X$DOKU_PAGE" != "X" ] && cd $DOKU_PAGE

find ./ -type f  -name "*.txt"| xargs dos2unix  > /dev/null

# 转换标题
find ./ -type f  -name "*.txt" | xargs sed -i -e 's/^======/#/' -e 's/======$//'
find ./ -type f  -name "*.txt" | xargs sed -i -e 's/^=====/##/' -e 's/=====$//'
find ./ -type f  -name "*.txt" | xargs sed -i -e 's/^====/###/' -e 's/====$//'
find ./ -type f  -name "*.txt" | xargs sed -i -e 's/^===/####/' -e 's/===$//'
find ./ -type f  -name "*.txt" | xargs sed -i -e 's/^==/#####/' -e 's/==$//'
find ./ -type f  -name "*.txt" | xargs sed -i -e 's/^=/######/' -e 's/=$//'

# 转换代码
find ./ -type f  -name "*.txt" |xargs sed -i 's/<sxh \([a-zA-Z0-9]*\).*/\n```\1/'
find ./ -type f  -name "*.txt" | xargs sed -i 's/<sxh>/\n```bash/' 
find ./ -type f  -name "*.txt" | xargs sed -i 's/<\/sxh>/```\n/' 

# 转换横线
find ./ -type f -name "*.txt" | xargs sed -i 's/----/\n----/p'


# 2016-11-04

# 删除 字体 <fs> 标签
find ./ -type f |xargs sed -i -e 's#</fs>##' -e 's#<fs.*>##'   
find ./ -type f |xargs sed -i -e 's#</fc>##' -e 's#<fc.*>##'   

# 删除颜色 <color> 标签
find ./ -type f |xargs sed -i -e 's#</color>##' -e 's#<color.*>##'   

# 删除标签
find ./ -type f |xargs sed -i  -e 's#\\##g'

# 替换代码区间
find ./ -type f |xargs sed -i -e 's#</sxh>#```#' -e 's#<sxh bash.*>#```bash#' 
find ./ -type f |xargs sed -i -e 's#</sxh>#```#' -e 's#<sxh>#```bash#' 
find ./ -type f |xargs sed -i -e 's#</sxh>#```#' -e 's#<sxh python.*>#```python#' 
find ./ -type f |xargs sed -i -e 's#</sxh>#```#' -e 's#<sxh php.*>#```php#' 
find ./ -type f |xargs sed -i -e 's#</sxh>#```#' -e 's#<sxh sql.*>#```sql#' 
# 增加空行
find ./ -type f |xargs sed -i -e 's/```.*/\n&\n/'

# 删除TAG 标签
find ./ -type f |xargs sed -i -e 's#{{tag.*}}##' 


# 替换超级链接
find ./ -type f |xargs sed -i -e 's#\[\[\(.*\)|\(.*\)\]\] *|#[\2](\1)|#g'
find ./ -type f |xargs sed -i -e 's#\[\[\(.*\)|\(.*\)\]\]#[\2](\1)#g'

