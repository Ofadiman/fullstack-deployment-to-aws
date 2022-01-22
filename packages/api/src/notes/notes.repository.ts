import { EntityRepository, Repository } from 'typeorm'
import { NoteEntity } from './note.entity'

@EntityRepository(NoteEntity)
export class NotesRepository extends Repository<NoteEntity> {}
