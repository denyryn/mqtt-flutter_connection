# mqtt_simple_connection

A **Flutter application** demonstrating MQTT connectivity to control LEDs and retrieve sensor data. This app is designed for IoT enthusiasts looking to manage LED states and brightness while also integrating DHT and LDR sensors.

---

## ✨ **Features**
- **Control LED State and Brightness:**
  Easily toggle LEDs on/off and adjust brightness levels via the app interface.

- **Sensor Integration:**  
  - **DHT Sensor:** Monitor temperature and humidity data.  
  - **LDR Sensor:** Retrieve real-time light intensity readings.
  
- **Dynamic LED Configuration:**  
  Add or remove LEDs by modifying files in the `led_initialization` folder within the `repository` directory.  

- **Customizable MQTT Topics:**  
  Change the MQTT topics used by the application in the `topic_repository` file located in the `repository` directory.  

---

## 🛠️ **Project Structure**  
- **Repository Folder:**  
  - **`led_initialization`**: Contains configuration files for initializing LEDs. Modify these to add/remove LEDs.  
  - **`topic_repository`**: Houses MQTT topics. Update these files to adjust topics as per your MQTT setup.  

- **Sensors:**  
  Handles DHT and LDR sensor connections for seamless integration of environmental data.  

---

## 🚀 **Getting Started**

### Prerequisites  
1. Install Flutter: [Get Started with Flutter](https://docs.flutter.dev/get-started/install).  
2. Set up an MQTT broker like [Mosquitto](https://mosquitto.org/) or use a cloud-based solution such as [HiveMQ](https://www.hivemq.com/).  
