#!/usr/bin/env bash
function help {
    echo "=========================这是帮助文档========================="
    echo "-q Q               ----进行图片质量压缩"
    echo "-r R               ----对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩成R分辨率"
    echo "-w font_size text  ----对图片批量添加自定义文本水印"
    echo "-p text            ----统一添加文件名前缀，不影响原始文件扩展名"
    echo "-s text            ----统一添加文件名后缀，不影响原始文件扩展名"
    echo "-t                 ----将png/svg图片统一转换为jpg格式图片"
    echo "-h                 ----帮助文档"
}

#convert filename1 -quality Q filename2
function QualityCompression {
    Q="$1" #获取质量因子
    for i in *; do
        type=${i##*.} #获取文件后缀
        if [[ ${type} != "jpeg" ]];then continue;fi #判断是否为jpeg文件
        convert "${i}" -quality "${Q}" "${i}"
        echo "${i}已经进行质量压缩"
    done  
}

# convert filename1 -resize R filename2
function ResolutionCompression {
    R="$1" #获取压缩分辨率
    for i in *; do
        type=${i##*.} #获取文件后缀
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]];then continue;fi
        convert "${i}" -resize "${R}" "${i}"
        echo "${i}已经压缩为${R}分辨率"
    done
}

#convert -draw "text 0,0 'text'" -fill red -pointsize font_size -gravity NorthWest filename1 filename2
function TextWatermark {
    font_size="$1" #获取文本大小
    text="$2" #获取文本内容
    for i in *; do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]];then continue;fi
        convert -draw "text 0,0 '${text}'" -fill red -pointsize "${font_size}" -gravity NorthWest "${i}" "${i}"
        echo "${i}已经加入文本水印" 
    done
}

#mv filename1 filename2
function AddPrefix {
    text="${1}"
    for i in *; do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]];then continue;fi
        mv "${i}" "${text}""${i}"
        echo "${i}已经添加前缀${text}"
    done
}
function AddSuffix {
    text="${1}"
    for i in *; do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]];then continue;fi
        filename2=${i%.*}${text}"."${type}
        mv "${i}" "${filename2}"
        echo "${i}已经添加后缀${text}"
    done
}

#convert xxx.png xxx.jpg
function ConvertFormat {
    for i in *; do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "svg" ]];then continue;fi
        new_file=${i%%.*}".jpg"
        convert "${i}" "${new_file}"
        echo "${i}已经转换为jpg格式"
    done
}

while true; do
    case "$1" in
    "-q")
    QualityCompression "$2"
    exit 0
    ;;
    "-r")
    ResolutionCompression "$2"
    exit 0
    ;;
    "-w")
    TextWatermark "$2" "$3"
    exit 0
    ;;
    "-p")
    AddPrefix "$2"
    exit 0
    ;;
    "-s")
    AddSuffix "$2"
    exit 0
    ;;
    "-t")
    ConvertFormat
    exit 0
    ;;
    "-h")
    help
    exit 0
    ;;
    esac
help
exit 0
done
