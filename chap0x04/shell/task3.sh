#!/usr/bin/env bash
function help {
    echo "=========================这是帮助文档========================="
    echo "-t                 ----统计访问来源主机TOP 100和分别对应出现的总次数"
    echo "-i                 ----统计访问来源主机TOP 100 IP和分别对应出现的总次数"
    echo "-u                 ----统计最频繁被访问的URL TOP 100"
    echo "-r                 ----统计不同响应状态码的出现次数和对应百分比"
    echo "-4                 ----分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
    echo "-p url             ----给定URL输出TOP 100访问来源主机"               
    echo "-h                 ----帮助文档"
}

function top100_host {
    printf "%s\t%46s\n" "top100主机名" "次数"
    awk -F "\t" '
    NR>1 {
        host[$1]++;
    }
    END {
        for(i in host){
            printf("%-50s\t%d\n",i,host[i]);
        }
    }' web_log.tsv | sort -g -k 2 -r | head -100
}

function top100_ip {
    printf "%s\t%14s\n" "top100IP地址" "次数"
    awk -F "\t" '
    NR>1 {
        if(match($1, /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/)){
            ip[$1]++;
        }
    }
    END {
        for(i in ip){
            printf("%-20s\t%d\n",i,ip[i])
        }
    }' web_log.tsv | sort -g -k 2 -r | head -100
}

function top100_url {
    printf "%s\t%46s\n" "top100_url" "次数"
    awk -F "\t" '
    NR>1 {
        url[$5]++;
    }
    END {
        for(i in url){
            printf("%-50s\t%d\n",i,url[i]);
        }
    }' web_log.tsv | sort -g -k 2 -r | head -100
}

function response {
    awk -F "\t" '
    BEGIN {
        printf("状态码\t次数\t百分比\n");
    }
    NR>1 {
        response[$6]++;
    }
    END {
        for(i in response){
            printf("%d\t%d\t%f%%\n",i,response[i],response[i]*100/(NR-1));
        }
    }' web_log.tsv
}

function 4xxresponse {
    printf "%s\t%46s\n" "状态码=403的url" "次数"
    awk -F "\t" '
    NR>1 {
        if($6==403){
            url[$5]++;
        }
    }
    END {
        for(i in url){
            printf("%-50s\t%d\n",i,url[i]);
        }
    }' web_log.tsv | sort -g -k 2 -r | head -10

     printf "%s\t%46s\n" "状态码=404的url" "次数"
    awk -F "\t" '
    NR>1 {
        if($6==404){
            url[$5]++;
        }
    }
    END {
        for(i in url){
            printf("%-50s\t%d\n",i,url[i]);
        }
    }' web_log.tsv | sort -g -k 2 -r | head -10
}

function inputurl {
    printf "%s\t%45s\n" "top100主机名" "次数"
    awk -F "\t" '
    NR>1 {
        if("'"$1"'"==$5){
            host[$1]++;
        }
    }
    END {
        for(i in host){
            printf("%-50s\t%d\n",i,host[i]);
        }
    }' web_log.tsv | sort -g -k 2 -r | head -100
}



while true; do
    case "$1" in
    "-t")
    top100_host
    exit 0
    ;;
    "-i")
    top100_ip
    exit 0
    ;;
    "-u")
    top100_url
    exit 0
    ;;
    "-r")
    response
    exit 0
    ;;
    "-4")
    4xxresponse
    exit 0
    ;;
    "-p")
    inputurl "$2"
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
