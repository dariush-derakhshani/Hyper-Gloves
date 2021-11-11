#include "I2Cdev.h"
#include "MPU6050.h"
#include "Wire.h"

MPU6050 accelgyro;

int16_t ax, ay, az;
int16_t gx, gy, gz;

int avAx = 0;
int avAy = 0;
int avAz = 0;
int avGx = 0;
int avGy = 0;
int avGz = 0;

// ------------------------------------------------------------------------------------------------------

void startGyro()
{
  Wire.begin();                                   // start the i2c communication protocol

  if (accelgyro.testConnection() == false)
  {
    while (true)
    {
      digitalWrite(13, HIGH);
      delay(50);
      digitalWrite(13, LOW);
      delay(50);
    }
  }
  else
    accelgyro.initialize();
}

// ------------------------------------------------------------------------------------------------------

void setup() {

  Serial.begin(115200);

  //start sensor
  startGyro();

}

// ------------------------------------------------------------------------------------------------------

void gyroValues() {

  accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz); //start receiving values from sensor
  constrain(ax, -18000, 18000);
  avAx = map(ax, -18000, 18000, 0, 500);
  constrain(ay, -18000, 18000);
  avAy = map(ay, -18000, 18000, 0, 500);
  constrain(az, -18000, 18000);
  avAz = map(az, -18000, 18000, 0, 500);
  constrain(gx, -18000, 18000);
  avGx = map(gx, -18000, 18000, 0, 500);
  constrain(gy, -18000, 18000);
  avGy = map(gy, -18000, 18000, 0, 500);
  constrain(gz, -18000, 18000);
  avGz = map(gz, -18000, 18000, 0, 500);


}

// ------------------------------------------------------------------------------------------------------

void gyroAverage() {

  int i1, i2, i3, i4, i5, i6;
  int value1 = 0;
  int value2 = 0;
  int value3 = 0;
  int value4 = 0;
  int value5 = 0;
  int value6 = 0;
  int numReadings = 5;


  for (i1 = 0; i1 < numReadings; i1++) {
    value1 = value1 + avAx;
    delay(1);
  }
  value1 = value1 / numReadings;
  // Scale to 8 bits (0 - 255).
  avAx = value1;
  if (avAx < 0) avAx = 0;
  if (avAx > 500) avAx = 500;

  // ---------------

  for (i2 = 0; i2 < numReadings; i2++) {
    value2 = value2 + avAy;
    delay(1);
  }
  value2 = value2 / numReadings;
  // Scale to 8 bits (0 - 255).
  avAy = value2;
  if (avAy < 0) avAy = 0;
  if (avAy > 500) avAy = 500;

  // ---------------

  for (i3 = 0; i3 < numReadings; i3++) {
    value3 = value3 + avAz;
    delay(1);
  }
  value3 = value3 / numReadings;
  // Scale to 8 bits (0 - 255).
  avAz = value3;
  if (avAz < 0) avAz = 0;
  if (avAz > 500) avAz = 500;

  // ---------------

  for (i4 = 0; i4 < numReadings; i4++) {
    value4 = value4 + avGx;
    delay(1);
  }
  value4 = value4 / numReadings;
  // Scale to 8 bits (0 - 255).
  avGx = value4;
  if (avGx < 0) avGx = 0;
  if (avGx > 500) avGx = 500;

  // ---------------

  for (i5 = 0; i5 < numReadings; i5++) {
    value5 = value5 + avGy;
    delay(1);
  }
  value5 = value5 / numReadings;
  // Scale to 8 bits (0 - 255).
  avGy = value5;
  if (avGy < 0) avGy = 0;
  if (avGy > 500) avGy = 500;

  // ---------------

  for (i6 = 0; i6 < numReadings; i6++) {
    value6 = value6 + avGz;
    delay(1);
  }
  value6 = value6 / numReadings;
  // Scale to 8 bits (0 - 255).
  avGz = value6;
  if (avGz < 0) avGz = 0;
  if (avGz > 500) avGz = 500;

  // ---------------


  delay(1);
}


// ------------------------------------------------------------------------------------------------------

void sendGyro() {

  Serial.print(avAx, DEC);
  Serial.print(",");
  Serial.print(avAy, DEC);
  Serial.print(",");
  Serial.print(avAz, DEC);
  Serial.print(",");
  Serial.print(avGx, DEC);
  Serial.print(",");
  Serial.print(avGy, DEC);
  Serial.print(",");
  Serial.print(avGz, DEC);
  Serial.println();
}

// ------------------------------------------------------------------------------------------------------

void loop() {

  gyroValues();
  gyroAverage();
  sendGyro();
  delay(1);
}
