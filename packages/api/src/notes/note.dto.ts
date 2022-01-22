import { IsString, IsUUID, Length } from 'class-validator'

export class CreateNoteBodyDto {
  @IsString()
  @Length(10, 500)
  public description: string
}

export class DeleteNoteParamsDto {
  @IsUUID()
  public id: string
}

export class NoteDto {
  public create_date: Date
  public description: string
  public id: string
  public update_date: Date
}
