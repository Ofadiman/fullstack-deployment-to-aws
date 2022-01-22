import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, Post } from '@nestjs/common'
import { NotesService } from './notes.service'
import { CreateNoteBodyDto, DeleteNoteParamsDto, NoteDto } from './note.dto'

@Controller('notes')
export class NotesController {
  public constructor(private readonly notesService: NotesService) {}

  @Post()
  public async createNote(@Body() createNoteBodyDto: CreateNoteBodyDto): Promise<NoteDto> {
    return this.notesService.createNote(createNoteBodyDto)
  }

  @Get()
  public async getAllNotes(): Promise<NoteDto[]> {
    return this.notesService.getAllNotes()
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  public async deleteNote(@Param() params: DeleteNoteParamsDto): Promise<void> {
    return this.notesService.deleteNote(params)
  }
}
