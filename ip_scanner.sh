#!/bin/bash

networkAddress=$1;
hostname=$(hostname);
bitNotation=(0 128 192 224 240 248 252 254 255);
networkIP=$(echo $networkAddress | cut -d '/' -f 1);
cidrMask=$(echo $networkAddress | cut -d '/' -f 2);
cidr=$cidrMask;

i=0; 
while [ $i -lt 4 ]; do

    if [ $(expr $cidrMask / 8) -ne 0 ]; then mask[$i]=8; cidrMask=$(expr $cidrMask - 8);
    else 
        mask[$i]=$cidrMask; 
        if [ $cidrMask -ne 0 ]; then 
            if [ ! "$nonClass" ]; then nonClass=$i; fi
        else 
            if [ ! "$class" ]; then class=$i; fi
        fi
        cidrMask=0;
    fi

    index=${mask[$i]};

    if [ ! "$netmask" ]; then netmask=${bitNotation[$index]};
    elif [ $i -eq 3 ]; then netmask="${netmask}.${bitNotation[$index]}";
    else netmask="${netmask}.${bitNotation[$index]}"; fi

    i=$(expr $i + 1);
done

i=0;
while [ $i -lt 4 ]; do 

oM=$(echo $netmask | cut -d '.' -f $(expr $i + 1));

if [ $oM = "255" ]; then
    if [ ! "$aN" ] && [ ! "$aB" ]; then 
        aN=$(echo $networkIP | cut -d "." -f $(expr $i + 1));
        aB=$aN;
    else
        aN="${aN}.$(echo $networkIP | cut -d "." -f $(expr $i + 1))";
        aB=$aN;
    fi
elif [ "$nonClass" ] && [ $i -eq $nonClass ]; then
    nonClassIpO=$(echo $networkIP | cut -d '.' -f $(expr $nonClass + 1));
    nonClassMaskO=$(echo $netmask | cut -d '.' -f $(expr $nonClass + 1));

    mBinary=$(echo "bin=$nonClassMaskO; obase=2; bin" | bc -l);
    iBinary=$(echo "bin=$nonClassIpO; obase=2; bin" | bc -l);

    if [ $(echo -n $iBinary | wc -c | awk '{printf $1}') -lt 8 ]; then
        while [ $(echo -n $iBinary | wc -c | awk '{printf $1}') -lt 8 ]; do iBinary="0${iBinary}"; done
    fi

    bits=$(echo $mBinary | grep -o '1' | wc -l | awk '{printf $1}');
    cutedIBin=$(echo $iBinary | cut -c 1-${bits});

    nonClassAB=$cutedIBin;
    nonClassAN=$cutedIBin;

    while [ $(echo -n $cutedIBin | wc -c | awk '{printf $1}') -lt 8 ]; do
        cutedIBin="${cutedIBin}0";
        nonClassAN="${nonClassAN}0";
        nonClassAB="${nonClassAB}1";
    done

    nonClassANo=$(echo "ibase=2; bin=$nonClassAN; bin" | bc -l);
    nonClassABo=$(echo "ibase=2; bin=$nonClassAB; bin" | bc -l);
    
    if [ ! "$aN" ] && [ ! "$aB" ]; then 
        aN=$nonClassANo;
        aB=$nonClassABo;
    else
        aN="${aN}.$nonClassANo";
        aB="${aB}.$nonClassABo";
    fi

else 
    if [ ! "$aN" ] && [ ! "$aB" ]; then 
        aN='0';
        aB='255';
    else
        aN="${aN}.0";
        aB="${aB}.255";
    fi
fi

i=$(expr $i + 1);
done    
echo "+--------------------------------------------------------+";
echo -e "IP = $networkIP \t NETMASK = $netmask";
echo -e "NET ADDR = $aN \t BCAST ADDR = $aB";
HOSTS=$(echo "(2^$(expr 32 - $cidr)) - 2" | bc -l);
echo -e "HOSTS = $HOSTS \t\t HOSTNAME = $hostname";
FHOST=$(echo $aN | cut -d "." -f 1-3).$(expr $(echo $aN | cut -d '.' -f 4) + 1);
LHOST=$(echo $aB | cut -d "." -f 1-3).$(expr $(echo $aB | cut -d '.' -f 4) - 1);
echo -e "FHOST = $FHOST \t LHOST = $LHOST";
echo "+--------------------------------------------------------+";

if [ "$2" ] && [ "$2" = "--calc-only" ]; then exit 0; fi
if [ "$2" ] && [ "$2" = "--wait-time" ]; then waitTime=$3;
else waitTime=100; fi
ping_scan () {
if ping -c 1 -W $waitTime $1 | grep 'time=.*$' > /dev/null; then
    status="[+]";
    time=$(ping -c 1 -W $waitTime $1 | grep -o 'time=.*$' | cut -d "=" -f 2);
    name=$(host $1 | awk '{printf $NF}');
    if echo $name | grep '\.$' > /dev/null; then 
        name=$(echo $name | cut -c 1-$(expr $(echo $name | wc -c | awk '{printf $1}') - 2));
    fi 

    echo -e "$status\t$1\t $time\t$name";
else 
    status="[-]";
    name=$(host $1 | awk '{printf $NF}');
    if echo $name | grep '\.$' > /dev/null; then 
        name=$(echo $name | cut -c 1-$(expr $(echo $name | wc -c | awk '{printf $1}') - 2));
    fi 
    if [ "$2" ] && [ "$2" = "--all" ]; then 
        echo -e "$status\t$1\t - ms.\t$name";
    fi
fi
}

ssh_scan () {
if nc -z -G 1 -w 1 $1 22 > /dev/null 2>&1; then
    status="[open]";
    name=$(host $1 | awk '{printf $NF}');
    if echo $name | grep '\.$' > /dev/null; then 
        name=$(echo $name | cut -c 1-$(expr $(echo $name | wc -c | awk '{printf $1}') - 2));
    fi 

    echo -e "$status\t$1\t$name";
else 
    name=$(host $1 | awk '{printf $NF}');
    if echo $name | grep '\.$' > /dev/null; then 
        name=$(echo $name | cut -c 1-$(expr $(echo $name | wc -c | awk '{printf $1}') - 2));
    fi 
    echo -e "[closed/filtered]\t$1\t$name";
fi
}

if [ ! "$class" ]; then class=$nonClass; fi
class=$(expr $class + 1);

nonClassMaskO=$(echo $netmask | cut -d '.' -f $class);
    if [ $nonClassMaskO != '255' ]; then 
        i=$(echo $FHOST | cut -d '.' -f $class);
        while [ $i -le $(echo $LHOST | cut -d '.' -f $class) ]; do 
            if [ $class -ne 4 ]; then 
                #nonClass=$(expr $nonClass + 1);
                j=$(echo $FHOST | cut -d '.' -f $(expr $class + 1));
                while [ $j -le $(echo $LHOST | cut -d '.' -f $(expr $class + 1)) ]; do
                    if [ $class -ne 3 ]; then
                        #nonClass=$(expr $nonClass + 1);
                        k=$(echo $FHOST | cut -d '.' -f $(expr $class + 1));
                        while [ $k -le $(echo $LHOST | cut -d '.' -f $(expr $class + 1)) ]; do
                            if [ $class -ne 2 ]; then
                                #nonClass=$(expr $nonClass + 1);
                                l=$(echo $FHOST | cut -d '.' -f $(expr $class + 1));
                                while [ $l -le $(echo $LHOST | cut -d '.' -f $(expr $lass + 1)) ]; do
                                    ip="${i}.${j}.${k}.${l}";
                                    if [ "$2" ] && [ "$2" = "--ssh" ]; then ssh_scan $ip;
                                    else ping_scan $ip $2; fi
                                    l=$(expr $l + 1);
                                done
                            else
                                ip="$(echo $FHOST | cut -d '.' -f 1).${i}.${j}.${k}";
                                if [ "$2" ] && [ "$2" = "--ssh" ]; then ssh_scan $ip;
                                else ping_scan $ip $2; fi
                            fi
                            k=$(expr $k + 1);
                        done
                    else
                        ip="$(echo $FHOST | cut -d '.' -f 1-2).${i}.${j}";
                        if [ "$2" ] && [ "$2" = "--ssh" ]; then ssh_scan $ip;
                        else ping_scan $ip $2; fi
                    fi
                    j=$(expr $j + 1);
                done
            else
                ip="$(echo $FHOST | cut -d '.' -f 1-3).${i}";
                if [ "$2" ] && [ "$2" = "--ssh" ]; then ssh_scan $ip;
                else ping_scan $ip $2; fi
            fi
            i=$(expr $i + 1);
        done
    fi

#echo ${mask[*]};
#echo $netmask;
#echo "${bitNotation[0]}";