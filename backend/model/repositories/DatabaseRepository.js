"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (g && (g = 0, op[0] && (_ = 0)), _) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.DatabaseRepository = void 0;
var database_1 = require("firebase/database");
var FirebaseAdapter_1 = require("../adapter/FirebaseAdapter");
var StorageDAO_1 = require("../dao/StorageDAO");
var DatabaseRepository = /** @class */ (function () {
    function DatabaseRepository() {
        this.app = (0, FirebaseAdapter_1.FirebaseAdapter)();
    }
    DatabaseRepository.prototype.upload = function (file) {
        return __awaiter(this, void 0, void 0, function () {
            var uploadToStorage, thumbnailList, thumbnails, database, databaseRef, id, e_1;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        _a.trys.push([0, 8, , 9]);
                        return [4 /*yield*/, (0, StorageDAO_1.StorageDAO)(file)];
                    case 1:
                        uploadToStorage = _a.sent();
                        if (!uploadToStorage.success) return [3 /*break*/, 6];
                        thumbnailList = [];
                        return [4 /*yield*/, this.getThumbnails()];
                    case 2:
                        thumbnails = _a.sent();
                        if (thumbnails.data !== null) {
                            if (thumbnails.data instanceof Array) {
                                thumbnailList = thumbnails.data;
                            }
                            else {
                                thumbnailList.push(thumbnails.data);
                            }
                        }
                        return [4 /*yield*/, (0, database_1.getDatabase)(this.app)];
                    case 3:
                        database = _a.sent();
                        databaseRef = (0, database_1.ref)(database, 'thumbnails');
                        return [4 /*yield*/, (0, database_1.push)(databaseRef)];
                    case 4:
                        id = _a.sent();
                        thumbnailList.push({
                            thumbnailId: id.key,
                            thumbnail: uploadToStorage.download,
                        });
                        return [4 /*yield*/, (0, database_1.set)(databaseRef, thumbnailList)];
                    case 5:
                        _a.sent();
                        return [2 /*return*/, {
                                success: true,
                            }];
                    case 6: return [2 /*return*/, {
                            success: false,
                            data: uploadToStorage,
                        }];
                    case 7: return [3 /*break*/, 9];
                    case 8:
                        e_1 = _a.sent();
                        return [2 /*return*/, {
                                success: false,
                                message: e_1,
                            }];
                    case 9: return [2 /*return*/];
                }
            });
        });
    };
    DatabaseRepository.prototype.updateThumbnail = function (file, thumbnailId) {
        return __awaiter(this, void 0, void 0, function () {
            var database, databaseRef, values, uploadToStorage_1, e_2;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        _a.trys.push([0, 4, , 5]);
                        return [4 /*yield*/, (0, database_1.getDatabase)(this.app)];
                    case 1:
                        database = _a.sent();
                        databaseRef = (0, database_1.ref)(database);
                        return [4 /*yield*/, (0, database_1.get)((0, database_1.query)((0, database_1.child)(databaseRef, 'thumbnails'), (0, database_1.orderByChild)('thumbnailId'), (0, database_1.equalTo)(thumbnailId)))];
                    case 2:
                        values = _a.sent();
                        return [4 /*yield*/, (0, StorageDAO_1.StorageDAO)(file)];
                    case 3:
                        uploadToStorage_1 = _a.sent();
                        if (uploadToStorage_1.success) {
                            values.forEach(function (thumbnail) {
                                (0, database_1.update)(thumbnail.ref, {
                                    thumbnailId: thumbnailId,
                                    thumbnail: uploadToStorage_1.download,
                                });
                            });
                        }
                        return [2 /*return*/, {
                                success: true,
                            }];
                    case 4:
                        e_2 = _a.sent();
                        console.log(e_2);
                        return [2 /*return*/, {
                                success: false,
                                message: e_2,
                            }];
                    case 5: return [2 /*return*/];
                }
            });
        });
    };
    DatabaseRepository.prototype.getThumbnails = function (start, end) {
        return __awaiter(this, void 0, void 0, function () {
            var database, databaseRef, values, thumbnailList_1, e_3;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        _a.trys.push([0, 6, , 7]);
                        return [4 /*yield*/, (0, database_1.getDatabase)(this.app)];
                    case 1:
                        database = _a.sent();
                        databaseRef = (0, database_1.ref)(database);
                        values = void 0;
                        if (!(start !== undefined && end !== undefined)) return [3 /*break*/, 3];
                        return [4 /*yield*/, (0, database_1.get)((0, database_1.query)((0, database_1.child)(databaseRef, 'thumbnails'), (0, database_1.orderByKey)(), (0, database_1.startAt)(start), (0, database_1.endAt)(end)))];
                    case 2:
                        values = _a.sent();
                        return [3 /*break*/, 5];
                    case 3: return [4 /*yield*/, (0, database_1.get)((0, database_1.child)(databaseRef, 'thumbnails'))];
                    case 4:
                        values = _a.sent();
                        _a.label = 5;
                    case 5:
                        thumbnailList_1 = [];
                        if (values.val() instanceof Array) {
                            thumbnailList_1 = values.val();
                        }
                        else {
                            values.forEach(function (thumbnail) {
                                thumbnailList_1.push(thumbnail);
                            });
                        }
                        return [2 /*return*/, {
                                success: true,
                                data: thumbnailList_1,
                            }];
                    case 6:
                        e_3 = _a.sent();
                        console.log('Error getting thumbnail' + e_3);
                        return [2 /*return*/, {
                                success: false,
                                message: e_3,
                            }];
                    case 7: return [2 /*return*/];
                }
            });
        });
    };
    return DatabaseRepository;
}());
exports.DatabaseRepository = DatabaseRepository;
