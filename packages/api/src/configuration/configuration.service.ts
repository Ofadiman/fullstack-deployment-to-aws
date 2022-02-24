import { Injectable } from '@nestjs/common'
import { ConfigService } from '@nestjs/config'
import { EnvironmentVariables } from './enums/environment-variables.enum'
import { TypeOrmModuleOptions } from '@nestjs/typeorm'
import { NodeEnv } from './dto/environment-variables.dto'

const REMOTE_ENVIRONMENTS: NodeEnv[] = [NodeEnv.Staging, NodeEnv.Production]

@Injectable()
export class ConfigurationService {
  public constructor(private readonly configService: ConfigService) {}

  public get<ReturnType extends string>(environmentVariable: EnvironmentVariables): ReturnType {
    return this.configService.get(environmentVariable) as ReturnType
  }

  public get typeOrmModuleOptions(): TypeOrmModuleOptions {
    const cwd: string = process.cwd()

    const typeOrmModuleOptions: TypeOrmModuleOptions = {
      autoLoadEntities: true,
      cli: {
        migrationsDir: `${cwd}/src/database/migrations`
      },
      database: this.get(EnvironmentVariables.PostgresDatabase),
      entities: [`${cwd}/dist/**/*.entity.js`],
      host: this.get(EnvironmentVariables.PostgresHost),
      keepConnectionAlive: true,
      logging: [`error`, `query`],
      migrations: [`${cwd}/dist/src/database/migrations/*.js`],
      migrationsRun: true,
      password: this.get(EnvironmentVariables.PostgresPassword),
      port: Number.parseInt(this.get(EnvironmentVariables.PostgresPort)),
      subscribers: [`${cwd}/dist/**/*.subscriber.js`],
      synchronize: false,
      type: `postgres`,
      username: this.get(EnvironmentVariables.PostgresUser)
    }

    return typeOrmModuleOptions
  }

  public get isRemote(): boolean {
    const nodeEnv: NodeEnv = this.get(EnvironmentVariables.NodeEnv)

    return REMOTE_ENVIRONMENTS.includes(nodeEnv)
  }
}
