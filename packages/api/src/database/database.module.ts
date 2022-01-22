import { Module } from '@nestjs/common'
import { TypeOrmModule, TypeOrmModuleOptions } from '@nestjs/typeorm'

import { ConfigurationModule } from '../configuration/configuration.module'
import { ConfigurationService } from '../configuration/configuration.service'

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      imports: [ConfigurationModule],
      inject: [ConfigurationService],
      useFactory: (configurationService: ConfigurationService): TypeOrmModuleOptions =>
        configurationService.typeOrmModuleOptions
    })
  ]
})
export class DatabaseModule {}
