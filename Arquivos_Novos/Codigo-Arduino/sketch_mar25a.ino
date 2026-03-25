const int PINO_SENSOR_TEMPERATURA = A0;
float temperaturaCelcius;


void setup() {
  Serial.begin(9600);
  
}

void loop() {
  int valorLeitura = analogRead(PINO_SENSOR_TEMPERATURA);
  temperaturaCelcius = (valorLeitura * 5.0 / 1023.0) /0.01;
  Serial.println(temperaturaCelcius);
  delay(2000);
}
