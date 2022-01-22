import { BadRequestException, Module, ValidationPipe } from '@nestjs/common'
import { AppController } from './app.controller'
import { AppService } from './app.service'
import { ConfigurationModule } from './configuration/configuration.module'
import { DatabaseModule } from './database/database.module'
import { NotesModule } from './notes/notes.module'
import { APP_PIPE } from '@nestjs/core'
import { ValidationError } from 'class-validator/types/validation/ValidationError'

@Module({
  imports: [ConfigurationModule, DatabaseModule, NotesModule],
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
