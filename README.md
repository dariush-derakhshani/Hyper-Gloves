# **Hyper-Gloves**

Description of project goes here.

Hardware needed for this instrument:

* 3 Arduino Nanos
* 8 Push Buttons
* MPU6050 Accelerometer Gyroscope
* HC-05 Wireless Bluetooth RF Transceiver

## Instructions

0. Download Arduino code (*Hyper-Gloves_Arduino.zip*) for both gloves (left hand & right hand) and the Bluetooth receiver.Extract the zipped file and upload the code to your respective Arduino Nanos using the Arduino application (found at https://www.arduino.cc/en/software).

1. Download the zipped Wekinator project folder called *Hyper-Gloves_Wekinator.zip* and run it via the Wekinator application (found at http://www.wekinator.org). Make sure you are receiving OSC data via your Bluetooth receiver that was setup earlier. OSC messages are sent through port number **6448** which is the default input port for Wekinator. If setup correctly, the yellow signal should turn green when a gesture is performed by any of the two gloves (see available gesutres below). OSC messages are sent out of Wekinator via port **12000** (default output port for Wekinator).

2. Download the zipped SuperCollider code for this project called *Hyper-Gloves_SuperCollider.zip* and open it with SuperCollider (found at https://supercollider.github.io/download). Be sure to select the correct output. A list of your available outputs can be found by running the following line of code:	

   ```c++
   ServerOptions.outDevices;
   ```

   Change the string from "Built-in Output" to your desired output and execute the code:

   ```C++
   s.options.outDevice_("Built-in Output");
   ```

3. Navigate to the */buffers* folder inside *Hyper-Gloves_SuperCollider*. You will find the default audio files which respond to various gestures in this folder. You can replace these files with your own audio samples (do this **before** running the code in SuperCollider). Make sure your audio samples are:
   - Mono (you will receive errors playing back stereo files)
   - 44.1kHz
   - 24-bit resolution
4. Presets can be triggered using the three buttons on your glove (allowing for 12 presets) OR using the GUI on SuperCollider. Each preset is used for a different purpose. As an example: Preset 01 is dedicated to playing back audio files corresponding to different gestures while Preset 02 controls different paramterers in a synthesizer. You can change the functionality of these presets by simply renaming a preset to perform your desired function.
5. The 'STOP' button in the GUI will stop all sounds ONLY under your current preset while the 'STOP ALL' button acts as a panic button to stop any and all audio signals coming out of SuperCollider.

## Gestures

A list of gestures with nicknames + images will go here

