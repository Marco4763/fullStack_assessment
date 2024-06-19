import { FirebaseApp, initializeApp } from 'firebase/app';

export function FirebaseAdapter(): FirebaseApp {
  const env = process.env;

  const firebaseConfig = {
    apiKey: env.APIKEY,
    authDomain: env.AUTHDOMAIN,
    databaseURL: env.DATABASEURL,
    projectId: env.PROJECTID,
    storageBucket: env.STORAGEBUCKET,
    messagingSenderId: env.MESSAGEID,
    appId: env.APPID,
    measurementId: env.MEASUREID,
  };

  return initializeApp(firebaseConfig);
}
