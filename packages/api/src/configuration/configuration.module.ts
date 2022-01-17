import { Module } from '@nestjs/common'
import { ConfigModule, ConfigService } from '@nestjs/config'
import { plainToClass } from 'class-transformer'
import { validateSync, ValidatorOptions } from 'class-validator'
import { ValidationError } from 'class-validator/types/validation/ValidationError'

import { ConfigurationService } from './configuration.service'
import { EnvironmentVariablesDto } from './dto/environment-variables.dto'

@Module({
  exports: [ConfigurationService],
  imports: [
    ConfigModule.forRoot({
      cache: true,
      envFilePath: `.env.${process.env.NODE_ENV as string}`,
      validate: (config: Record<string, string>): EnvironmentVariablesDto => {
        const defaultOptions: ValidatorOptions = {
          forbidNonWhitelisted: false,
          forbidUnknownValues: false,
          skipMissingProperties: false,
          skipNullProperties: false,
          skipUndefinedProperties: false,
          validationError: {
            value: true
          },
          whitelist: false
        }

        const classToValidate: EnvironmentVariablesDto = plainToClass(EnvironmentVariablesDto, config)
        const errors: ValidationError[] = validateSync(classToValidate, defaultOptions)

        const hasErrors: boolean = errors.length > 0

        if (hasErrors) {
          console.error(`Environment variables do not much schema defined in ${EnvironmentVariablesDto.name}!\n`)
          console.error(
            errors
              .map((error: ValidationError): string => {
                if (error.constraints === undefined) {
                  return ``
                }

                const constraints: string = Object.values(error.constraints)
                  .map((constraint: string): string => `- ${constraint}\n`)
                  .join(``)

                return `Property ${error.property} has failed the following validation constraints:\n${constraints}`
              })
              .join(`\n`)
          )
        }

        return classToValidate
      }
    })
  ],
  providers: [ConfigurationService, ConfigService]
})
export class ConfigurationModule {}
