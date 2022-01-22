import { Injectable } from '@nestjs/common'
import { NotesRepository } from './notes.repository'
import { CreateNoteBodyDto, DeleteNoteParamsDto, NoteDto } from './note.dto'

@Injectable()
export class NotesService {
  public constructor(private readonly notesRepository: NotesRepository) {}

  public async createNote(args: CreateNoteBodyDto): Promise<NoteDto> {
    return await this.notesRepository.save(args)
  }

  public async getAllNotes(): Promise<NoteDto[]> {
    return this.notesRepository.find()
  }

  public async deleteNote(args: DeleteNoteParamsDto): Promise<void> {
    await this.notesRepository.delete(args)
  }
}
