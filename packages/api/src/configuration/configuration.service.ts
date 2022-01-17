import { Injectable } from '@nestjs/common'
import { ConfigService } from '@nestjs/config'
import { EnvironmentVariables } from './enums/environment-variables.enum'

@Injectable()
export class ConfigurationService {
  public constructor(private readonly configService: ConfigService) {}

  public get<ReturnType extends string>(environmentVariable: EnvironmentVariables): ReturnType {
    return this.configService.get(environmentVariable) as ReturnType
  }
}
