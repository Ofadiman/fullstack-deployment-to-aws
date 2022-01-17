import { NestFactory } from '@nestjs/core'
import { AppModule } from './app.module'
import { ConfigurationService } from './configuration/configuration.service'
import { EnvironmentVariables } from './configuration/enums/environment-variables.enum'

async function bootstrap() {
  const app = await NestFactory.create(AppModule)

  const configurationService = app.get(ConfigurationService)
  await app.listen(configurationService.get(EnvironmentVariables.ServerPort))
}

bootstrap()
