  <h1 align="center"><b>WEATHER APP</b></h3>

<p>It is a mobile application that provides information about a weather of the city you want.</p>

&nbsp;

## How it works:

![weather-app-diagram](https://user-images.githubusercontent.com/77735480/183253699-705b9c38-8a1b-4231-a46c-ab996e499c5e.png)

At a high level, 'Weather App' consists of a frontend that runs directly on a mobile device and a backend that provides with weather report. 

   - Frontend is a 'React Native' based app, there user can 'sign up', 'login' or 'skip login' to access the functionality of the app. To authenticate the user frontend connects to the 'Firebase Auth' service. After that user can enter the city name, which will be sent to the backend to get the weather report. In our case 'Frontend app' will run on the Android studio emulator.  

   - Backend app is written in 'Node JS'. When the 'city name' is received it sends request to the 'Google API' to get a geocode of the location. Furthermore, backend sends the received geocode to the 'OpenWeather API' and gets a weather report of that location from it. Backend app will run as a deployment in the Kubernetes cluster. 'Backend app' will have it's domain address to which the 'Frontend app' will send request to.

Moreover, backend returns the weather report to the frontend. Frontend then shows the information on the screen of the device. Additionally, Frontend app connects to the 'Firestore Cloud Database' to store the request details for further analytics.

   - 'Firestore Cloud Database' is a NoSQL document database to easily store, sync, and query data for mobile and web apps - at global scale.

   - 'Firebase Auth' provides methods to create and manage users that use their email addresses and passwords to sign in.

More details on general architecture in each of the `backend` and `frontend` folders.

## 📦 Backend Installation instructions

## How to run:

  1. Install **Node** latest version [*Run node -v if version shown so node properly installed*]
  
  2. Install all npm dependencies using below command:
     ```
     npm install
     ```
     
  3. Run node server using below command:
     ```
     npm start
     ```
     
  4. Here you go server is up at *http://localhost:3000/*
  
## ⚙️ How to test:

     *http://localhost:3000/weather?location={CITY_NAME}*
     
   ### For instance:
     
     *http://localhost:3000/weather?location=bishkek*


## 📦 Frontend Installation instructions

## How to run:

  1. Install **Node** latest version [*Run node -v if version shown so node properly installed*]
  
  2. Install all npm dependencies using below command:
     ```
     npm install
     ```
     
  3. Run the app on an android device using below command:
     ```
     npx react-native run-android
     ```
     The app was tested on android devices, but with an additional configuration it is possible to run it on ios emulator.

## Deploying in Kubernetes
When building a backend Docker image you should specify a **GOOGLE_API_KEY** and **WEATHER_FORECAST_KEY** as environment variables.

**GOOGLE_API_KEY** will contain key for the Google API that is used for geocoding.
**WEATHER_FORECAST_KEY** will contain key for the 'OpenWeather API'.

For the frontend app you don't need to create pipeline for it and you don't need to deploy it in kubernetes. Frontend app should be tested on Android Studio.


## Learn More
1. This app is written using React Native for Android & iOS, Check the getting started guide here: https://reactnative.dev/docs/environment-setup .

# CI/CD pipeline for backend:
## How it works:
1- Jenkins file was added that creates a Jenkins agent pod to run the job.
2- Polling was added to the Jinkins file to read from the repo[312-repo for weather app](https://github.com/312-bc/weather-22c-centos) every one minute.
3- Used bashscript for the CI/CD in the Jenkins file:
⋅⋅* Determines the stage based on the branch.
⋅⋅* If the stage is NOT prod it build the image from Dockerfile of the backend and push it.
⋅⋅* Then it deploy regardless of the stage.
4- The bashscript used in the Jenkins file uses the Makefile created in the backend to do the job.
5- For the Makefile used in the backend:
⋅⋅* It has 4 parts (build, login, push, deploy) and uses the included configs to be used depending on the stage.
⋅⋅* First part (build): it builds the image that gonna be used for backend from the Dockerfile.
⋅⋅* Second part (login): it logs in to AWS ECR using the credintials used by AWS CLI.
⋅⋅* Third part (push): it pushes the built image to the AWS ECR.
⋅⋅* Fourth part (deploy): Defined all values to be used by Helmcharts that is used to deploy the backend app to the created EKS.
6- Helmcharts templates:
⋅⋅* Deployment template that uses the image pushed to ECR to create a kubernetes deployment for backend.
⋅⋅* Service template is a ClusterIP svc for the Created deployment.
⋅⋅* Ingress resource template is used here to connect the traffic from the LB to the backend svc.
⋅⋅* Secret template is used to provide the GOOGLE_API_KEY, WEATHER_FORECAST_KEY used by the backend app.# weather
