#! /bin/sh

$FF/obs-print -of1 $1 -gpr 0:0 -fr1 0:3 | \
gawk 'BEGIN {for (i=0; i < 23; i+=1) {
               people[i "","0"]=0; people[i "","1"]=0;
               people[i "","2"]=0; people[i "","3"]=0;
               subj[i ""] = 0; count[i ""]=0;
             }
activity[0 ""]="Basic_lying"
activity[1 ""]="Basic_sitting"
activity[2 ""]="Basic_standing"
activity[3 ""]="Drinking"
activity[4 ""]="Eating"
activity[5 ""]="Grasping_floor"
activity[6 ""]="Grasping_shelf"
activity[7 ""]="Jumping"
activity[8 ""]="Kneeling"
activity[9 ""]="Lie_to_sit"
activity[10 ""]="Looking_back_right"
activity[11 ""]="Sitting1"
activity[12 ""]="Sitting2"
activity[13 ""]="Sit_to_lie"
activity[14 ""]="Sit_to_stand"
activity[15 ""]="Standing1"
activity[16 ""]="Standing2"
activity[17 ""]="Stand_to_sit"
activity[18 ""]="Step_forward_backward"
activity[19 ""]="Step_left_right"
activity[20 ""]="Turning_90"
activity[21 ""]="Using_phone"
activity[22 ""]="Walking"

            }
      NF==8 {people[$8,$7] += 1; count[$8]+=1}
      END {for (i=0; i < 23; i+=1) {
             for (j=0; j < 4; j+=1)
               if (people[i "", j] > 0) 
                 subj[i ""] += 1;
             printf "%d   %2d   %s\n", subj[i ""], count[i ""], activity[i ""]
           }
          } '
