import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, Post } from '@nestjs/common'
import { NotesService } from './notes.service'
import { ApiCreatedResponse, ApiNoContentResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger'
import { CreateNoteBodyDto, DeleteNoteParamsDto, NoteDto } from './notes.dto'

@Controller('notes')
@ApiTags('notes')
export class NotesController {
  public constructor(private readonly notesService: NotesService) {}

  @Post()
  @ApiCreatedResponse({ description: 'The note was successfully created.', type: NoteDto })
  public async createNote(@Body() createNoteBodyDto: CreateNoteBodyDto): Promise<NoteDto> {
    return this.notesService.createNote(createNoteBodyDto)
  }

  @Get()
  @ApiOkResponse({ description: 'The list of notes has been successfully fetched.', type: [NoteDto] })
  public async getAllNotes(): Promise<NoteDto[]> {
    return this.notesService.getAllNotes()
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiNoContentResponse({ description: 'The note was successfully deleted.' })
  public async deleteNote(@Param() params: DeleteNoteParamsDto): Promise<void> {
    return this.notesService.deleteNote(params)
  }
}
