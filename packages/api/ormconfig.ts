import { ConfigService } from '@nestjs/config'
import { config } from 'dotenv'

import { ConfigurationService } from './src/configuration/configuration.service'

config({ path: `.env.${process.env.NODE_ENV as string}` })

const configurationService: ConfigurationService = new ConfigurationService(new ConfigService())

module.exports = configurationService.typeOrmModuleOptions
