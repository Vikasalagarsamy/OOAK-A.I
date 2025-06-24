import { Pool, PoolConfig } from 'pg';
import databaseConfig from '../config/database-config.json';

export type Environment = 'development' | 'production';

type DatabaseEnvironmentBase = {
  host: string;
  database: string;
  type: string;
};

type DevelopmentEnvironment = DatabaseEnvironmentBase & {
  port: number;
};

type ProductionEnvironment = DatabaseEnvironmentBase & {
  region: string;
};

type DatabaseEnvironments = {
  development: DevelopmentEnvironment;
  production: ProductionEnvironment;
};

export class DatabaseHelper {
  private static instance: DatabaseHelper;
  private currentEnv: Environment;
  private pool: Pool | null = null;

  private constructor() {
    this.currentEnv = (process.env.NODE_ENV as Environment) || 'development';
  }

  public static getInstance(): DatabaseHelper {
    if (!DatabaseHelper.instance) {
      DatabaseHelper.instance = new DatabaseHelper();
    }
    return DatabaseHelper.instance;
  }

  public getCurrentEnvironment(): Environment {
    return this.currentEnv;
  }

  public getDatabaseName(): string {
    return (databaseConfig.environments as DatabaseEnvironments)[this.currentEnv].database;
  }

  public getHost(): string {
    return (databaseConfig.environments as DatabaseEnvironments)[this.currentEnv].host;
  }

  public getRegion(): string | undefined {
    const env = (databaseConfig.environments as DatabaseEnvironments)[this.currentEnv];
    return 'region' in env ? env.region : undefined;
  }

  public getPoolConfig(): PoolConfig {
    const poolSettings = databaseConfig.pools[this.currentEnv];
    return {
      min: poolSettings.min,
      max: poolSettings.max,
      idleTimeoutMillis: poolSettings.idleTimeoutMillis,
      connectionTimeoutMillis: poolSettings.connectionTimeoutMillis
    };
  }

  public isProduction(): boolean {
    return this.currentEnv === 'production';
  }

  public getEnvironmentInfo(): string {
    const env = (databaseConfig.environments as DatabaseEnvironments)[this.currentEnv];
    return `
      Environment: ${this.currentEnv}
      Database: ${env.database}
      Host: ${env.host}
      Type: ${env.type}
      ${('region' in env) ? `Region: ${env.region}` : ''}
    `.trim();
  }

  public validateEnvironment(): void {
    const requiredEnvVars = [
      'DATABASE_URL',
      'DATABASE_CONNECTION_TIMEOUT',
      'DATABASE_STATEMENT_TIMEOUT'
    ];

    const missing = requiredEnvVars.filter(varName => !process.env[varName]);
    if (missing.length > 0) {
      throw new Error(`Missing required environment variables: ${missing.join(', ')}`);
    }
  }
}

// Export a singleton instance
export const dbHelper = DatabaseHelper.getInstance();

// Usage example:
// import { dbHelper } from 'lib/db-helper';
// console.log(dbHelper.getEnvironmentInfo());
// if (dbHelper.isProduction()) {
//   // Do production-specific operations
// } 