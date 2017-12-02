//////// PROJECT 4 - PART 1 /////////

/////// LIBRARIES ///////
#include <WaspSensorCities_PRO.h> // Smart Cities PRO Library

////// VARIABLES & CONSTANTS //////
const int button = 19; // Analog 6 pin refered to the button
const int t_on=10; // LED 1 (on-board green LED) time ON when the button has been pushed
uint8_t estado = 0; // Auxiliar variable to force the LED 1 (green) state
// BME280 sensor
float temperature; // Stores the temperature in [ºC] (Celsius degrees)
const float tmax=23; // Temperature threshold to turn on / turn out the LED 1 (green) [ºC]
float humidity;   // Stores the realitve humidity RH in [%]
float pressure;   // Stores the pressure in [Pa]
// CMOS Luminosity sensor
uint32_t luminosity; // Stores the luminosity in [lux] (unsigned int)
const uint32_t lumax=50; // Luminosity threshold to format It's day /night [lux]
// Ultrasound I2CXL-MaxSonar®-MB1202™
uint16_t range; // Stores the distance in [cm]
const uint16_t det=50; // Ultrasound threshold which determines if a person has passed through [cm]

////// SOCKET CONNECTIONS FOR SENSOR //////
bmeCitiesSensor bme(SOCKET_1); // Indicate the SC PRO Socket where the BME280 has been connected
luxesCitiesSensor  luxes(SOCKET_2); // Indicate the SC PRO socket where the CMOS sensor has been connected
ultrasoundCitiesSensor  ultrasound(SOCKET_4); // Indicate the SC PRO socket where the ultrasound sensor has been connected

// Function which turn ON the LED 1 (green) when the button has been pushed for 10 s - Using an interrumption
void boton(){
 estado=digitalRead(button); // Read the state of the button
 if (estado == LOW){ // If the button has been pushed (negative logic)
    Utils.setLED(LED1, LED_ON); // turn on the on-board LED 1 (green)
    RTC.setAlarm1(0,0,0,t_on, RTC_OFFSET, RTC_ALM1_MODE2 ); // Launch the RTC Alarm1 timmer
 }
 if (intFlag & RTC_INT){ // if Alarm1 RTC flag has been detected
  //RTC.clearAlarmFlag();
  //if(RTC.alarmTriggered == 1) {
    intFlag &= ~(RTC_INT); // Clear flag
    Utils.setLED(LED1, LED_OFF); // Turn out the on-board LED 1 (green)
  //}
 } // Cannot use else if you want the ultrasound sensor may turn on the on-board LED 1 (green)
//setMuxSocket1();
//Utils.muxOFF1();
//void WaspUtils::setMuxSocket1()
}

// Function which turn ON the LED 1 (green) when the button has been pushed for 10 s - Using a delay
void boton2(){
 estado=digitalRead(button); // Read the state of the button
 if (estado == LOW){// if the button has been pushed (negative logic)
    Utils.setLED(LED1, LED_ON); // turn on the on-board LED 1 (green)
    delay(10000); // Delays the loop 10 s
    Utils.setLED(LED1, LED_OFF); // Turn out the on-board LED 1 (green)
} // Cannot use else if you want the ultrasound sensor may turn on the on-board LED 1 (green)
}

// Main functions
// Set up function
void setup(){
//USB.ON(); // Turn on the USB UART0 connection (not neccesary usign sensor functions)
USB.println(F("Proyecto numero 4")); // Print the name of the project
//PWR.setSensorPower(SENS_3V3,SENS_ON); // Turn on the 3.3 V power pins on-board
pinMode(button, INPUT); // Set up button pin on-board as an input
digitalWrite(button, HIGH); // Connects a pull-up resistence to button pin to ensure negative logic
}

// Loop function
void loop(){
//// Turn on sensors
bme.ON();   // Temperature, humidity and pressure sensor
luxes.ON(); // Luminosity sensor
ultrasound.ON(); // Ultrasound sensor

//// Read sensors
// BME280
temperature = bme.getTemperature();  // Temperature
humidity = bme.getHumidity(); // Humidity
pressure = bme.getPressure(); // Pressure
// Luminosity
luminosity = luxes.getLuminosity(); // luminosidad
// Ultrasound
range = ultrasound.getDistance();

//// Screen format by USB UART0
// Temperature, humidity and pressure
USB.println(F("***************************************"));
USB.print(F("Temperatura: "));
USB.printFloat(temperature, 2); // 2 decimals
USB.println(F(" Grados Centigrados"));
USB.print(F("RH: "));
USB.printFloat(humidity, 2);
USB.println(F(" %"));
USB.print(F("Presion: "));
USB.printFloat(pressure, 2);
USB.println(F(" Pa"));

// Luminosity
USB.println(F("***************************************"));
USB.print(F("Luminosity: "));
USB.print(luminosity);
USB.println(F(" luxes"));
if(luminosity>lumax){
  USB.println(F(" Es de dia "));
}else{
USB.println(F(" Es de noche "));}

// Ultrasound
USB.println(F("***************************************"));
USB.print(F("Distance: "));
USB.print(range);
USB.println(F(" cm"));

////Turn off sensors
bme.OFF(); // Temperature, humidity and pressure sensor
luxes.OFF(); // Luminosity sensor
ultrasound.OFF(); // Ultrasound sensor

// LED function
if(temperature>tmax){ // If the temperature meassured is greater than the threshold
  Utils.setLED(LED1, LED_OFF); // Turn out the on-board LED 1 (green)
  Utils.setLED(LED0, LED_ON); // Turn on the on-board LED 0 (red)
}
else{ // If the temperature meassured is greater than the threshold
  Utils.setLED(LED0, LED_OFF); // Turn out the on-board LED 0 (red)
  if(range<det){ // If the object detected is nearer than the threshold
    Utils.setLED(LED1, LED_ON); // turn on the on-board LED 1 (green)
    }// Cannot use else if you want the button turns on the on-board LED 1 (green) in inspite of the ultrasound threshold had been reached

// Function which turn ON the LED 1 (green) when the button has been pushed for 10 s
// Comment you don't prefer
boton();} // Using RTC Alarm 1 interruption
//boton2();} // Using a delay

// Delay allows to paralyze the loop to send meassurements via USB UART0 approx. every delay time
// asumming other lines don't consume time (14.7456 kHz quartz crystal involves 125 ns per C instruction (?))
delay(20000);

// Cannot use RTC Alarm 1 to weak up the Waspmote because it's been used to turn on the on-board LED 1 (green) when you push the button
  //USB.println(F("Deep Sleep Mode"));
  //PWR.deepSleep("00:00:00:20", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
  //USB.println(F("Wake up!\r\n"));
}
