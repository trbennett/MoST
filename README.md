MotionSynthesis Toolset
====================
##Data
We provide inertial sensor data of 23 movements performed for 15 repetitions each by many subjects. This data consists of accelerometer and gyroscope values collected at 200Hz  by inertial sensors worn on the body as shown in the figure below.

![Sensor locations](http://motionsynthesis.org/database/images/sensorlocations.png)

This data is provided in two formats: text files or as a [hierarchical h5 file][1].

####Data in .txt form
The data is in a tab delimited format, with each column representing a different sensor reading or value related to the collection. This format is outlined in the table below along with the final units:

| Column 1 | Column 2 | Column 3 | Column 4 | Column 5 | Column 6 | Column 7 | Column 8 | Column 9 | Column 10 | Column 11 | Column 12 | Column 13
|:--------:|:-------:|:---------:|:-------:|:------:|:---------:|:-------:|:------:|:------:|:---------:|:-------:|:------:|:--------:|
| Accelerometer X | Accelerometer Y | Accelerometer Z | Gyroscope X | Gyroscope Y | Gyroscope Z | Magnetomer X | Magnetomer Y | Magnetometer Z | Sensor Pkt # | Time (ms) | PC Pkt # | PC Time |

The accelerometer/gyroscope/magnetometer values are all ADC values, and can be converted to real values with a divider, listed in the table below.

####Dividers:
| Accelerometer (m/s^2) | Gyroscope (º/s) | Magnetometer (μT) |
|:---------------------:|:---------------:|:-----------------:|
| 16384 | 131 | 3.33 |

###The movements
 1. Sit to Stand - the subject stands up from a sitting position
 2. Stand to Sit - the subject sits down from a standing position
 3. Sit to Lie - the subject lies down from a sitting position
 4. Lie to Sit - the subject sits up from a lying position
 5. Step forward and backward - the subject steps forward, and then backward
 6. Looking back right - the subject looks back to their right
 7. Grasp from floor - the subject grabs an object from the floor, in a standing position
 8. Turn right 90 degrees - the subject turns in place 90 degrees to the right
 9. Grasp from shelf - the subject grabs an object from a shelf, in a standing position
 10. Jumping - the subject jumps in place
 11. Step left then right - the subject steps to the left, and then to the right
 12. Eating - the subject brings a spoon or fork to their mouth
 13. Drinking - the subject brings a cup to their mouth
 14. Stand in neutral position - the subject stands in place for about 30 seconds
 15. Sit with feet on floor - the subject sits in place for 30 seconds
 16. Basic lying - the subject lies in place for 30 seconds
 17. Walking - the subject walks along a straight line for a couple strides
 18. Sit with leg crossed - the subject transitions from basic sitting to sitting with right ankle on their left knee
 19. Sit with ankles crossed - the subject transitions from basic sitting to sitting with their right ankle crossed over their left
 20. Stand with leg crossed - the subject crosses their right leg with their left in a standing position
 21. Stand with one leg forward - the subject steps slightly forward with their right leg and shifts their weight
 22. Kneeling - the subject kneels down from a standing position
 23. Use a phone - the subject brings their phone up to their ear from at their hip while in a standing position

###File Naming Convention
[Link to Wiki FAQ][2]

---------------------------

## Contact us
Hunter Massey: hunter.massey@utdallas.edu

Terrell Bennett: tbennett@utdallas.edu

[1]: https://www.hdfgroup.org/HDF5/whatishdf5.html
[2]:http://motionsynthesis.org/?n=Development.FileNameConvention
