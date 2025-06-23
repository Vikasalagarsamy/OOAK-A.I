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
var _a = require('../lib/db-production'), runProductionMigration = _a.runProductionMigration, getProductionClient = _a.getProductionClient;
var fs = require('fs/promises');
var path = require('path');
function runDataMigration() {
    return __awaiter(this, void 0, void 0, function () {
        var schemaPath, schemaSQL, dataSQL, client, tablesResult, _i, _a, table, countResult, error_1;
        return __generator(this, function (_b) {
            switch (_b.label) {
                case 0:
                    _b.trys.push([0, 12, , 13]);
                    // 1. Read the schema file for data inserts
                    console.log('📚 Reading data migration file...');
                    schemaPath = path.join(process.cwd(), 'schema.sql');
                    return [4 /*yield*/, fs.readFile(schemaPath, 'utf-8')];
                case 1:
                    schemaSQL = _b.sent();
                    dataSQL = schemaSQL
                        .split('\n')
                        .filter(function (line) { return line.trim().startsWith('INSERT INTO'); })
                        .join('\n');
                    // 3. Run the data migration
                    return [4 /*yield*/, runProductionMigration(dataSQL, 'Data migration only')];
                case 2:
                    // 3. Run the data migration
                    _b.sent();
                    // 4. Verify the data
                    console.log('\n🔍 Verifying data...');
                    return [4 /*yield*/, getProductionClient()];
                case 3:
                    client = _b.sent();
                    _b.label = 4;
                case 4:
                    _b.trys.push([4, , 10, 11]);
                    return [4 /*yield*/, client.query("\n        SELECT table_name \n        FROM information_schema.tables \n        WHERE table_schema = 'public'\n        ORDER BY table_name;\n      ")];
                case 5:
                    tablesResult = _b.sent();
                    console.log('\n📊 Data Counts:');
                    console.log('=============');
                    _i = 0, _a = tablesResult.rows;
                    _b.label = 6;
                case 6:
                    if (!(_i < _a.length)) return [3 /*break*/, 9];
                    table = _a[_i];
                    return [4 /*yield*/, client.query("\n          SELECT COUNT(*) as count \n          FROM ".concat(table.table_name, "\n        "))];
                case 7:
                    countResult = _b.sent();
                    console.log("\uD83D\uDCE6 ".concat(table.table_name.padEnd(30), ": ").concat(countResult.rows[0].count, " rows"));
                    _b.label = 8;
                case 8:
                    _i++;
                    return [3 /*break*/, 6];
                case 9: return [3 /*break*/, 11];
                case 10:
                    client.release();
                    return [7 /*endfinally*/];
                case 11: return [3 /*break*/, 13];
                case 12:
                    error_1 = _b.sent();
                    console.error('❌ Data migration failed:', error_1);
                    process.exit(1);
                    return [3 /*break*/, 13];
                case 13: return [2 /*return*/];
            }
        });
    });
}
// Run the data migration
console.log('🚀 Starting Cursor Production Data Migration...\n');
runDataMigration().catch(console.error);
