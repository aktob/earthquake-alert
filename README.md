# ealert

🌍 Earthquake Detection App (Flutter + Firebase + Hardware Integration)
This is a Flutter-based mobile application that integrates with external hardware sensors to detect earthquake activity in real time.

## 📱 App Features
Real-time Earthquake Detection using external hardware sensors.

Hardware Integration: The app connects to a physical device equipped with vibration and motion sensors to detect seismic activity.

Firebase Integration: When an earthquake is detected, the hardware pushes real-time data to Firebase.

Live Monitoring: The app listens for changes in Firebase and alerts the user immediately.

Interactive Map:

Displays the epicenter of the earthquake on a map.

Draws a radius circle around the center based on the magnitude and impact range of the earthquake.

## 🛠️ Tech Stack
Flutter (UI + App Logic)

Firebase (Realtime Database)

External Hardware (with sensors for vibration/motion)

Google Maps Flutter package for visualization


## 🚀 How It Works
The external hardware monitors seismic activity using sensors.

Upon detecting a potential earthquake, it sends data (location, magnitude) to Firebase.

The Flutter app listens to Firebase in real-time.

If earthquake data is received, the app:

Notifies the user.

Shows the earthquake's location on the map.

Draws a circle whose radius is proportional to the quake's strength.
