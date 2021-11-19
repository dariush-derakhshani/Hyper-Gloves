# **Hyper-Gloves**

Description of project goes here.

Hardware needed for this instrument:

* Arduino Nano
* MPU6050 Accelerometer Gyroscope

## Instructions

0. Upload the code in the *ArduinoToSerial* folder to your Arduino Nano using the Arduino IDE (found at https://www.arduino.cc/en/software).

1. Open *MaxToWekinator.maxpat* using MaxMSP (found at https://cycling74.com/downloads/) to check whether or not data is being transmitted from Arduino to MaxMSP via the selected USB serial port. Be sure to select the correct USB port in the Max patch.

2. Open *WekinatorProject.wekproj* in the */WekinatorToSupercollider/* folder with Wekinator  (found at http://www.wekinator.org/downloads/). By default port **6448** is being used to receive OSC messages from MaxMSP. Remember to change the port in *MaxToWekinator.maxpat* if you decide to change it in your Wekinator project.

3. By default there are 6 inputs being sent from Arduino (MPU6050 sensor) to Wekinator via the Max patch. All of these values are mapped from 0 to 500–from its original -18000 to +18000–which can be changed within the *ArduinoToSerial.ino* file for increased resolution, if needed.

4. The Wekinator model has been trained with 5 classifiers which correspond to different hand positions. You can find these positions below.

5. Download Supercollider (found at https://supercollider.github.io/download) and add the following line to *SequenceableCollection.sc*:

   ```C++
   mostCommonItem {
       ^this.asSet.collect({ arg i; this.occurrencesOf(i) -> i }).maxItem.value
   }
   ```

   <sub>File Location: /Applications/SuperCollider/SuperCollider.app/Contents/Resources/SCClassLibrary/Common/Collections/SequenceableCollection.sc </sub>

4. Open *SuperColliderFromWekinator.scd* and run the code to start receiving classifiers from Wekinator. Classifier 5 (corresponding to hand position 5) will stop all sounds coming from Supercollider.

## Hand Positions

These are the 5 hand positions that send classifiers from Wekinator to Supercollider:

- Classifier 01:
  Hand at 180 degree angle
  [hand-position-01](https://i.ibb.co/wr42fDq/hand-position-1.png)
- Classifier 02:
  Hand tilted to the right at a 45 degree angle
  [hand-position-02](https://i.ibb.co/Sr4J2j3/hand-position-2.jpg)
- Classifier 03:
  Hand tilted to the left at a 45 degree angle
  [hand-position-03](https://i.ibb.co/R6HqQKP/hand-position-3.jpg)
- Classifier 04:
  Hand pointing up at a 90 degree angle
  [hand-position-04](https://i.ibb.co/K2fVNGq/hand-position-4.jpg)
- Classifier 05:
  Hand pointing down at a 90 degree angle
  [hand-position-05](https://i.ibb.co/RQTNfDq/hand-position-5.png)
