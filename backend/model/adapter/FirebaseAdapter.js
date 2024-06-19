"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FirebaseAdapter = void 0;
var app_1 = require("firebase/app");
function FirebaseAdapter() {
    var env = process.env;
    var firebaseConfig = {
        apiKey: env.APIKEY,
        authDomain: env.AUTHDOMAIN,
        databaseURL: env.DATABASEURL,
        projectId: env.PROJECTID,
        storageBucket: env.STORAGEBUCKET,
        messagingSenderId: env.MESSAGEID,
        appId: env.APPID,
        measurementId: env.MEASUREID,
    };
    return (0, app_1.initializeApp)(firebaseConfig);
}
exports.FirebaseAdapter = FirebaseAdapter;
