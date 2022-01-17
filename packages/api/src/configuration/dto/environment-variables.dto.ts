import { IsEnum, IsNumberString, IsString } from 'class-validator'

import { EnvironmentVariables } from '../enums/environment-variables.enum'

export enum NodeEnv {
  Development = `development`,
  Production = `production`,
  Staging = `staging`,
  Test = `test`
}

export class EnvironmentVariablesDto {
  @IsNumberString()
  public [EnvironmentVariables.ServerPort]: string

  @IsEnum(NodeEnv)
  public [EnvironmentVariables.NodeEnv]: NodeEnv

  @IsString()
  public [EnvironmentVariables.PostgresDatabase]: string

  @IsString()
  public [EnvironmentVariables.PostgresHost]: string

  @IsString()
  public [EnvironmentVariables.PostgresPassword]: string

  @IsNumberString()
  public [EnvironmentVariables.PostgresPort]: string

  @IsString()
  public [EnvironmentVariables.PostgresUser]: string
}
