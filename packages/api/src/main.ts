import { NestFactory } from '@nestjs/core'
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger'
import { AppModule } from './app.module'
import { ConfigurationService } from './configuration/configuration.service'
import { EnvironmentVariables } from './configuration/enums/environment-variables.enum'
import * as basicAuth from 'express-basic-auth'

enum SwaggerRoutes {
  Docs = `/docs`,
  DocsJson = `/docs-json`
}

async function bootstrap() {
  const app = await NestFactory.create(AppModule)

  app.use(
    Object.values(SwaggerRoutes),
    basicAuth({
      challenge: true,
      users: {
        admin: 'password'
      }
    })
  )

  const swaggerParams = new DocumentBuilder()
    .setTitle('Swagger documentation example.')
    .setDescription('API description.')
    .setVersion(`v1`)
    .addBearerAuth()
    .build()

  const document = SwaggerModule.createDocument(app, swaggerParams)
  SwaggerModule.setup(SwaggerRoutes.Docs, app, document)

  const configurationService = app.get(ConfigurationService)
  await app.listen(configurationService.get(EnvironmentVariables.ServerPort))
}

bootstrap()
