#! /bin/sh

# Columns  Sensor Location
#  0:8     Right Ankle
#  9:17    Waist
# 18:26    Right Arm
# 27:35    Right Wrist
# 36:44    Left Thigh
# 45:53    Right Thigh

# Each location has 9 sensor readings in this order:
# Accelerometer X [-2.0, 2.0]
# Accelerometer Y [-2.0, 2.0]
# Accelerometer Z [-2.0, 2.0]
# Gyroscope X [-250.0, 250.0]
# Gyroscope Y [-250.0, 250.0]
# Gyroscope Z [-250.0, 250.0]
# Magnetometer X [-1.0, 1.0] (uncalibrated, unsure of correct range)
# Magnetometer Y [-1.0, 1.0] (uncalibrated, unsure of correct range)
# Magnetometer Z [-1.0, 1.0] (uncalibrated, unsure of correct range)

# Subject (column 54)
# 0 F1
# 1 F2
# 2 M1
# 3 M2

# Activity (column 55)
# 0  Basic_lying
# 1  Basic_sitting
# 2  Basic_standing
# 3  Drinking
# 4  Eating
# 5  Grasping_floor
# 6  Grasping_shelf
# 7  Jumping
# 8  Kneeling
# 9  Lie_to_sit
# 10 Looking_back_right
# 11 Sitting1
# 12 Sitting2
# 13 Sit_to_lie
# 14 Sit_to_stand
# 15 Standing1
# 16 Standing2
# 17 Stand_to_sit
# 18 Step_forward_backward
# 19 Step_left_right
# 20 Turning_90
# 21 Using_phone
# 22 Walking

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

[ ! -d gmtk ] && mkdir gmtk
[ ! -d tmp ]  && mkdir tmp
rm gmtk/* tmp/*

for (( p=0; p < 4; p+=1 )); do
  for (( a=0; a < 23; a+=1 )); do
    echo ${protagonist[p]} ${activity[a]}
    for iteration in `find ${protagonist[p]}/${activity[a]} -name m0\*_n0\?.txt | awk -F / '{print $3}' | awk -F _ '{print $1}' | sort -u`; do
      for location in _n01 _n02 _n03 _n04 _n05 _n06; do
        awk '{print $1/16384.0, $2/16384.0, $3/16384.0, $4/131.0, $5/131.0, $6/131.0, $7/32768.0, $8/32768.0, $9/32768.0}' \
           ${protagonist[p]}/${activity[a]}/${iteration}*${location}.txt > tmp/loc$location
      done
      paste -d " " tmp/loc_n01 tmp/loc_n02 tmp/loc_n03 tmp/loc_n04 tmp/loc_n05 tmp/loc_n06 > gmtk/segment
      awk -v subj=$p -v act=$a '{print $0, subj, act}' gmtk/segment > gmtk/${iteration}_${protagonist[p]}_${a}.txt
      echo ${iteration}_${protagonist[p]}_${a}.txt >> gmtk/most.list
      rm gmtk/segment tmp/*
    done 
  done
done
