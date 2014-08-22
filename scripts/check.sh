#! /bin/sh

protagonist[0]=F1
protagonist[1]=F2
protagonist[2]=M1
protagonist[3]=M2

activity[0]=Basic_lying
activity[1]=Basic_sitting
activity[2]=Basic_standing
activity[3]=Drinking
activity[4]=Eating
activity[5]=Grasping_floor
activity[6]=Grasping_shelf
activity[7]=Jumping
activity[8]=Kneeling
activity[9]=Lie_to_sit
activity[10]=Looking_back_right
activity[11]=Sitting\(1\)
activity[12]=Sitting\(2\)
activity[13]=Sit_to_lie
activity[14]=Sit_to_stand
activity[15]=Standing\(1\)
activity[16]=Standing\(2\)
activity[17]=Stand_to_sit
activity[18]=Step_forward_backward
activity[19]=Step_left_right
activity[20]=Turning_90
activity[21]=Using_phone
activity[22]=Walking

mact[0]=m25
mact[1]=m23
mact[2]=m24
mact[3]=m13
mact[4]=m12
mact[5]=m07
mact[6]=m09
mact[7]=m10
mact[8]=m03
mact[9]=m22
mact[10]=m06
mact[11]=m15
mact[12]=m16
mact[13]=m21
mact[14]=m19
mact[15]=m17
mact[16]=m18
mact[17]=m20
mact[18]=m04
mact[19]=m11
mact[20]=m08
mact[21]=m14
mact[22]=m05

if [ "$#" -ne 1 ]; then
  dir="."
else
  dir=$1
fi

# clear error flag for new run
[ -f .error ] && rm .error

# check that all protagonist/activity directories exist
#   the activity subdirectory must exist but may be empty
for (( p=0; p < 4; p+=1 )); do
  for (( a=0; a < 23; a+=1 )); do
    if [ ! -d $dir/${protagonist[p]}/${activity[a]} ]; then
      echo ERROR: missing $dir/${protagonist[p]}/${activity[a]} 
      touch .error
    fi
  done
done
[ -f .error ] && exit 5

# remove temp files
find $dir/{F,M}{1,2} -name temp.txt -exec rm \{\} \;

# remove original directories
find $dir/{F,M}{1,2} -type d -name original -exec rm -rf \{\} \;

# check for misplaced files - more than one mXX in a directory
for (( p=0; p < 4; p+=1 )); do
  for (( a=0; a < 23; a+=1 )); do
    if [ `find $dir/${protagonist[p]}/${activity[a]} -name m0\*_n0\?.txt | awk -F / '{print $(NF)}' | awk -F _ '{print $3}' | sort -u | wc -l` -gt "1" ]; then
      echo ERROR: $dir/${protagonist[p]}/${activity[a]} contains files for multiple activities
      for (( i=0; i < $a; i+=1)); do
        for f in `find $dir/${protagonist[p]}/${activity[a]} -name m0\*_${mact[i]}_n\*.txt`; do
          echo "   " $f
        done
      done
      for (( i=1+$a; i < 23; i+=1)); do
        for f in `find $dir/${protagonist[p]}/${activity[a]} -name m0\*_${mact[i]}_n\*.txt`; do
          echo "   " $f
        done
      done
      touch .error
    fi
  done
done
#[ -f .error ] && exit 5

# check for missing locations
for (( p=0; p < 4; p+=1 )); do
  for (( a=0; a < 23; a+=1 )); do
    for iteration in `find $dir/${protagonist[p]}/${activity[a]} -name m0\*_n0\?.txt | awk -F / '{print $(NF)}' | awk -F _ '{print $1 "_" $2}' | sort -u`; do
      for location in _n01 _n02 _n03 _n04 _n05 _n06; do
        if [ ! -f $dir/${protagonist[p]}/${activity[a]}/${iteration}_${mact[a]}${location}.txt ]; then
          echo ERROR: missing $dir/${protagonist[p]}/${activity[a]}/${iteration}_${mact[a]}${location}.txt
          touch .error
        fi
      done
    done 
  done
done
#[ -f .error ] && exit 5

# check for unequal sample lengths
for (( p=0; p < 4; p+=1 )); do
  for (( a=0; a < 23; a+=1 )); do
    for iteration in `find $dir/${protagonist[p]}/${activity[a]} -name m0\*_n0\?.txt | awk -F / '{print $(NF)}' | awk -F _ '{print $1 "_" $2 "_" $3}' | sort -u`; do
      if [ `wc -l $dir/${protagonist[p]}/${activity[a]}/${iteration}*.txt | awk '{print $1}' | sort -u | wc -l` -gt 2 ]; then
        echo ERROR: unequal sample lengths in $dir/${protagonist[p]}/${activity[a]}/${iteration}_n0X.txt
        wc -l $dir/${protagonist[p]}/${activity[a]}/${iteration}*.txt 
        touch .error
      fi
    done 
  done
done
#[ -f .error ] && exit 5

# check for short files - already checked for missing locations and unequal length,
#   so just check *_n01.txt for shortness
for f in `find $dir/{F,M}{1,2} -name m0\*_n01.txt`; do
  if [ `wc -l $f | awk '{print $1}'` -lt 50 ]; then
    echo WARNING: $f seems short
    wc -l $f
    touch .error
  fi
done
#[ -f .error ] && exit 5                                                                                                                                                           
