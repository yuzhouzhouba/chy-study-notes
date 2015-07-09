#!/bin/bash
#Program:
#	A script of pigeonholing 
#History:
#2015/1/6 16:56 start
#2015/1/18 11:30 substantially completed
#2015/1/20 16:30 start adding report file
#2015/1/30 17:23 add the pigeonholing of the files with similar string 

function min()
{
    m=$1
    if [ $m -gt $2 ];then
	m=$2
    fi
    if [ $m -gt $3 ];then
	m=$3
    fi 
    return $m;
}

function similar_text()
{
    len1=$(expr length $1)
    len2=$(expr length $2)
    if [ $len1 -gt $len2 ];then
	longStr=$1
	shortStr=$2
	longLen=$len1
	shortLen=$len2
    else
	longStr=$2
	shortStr=$1
	longLen=$len2
	shortLen=$len1
    fi
declare -a dist1
 for((j=2;$j<=$longLen+1;j=$j+1))
do
dist1[$j]=$(($j-1))
done
dist1[1]=0
declare -a newdist
for ((i=0;$i<=$shortLen-1;i=$i+1))
do
newdist[1]=$(($i+1))
for ((j=0;$j<=$longLen-1;j=$j+1))
do
a=$(echo ${longStr:$j:1})
b=$(echo ${shortStr:$i:1})
if [ "$a" == "$b" ];then
min $((${dist1[$j+1]})) $((${newdist[$j+1]}+1)) $((${dist1[$j+2]}+1))
newdist[$j+2]=$?
else
min $((${dist1[$j+1]}+1)) $((${newdist[$j+1]}+1)) $((${dist1[$j+2]}+1))
newdist[$j+2]=$?
fi
done
for((k=1;$k<=$longLen+1;k=$k+1))
do
dist1[$k]=${newdist[$k]}
done
done
result=${dist1[$longLen+1]}
result1=$(echo "scale=3; $result/$longLen" | bc | awk '{printf "%.3f", $0}' )
result2=$(echo "scale=3; $result/$shortLen" | bc | awk '{printf "%.3f", $0}' )
if [ $result1 -gt $result2 ];then
echo $result2 $result >similar_text.txt
else
echo $result1 $shortStr >similar_text.txt
fi
}

echo -e "#History: \nStart time:">>Pigeonhol_History.txt
date '+%Y-%m-%d %T'>>Pigeonhol_History.txt
echo -e "\n">>Pigeonhol_History.txt
#Overall environment variable
PATH=${PATH}
export PATH
LANG=C
#Last check time
LCT=2015-03-03+16:25:12
#Usual file type
dirtemp="Music PDFfile Office Textfile Video Picture Mirror Web BTfile Archive"

#Usual file extensions
Musicex="mp3 wma ape flac aac mmf amr m4a m4r ogg wav wv mp2 MP3 WMA APE FLAC AAC MMF AMR M4A M4R OGG WAV WV MP2"
PDFfileex="pdf PDF"
Officeex="doc dot ppt pot xls xlt docx dotx pptx potx xlsx xltx DOC DOT PPT POT XLS XLT DOCX DOTX PPTX POTX XLSX XLTX"
Textfileex="txt sh"
Videoex="rm rmvb mp4 avi 3gp gif wmv mkv mpg vob mov flv swf RM RMVB MP4 AVI 3PG GIF WMV MKV MPG VOB MOV FLV SWF"
Pictureex="jpg png ico bmp gif tif pcx tga JPG PNG ICO BMP GIF TIF PCX TGA"
Mirrorex="iso cso ISO CSO"
Webex="htm html shtml stm shtm asp HTM HTML SHTML STM SHTM ASP"
BTfileex="torrent TORRENT"
Archiveex="zip rar 7z cab ZIP RAR 7Z CAB"
#Current directory
dir=$(pwd)

#This Time
Time=$(date '+%Y-%m-%d+%T')
TTime=$(echo $Time|awk -F '+' '{print $1" "$2}' )

#Create directories for files
for a in $dirtemp
do
if [ ! -x "\.\/$a\/" ];then
mkdir $a
else
echo "Please using the adminID to execute this scirpt ^.^"
exit 1
fi
done

#Check the change time of file
List=
ls|grep -v -n '^$' > Pigeonhole_Temp.txt
cf=$(stat * |grep 'Modify:'|awk  '{print $2"+"$3}'|awk -F '.' '{print $1}' )
b=1
for a in $cf
do
if [ "$a" != "$LCT" ];then
L=$(grep "^${b}:" "Pigeonhole_Temp.txt"|awk -F ':' '{print $2}')
List="$List""$L "
fi
b=$(($b+1)) 
done

#Name of directories
dirlist=$(file $List|grep -v -n '^$'|sed s/[[:space:]]//g |awk -F ':' '{if ($NF=="directory")print $1":"$2}')

#Names of file
filelist=$(file $List|grep -v -n '^$'|sed s/[[:space:]]//g |awk -F ':' '{if ($NF!="directory")print $1":"$2}')
file $List|grep -v -n '^$'|sed s/[[:space:]]//g |awk -F ':' '{if ($NF!="directory")print $1":"$2}' >Pigeonhole_filelist.txt
#NO Extension file
next=$(file $List|grep -v -n '^$'|sed s/[[:space:]]//g |awk -F ':' '{if ($NF!="directory")print $1":"$2}'|grep -v '\.')

#Existing Extension file
ext=$(file $List|grep -v -n '^$'|sed s/[[:space:]]//g |awk -F ':' '{if ($NF!="directory")print $1":"$2}'|grep '\.'|sed s/:[^.]*\./:/g)
#sleep 400
#Extensions file sort out

for a in ${ext}
do
#Get the real extension and Correspondencing Line
echo $a > Pigeonhole_Temp.txt
rext=$(awk -F ':' '{print $2}' Pigeonhole_Temp.txt)
#Real extension
lext=$(awk -F ':' '{print $1}'  Pigeonhole_Temp.txt)
#Line number of suffix
for b in ${dirtemp}
do
c=${b}ex

d=$(eval echo \$$c)
for e in $d
do

if [ "$rext" == "$e" ];then
filename=$(grep "^${lext}:" "Pigeonhole_filelist.txt"|awk -F ':' '{print $2}')
if [ "$filename" != "guidang.sh" -a "$filename" != "Pigeonhole_Temp.txt" -a "$filename" != "Pigeonhole_filelist.txt" -a "$filename" != "Pigeonhole_History.txt" ];then
mv -nv $filename ./$b>>Pigeonhole_History.txt
touch -d "$TTime" ./$b/$filename
fi
fi
done
done
done


#Final arrange
sed -i "s/^LCT=.*/LCT=${Time}/g" $dir/guidang.sh

rm Pigeonhole_filelist.txt Pigeonhole_Temp.txt
echo -e "\n">>Pigeonhole_History.txt 

#Archive similar_file Pigeonholing
list=$(ls ./Archive)
list1=$(ls ./Archive)
for a in $list
do
lsit1=$(echo $list1 |sed  "s/${b}//g")
for b in $list1
smilar_text $a $b
d=$(awk '{print $1}' similar_text.txt)
d=$(expr $d \> 0.333)
if [ $d -eq 0 ];then
e=$(awk '{print $2}' similar_text.txt)
makdir ./Archive/Similar_${e}_Archive
echo -e "About The Archive Pigeonholing:\n">>Pigeonhole_History.txt
mv -nv ./Archive/$b ./Archive/Similar_${e}_Archive>>Pigeonhole_History.txt
lsit=$(echo $list |sed  "s/${b}//g")
lsit1=$(echo $list1 |sed  "s/${b}//g")
fi
done
done
echo -e "The end time:">>Pigeonhole_History.txt
date '+%Y-%m-%d %T'>>Pigeonhole_History.txt
echo -e "\n\n\n">>Pigeonhole_History.txt
exit 0
