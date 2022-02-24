import { BadRequestException, Module, ValidationPipe } from '@nestjs/common'
import { AppController } from './app.controller'
import { AppService } from './app.service'
import { ConfigurationModule } from './configuration/configuration.module'
import { DatabaseModule } from './database/database.module'
import { NotesModule } from './notes/notes.module'
import { APP_PIPE } from '@nestjs/core'
import { ValidationError } from 'class-validator/types/validation/ValidationError'
import { ServeStaticModule } from '@nestjs/serve-static'
import { ConfigurationService } from './configuration/configuration.service'
import { join } from 'path'

@Module({
  imports: [
    ConfigurationModule,
    DatabaseModule,
    NotesModule,
    ServeStaticModule.forRootAsync({
      imports: [ConfigurationModule],
      inject: [ConfigurationService],
      useFactory: async (configurationService: ConfigurationService) => {
        if (configurationService.isRemote) {
          return [
            {
              rootPath: join(process.cwd(), 'build')
            }
          ]
        }
        return []
      }
    })
  ],
  controllers: [AppController],
  providers: [
    AppService,
    {
      provide: APP_PIPE,
      useValue: new ValidationPipe({
        disableErrorMessages: true,
        exceptionFactory: (errors: ValidationError[]): BadRequestException => {
          return new BadRequestException(errors)
        },
        forbidNonWhitelisted: true,
        forbidUnknownValues: true,
        transform: true,
        validationError: {
          target: false,
          value: true
        }
      })
    }
  ]
})
export class AppModule {}
