#!/bin/bash

    #nonClassIpO='155';
    #nonClassMaskO='248'
    #mBinary=$(echo "bin=$nonClassMaskO; obase=2; bin" | bc -l);
    #iBinary=$(echo "bin=$nonClassIpO; obase=2; bin" | bc -l);
    #bits=$(echo $mBinary | grep -o '1' | wc -l | awk '{printf $1}');
    #cutedIBin=$(echo $iBinary | cut -c 1-${bits});
    #nonClassAB=$cutedIBin;
    #nonClassAN=$cutedIBin;
    #while [ $(echo -n $cutedIBin | wc -c | awk '{printf $1}') -lt "8" ]; do
    #    cutedIBin="${cutedIBin}0";
    #    nonClassAN="${nonClassAN}0";
    #    nonClassAB="${nonClassAB}1";
    #done

    #netmask='255.255.255.0';
    #nonClass=4;
    #aN='192.168.1.1';
    #aB='192.168.1.254';

    #nonClassMaskO=$(echo $netmask | cut -d '.' -f $nonClass);
    #if [ $nonClassMaskO != '255' ]; then 
    #   i=$(echo $aN | cut -d '.' -f $nonClass);
    #    while [ $i -le $(echo $aB | cut -d '.' -f $nonClass) ]; do 
    #        if [ $nonClass -ne 4 ]; then 
                #nonClass=$(expr $nonClass + 1);
    #            j=$(echo $aN | cut -d '.' -f $(expr $nonClass + 1));
    #            while [ $j -le $(echo $aB | cut -d '.' -f $(expr $nonClass + 1)) ]; do
    #                if [ $nonClass -ne 3 ]; then
    #                    #nonClass=$(expr $nonClass + 1);
    #                    k=$(echo $aN | cut -d '.' -f $(expr $nonClass + 1));
    #                   while [ $k -le $(echo $aB | cut -d '.' -f $(expr $nonClass + 1)) ]; do
    #                       if [ $nonClass -ne 2 ]; then
    #                            #nonClass=$(expr $nonClass + 1);
    #                            l=$(echo $aN | cut -d '.' -f $(expr $nonClass + 1));
    #                           while [ $l -le $(echo $aB | cut -d '.' -f $(expr $nonClass + 1)) ]; do
    #                               echo "${i}.${j}.${k}.${l}";
    #                               l=$(expr $l + 1);
    #                           done
    #                       else
    #                           echo "$(echo $aN | cut -d '.' -f 1).${i}.${j}.${k}";
    #                       fi
    #                       k=$(expr $k + 1);
    #                   done
    #              else
    #                   echo "$(echo $aN | cut -d '.' -f 1-2).${i}.${j}";
    #               fi
    #               j=$(expr $j + 1);
    #           done
    #       else
    #           echo "$(echo $aN | cut -d '.' -f 1-3).${i}";
    #       fi
    #       i=$(expr $i + 1);
    #   done
    #fi



    
