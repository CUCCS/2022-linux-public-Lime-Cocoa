#!/usr/bin/env bash
function help {
    echo "=========================这是帮助文档========================="
    echo "-a                 ----统计不同年龄区间范围(20岁以下、[20-30]、30岁以上)的球员数量、百分比"
    echo "-p                 ----统计不同场上位置的球员数量、百分比"
    echo "-n                 ----统计名字最长的球员,名字最短的球员"
    echo "-m                 ----统计年龄最大的球员，年龄最小的球员"
    echo "-h                 ----帮助文档"
}

function AgeRange {
    awk -F "\t" '
        BEGIN {a=0;b=0;c=0;}
        $6!="Age" {
           if($6>=0&&$6<20) {
               a++;
            }
           else if($6<=30) {
               b++;
            }
           else {
               c++;
            }
        }
        END {
            sum=a+b+c;
            printf("年龄\t数量\t百分比\n");
            printf("<20\t%d\t%f%%\n",a,a*100/sum);
            printf("[20,30]\t%d\t%f%%\n",b,b*100/sum);
            printf(">30\t%d\t%f%%\n",c,c*100/sum);
        }' worldcupplayerinfo.tsv
}

function Position {
    awk -F "\t" '
        BEGIN {sum=0;}
        $5!="Position" {
           pos[$5]++;
           sum++;
        }
        END {
            printf("    位置\t数量\t百分比\n")
            for(i in pos){
                printf("%-10s\t%d\t%f%%\n",i,pos[i],pos[i]*100/sum);
            }
        }' worldcupplayerinfo.tsv
}

function name {
    awk -F "\t" '
        BEGIN {max=-1;min=1000;}
        $9!="Player" {
            len=length($9);
            name[$9]=len;
            max=len>max?len:max;
            min=len<min?len:min;
        }
        END {
            for(i in name) {
                if(name[i]==max){
                    printf("名字最长的球员是 %s\n",i);
                }
                else if(name[i]==min){
                    printf("名字最短的球员是 %s\n",i);
                }
            }
        }' worldcupplayerinfo.tsv
}

function MaxMin {
    awk -F "\t" '
        BEGIN {max=-1;min=1000;}
        $6!="Age" {
            age=$6;
            name[$9]=age;
            max=age>max?age:max;
            min=age<min?age:min;
        }
        END {
            for(i in name) {
                if(name[i]==max){
                    printf("年龄最大的球员是 %s 他的年龄为 %d\n",i,max);
                }
                if(name[i]==min){
                    printf("年龄最小的球员是 %s 他的年龄为 %d\n",i,min);
                }
            }
        }' worldcupplayerinfo.tsv
}


while true; do
    case "$1" in
    "-a")
    AgeRange
    exit 0
    ;;
    "-p")
    Position
    exit 0
    ;;
    "-n")
    name
    exit 0
    ;;
    "-m")
    MaxMin
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
