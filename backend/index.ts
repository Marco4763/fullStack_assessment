import express = require('express');
import { UpdateController } from './controller/UpdateController';
import { UploadController } from './controller/UploadController';
import { ResultsController } from './controller/ResultsController';
const multer = require('multer');

const app = express();
const storageAccess = multer.memoryStorage();
const upload = multer({storage: storageAccess});

app.put('/upload/:id', upload.single('image'), UpdateController());

app.post('/upload', upload.single('image'), UploadController());

app.get('/allResults/:start/:end', ResultsController());

app.listen(8080, '0.0.0.0');