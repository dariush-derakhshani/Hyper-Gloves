# **Hyper-Gloves**

Description of project goes here.

Hardware needed for this instrument:

* Arduino Nano
* MPU6050 Accelerometer Gyroscope

## Instructions

0. Upload the code in the *ArduinoToSerial* folder to your Arduino Nano using the Arduino IDE (found at https://www.arduino.cc/en/software).
1. Open *MaxToWekinator.maxpat* using MaxMSP (found at https://cycling74.com/downloads/) to check whether or not data is being transmitted from Arduino to MaxMSP via the selected USB serial port. Be sure to select the correct USB port in the Max patch.
2. Open WekinatorProject.wekproj in the *WekinatorToFMSynth* folder with Wekinator  (found at http://www.wekinator.org/downloads/). By default port **6448** is being used to receive OSC messages from MaxMSP. Remember to change the port in *MaxToWekinator.maxpat* if you decide to change it in your Wekinator project.
3. By default there are 6 inputs being sent from Arduino (MPU6050 sensor) to Wekinator via the Max patch. All of these values are mapped from 0 to 500–from its original -18000 to +18000–which can be changed within the *ArduinoToSerial.ino* file for increased resolution, if needed.
4. Once both *MaxToWekinator.maxpat* and *WekinatorToFMSynth* are running, check and see if the **OSC In** light has turned green in your Wekinator application. This ensures that Wekinator is receiving OSC messages from Max.
5. Open *FMSynth* and make sure you are receiving soud from the application. Four hand positions have been pre-recorded and trained in the Wekinator application. Replicating these positions will directly affect the sound heard coming from *FMSynth*.
6. Press **Run** on Wekinator to enable hand position recognition (using pre-recorded data).
7. To record additional hand positions, hold your hand in your desired position and press **Start Recording**. After recording a few samples (the number of samples varies from position to position. Some positions require you to record more samples than others) press **Stop Recording** and **Train** your model.
8. Once you're done training your model (this could take a while depending on how many samples you have recorded), press **Run**.

## Gestures

A list of gestures with nicknames + images will go here

