#!bin/bash
#
#  filename: youdaodict.sh
#  查询单词解释
#


# @brief 构词，空格转换
my_word=$@
for word in $my_word
do
    var_word=$var_word$word'%20'
done


var_dict_url=http://dict.youdao.com/w/eng/${var_word}/

# @brief 短语和单词通用
function common()
{
    echo -e "$my_word :"
    curl -s $var_dict_url | grep -oP '\<li\>[ [:alpha:]].*.*\</li\>'  | sed 's/<li>\(.*\)<\/li>/    \1/' | sort | uniq
    echo ""
}

# @brief 用户提示
function usage()
{
    echo -e "Usage: \n  $0 [word|phrase]"
    echo ""
}

clear

case $# in 
0) usage  ;;
*) common ;;
esac



