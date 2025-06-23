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
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g = Object.create((typeof Iterator === "function" ? Iterator : Object).prototype);
    return g.next = verb(0), g["throw"] = verb(1), g["return"] = verb(2), typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
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
var Pool = require('pg').Pool;
// Production database configuration
var PRODUCTION_CONFIG = {
    host: 'dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com',
    database: 'ooak_ai_db',
    user: 'ooak_admin',
    password: 'mSglqEawN72hkoEj8tSNF5qv9vJr3U6k',
    port: 5432,
    ssl: { rejectUnauthorized: false }
};
var PRODUCTION_DATABASE_URL = 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db';
// Create a production pool with proper error handling
var productionPool = new Pool({
    connectionString: PRODUCTION_DATABASE_URL,
    ssl: { rejectUnauthorized: false },
    max: 5,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 10000,
});
// Helper function to get a production client
function getProductionClient() {
    return __awaiter(this, void 0, void 0, function () {
        var client, error_1;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    _a.trys.push([0, 2, , 3]);
                    return [4 /*yield*/, productionPool.connect()];
                case 1:
                    client = _a.sent();
                    return [2 /*return*/, client];
                case 2:
                    error_1 = _a.sent();
                    console.error('Failed to connect to production database:', error_1);
                    throw error_1;
                case 3: return [2 /*return*/];
            }
        });
    });
}
// Helper function to run migrations on production
function runProductionMigration(migrationSQL, description) {
    return __awaiter(this, void 0, void 0, function () {
        var client, error_2;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, getProductionClient()];
                case 1:
                    client = _a.sent();
                    _a.label = 2;
                case 2:
                    _a.trys.push([2, 6, 8, 9]);
                    return [4 /*yield*/, client.query('BEGIN')];
                case 3:
                    _a.sent();
                    console.log("\uD83D\uDE80 Running migration: ".concat(description));
                    return [4 /*yield*/, client.query(migrationSQL)];
                case 4:
                    _a.sent();
                    return [4 /*yield*/, client.query('COMMIT')];
                case 5:
                    _a.sent();
                    console.log('✅ Migration completed successfully');
                    return [3 /*break*/, 9];
                case 6:
                    error_2 = _a.sent();
                    return [4 /*yield*/, client.query('ROLLBACK')];
                case 7:
                    _a.sent();
                    console.error('❌ Migration failed:', error_2);
                    throw error_2;
                case 8:
                    client.release();
                    return [7 /*endfinally*/];
                case 9: return [2 /*return*/];
            }
        });
    });
}
// Helper function to verify production schema
function verifyProductionSchema() {
    return __awaiter(this, void 0, void 0, function () {
        var client, tables;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, getProductionClient()];
                case 1:
                    client = _a.sent();
                    _a.label = 2;
                case 2:
                    _a.trys.push([2, , 4, 5]);
                    return [4 /*yield*/, client.query("\n      SELECT table_name, column_name, data_type \n      FROM information_schema.columns \n      WHERE table_schema = 'public'\n      ORDER BY table_name, ordinal_position;\n    ")];
                case 3:
                    tables = _a.sent();
                    return [2 /*return*/, tables.rows];
                case 4:
                    client.release();
                    return [7 /*endfinally*/];
                case 5: return [2 /*return*/];
            }
        });
    });
}
module.exports = {
    PRODUCTION_CONFIG: PRODUCTION_CONFIG,
    PRODUCTION_DATABASE_URL: PRODUCTION_DATABASE_URL,
    productionPool: productionPool,
    getProductionClient: getProductionClient,
    runProductionMigration: runProductionMigration,
    verifyProductionSchema: verifyProductionSchema
};
// Enhanced query function with retry logic for production
function query(text, params) {
    return __awaiter(this, void 0, void 0, function () {
        var pool, client, retries, result, error_3;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    pool = productionPool;
                    client = null;
                    retries = 3;
                    _a.label = 1;
                case 1:
                    if (!(retries > 0)) return [3 /*break*/, 9];
                    _a.label = 2;
                case 2:
                    _a.trys.push([2, 5, 7, 8]);
                    return [4 /*yield*/, pool.connect()];
                case 3:
                    client = _a.sent();
                    return [4 /*yield*/, client.query(text, params)];
                case 4:
                    result = _a.sent();
                    return [2 /*return*/, {
                            data: result.rows,
                            success: true
                        }];
                case 5:
                    error_3 = _a.sent();
                    console.error("\u274C Database query error (".concat(retries, " retries left):"), error_3);
                    retries--;
                    if (retries === 0) {
                        return [2 /*return*/, {
                                data: null,
                                success: false,
                                error: error_3 instanceof Error ? error_3.message : 'Unknown database error'
                            }];
                    }
                    // Wait before retry
                    return [4 /*yield*/, new Promise(function (resolve) { return setTimeout(resolve, 1000); })];
                case 6:
                    // Wait before retry
                    _a.sent();
                    return [3 /*break*/, 8];
                case 7:
                    if (client) {
                        client.release();
                    }
                    return [7 /*endfinally*/];
                case 8: return [3 /*break*/, 1];
                case 9: return [2 /*return*/, {
                        data: null,
                        success: false,
                        error: 'Maximum retries exceeded'
                    }];
            }
        });
    });
}
// Production-ready transaction function
function transaction(callback) {
    return __awaiter(this, void 0, void 0, function () {
        var pool, client, transactionQuery, result, error_4;
        var _this = this;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    pool = productionPool;
                    client = null;
                    _a.label = 1;
                case 1:
                    _a.trys.push([1, 6, 9, 10]);
                    return [4 /*yield*/, pool.connect()];
                case 2:
                    client = _a.sent();
                    return [4 /*yield*/, client.query('BEGIN')];
                case 3:
                    _a.sent();
                    transactionQuery = function (text, params) { return __awaiter(_this, void 0, void 0, function () {
                        var result;
                        return __generator(this, function (_a) {
                            switch (_a.label) {
                                case 0:
                                    if (!client)
                                        throw new Error('Transaction client not available');
                                    return [4 /*yield*/, client.query(text, params)];
                                case 1:
                                    result = _a.sent();
                                    return [2 /*return*/, {
                                            data: result.rows,
                                            success: true
                                        }];
                            }
                        });
                    }); };
                    return [4 /*yield*/, callback(transactionQuery)];
                case 4:
                    result = _a.sent();
                    return [4 /*yield*/, client.query('COMMIT')];
                case 5:
                    _a.sent();
                    return [2 /*return*/, {
                            data: result,
                            success: true
                        }];
                case 6:
                    error_4 = _a.sent();
                    if (!client) return [3 /*break*/, 8];
                    return [4 /*yield*/, client.query('ROLLBACK')];
                case 7:
                    _a.sent();
                    _a.label = 8;
                case 8:
                    console.error('❌ Database transaction error:', error_4);
                    return [2 /*return*/, {
                            data: null,
                            success: false,
                            error: error_4 instanceof Error ? error_4.message : 'Unknown transaction error'
                        }];
                case 9:
                    if (client) {
                        client.release();
                    }
                    return [7 /*endfinally*/];
                case 10: return [2 /*return*/];
            }
        });
    });
}
// Health check for production monitoring
function healthCheck() {
    return __awaiter(this, void 0, void 0, function () {
        var startTime, result, latency, error_5, latency;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    startTime = Date.now();
                    _a.label = 1;
                case 1:
                    _a.trys.push([1, 3, , 4]);
                    return [4 /*yield*/, query('SELECT 1 as health_check, NOW() as server_time')];
                case 2:
                    result = _a.sent();
                    latency = Date.now() - startTime;
                    if (result.success && result.data) {
                        return [2 /*return*/, {
                                healthy: true,
                                latency: latency,
                            }];
                    }
                    return [2 /*return*/, {
                            healthy: false,
                            latency: latency,
                            error: result.error || 'Unknown health check error'
                        }];
                case 3:
                    error_5 = _a.sent();
                    latency = Date.now() - startTime;
                    return [2 /*return*/, {
                            healthy: false,
                            latency: latency,
                            error: error_5 instanceof Error ? error_5.message : 'Health check failed'
                        }];
                case 4: return [2 /*return*/];
            }
        });
    });
}
// Export connection pool for advanced usage
var getDbPool = productionPool;
// Export for environment-specific usage
var isProduction = process.env.NODE_ENV === 'production';
