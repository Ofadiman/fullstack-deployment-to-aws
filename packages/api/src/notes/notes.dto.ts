import { IsString, IsUUID, Length } from 'class-validator'
import { ApiProperty, PickType } from '@nestjs/swagger'

export class NoteDto {
  @IsUUID()
  @ApiProperty({ description: 'Unique identifier of a note.', example: '9b8e01a9-aff4-4874-b6a3-23e5dc49c34c' })
  public id: string

  @IsString()
  @Length(10, 500)
  @ApiProperty({
    description: 'Description of the note.',
    maxLength: 500,
    minLength: 10,
    example: 'Flavum, nobilis valebats patienter captis de lotus, audax lumen.'
  })
  public description: string

  @ApiProperty({ description: 'The date on which the note was created.', example: '2022-01-22T12:00:00.000Z' })
  public create_date: Date

  @ApiProperty({ description: 'The date on which the note was last edited.', example: '2022-01-22T12:00:00.000Z' })
  public update_date: Date
}

export class DeleteNoteParamsDto extends PickType(NoteDto, ['id']) {}

export class CreateNoteBodyDto extends PickType(NoteDto, ['description']) {}
