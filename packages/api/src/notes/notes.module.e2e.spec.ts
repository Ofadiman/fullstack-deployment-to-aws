import { HttpStatus, INestApplication } from '@nestjs/common'
import { AppModule } from '../app.module'
import { Test, TestingModule } from '@nestjs/testing'
import * as request from 'supertest'
import { CreateNoteBodyDto } from './note.dto'
import { getConnection, Connection } from 'typeorm'
import { NoteEntity } from './note.entity'
import { Repository } from 'typeorm/repository/Repository'

const firstNote = {
  description: 'Capios cantare!'
}
const secondNote = {
  description: 'Ire grauiter ducunt ad altus omnia.'
}
const thirdNote = {
  description: 'Xiphiass nocere!'
}

describe('notes e2e', () => {
  let connection: Connection
  let nestApplication: INestApplication
  let notesRepository: Repository<NoteEntity>

  beforeAll(async () => {
    const testingModule: TestingModule = await Test.createTestingModule({
      imports: [AppModule]
    }).compile()

    connection = testingModule.get<Connection>(Connection)
    notesRepository = connection.getRepository(NoteEntity)
    nestApplication = testingModule.createNestApplication()
    await nestApplication.init()
  })

  afterAll(async () => {
    await nestApplication.close()
    await connection.close()
  })

  beforeEach(async () => {
    await notesRepository.insert([firstNote, secondNote, thirdNote])
  })

  afterEach(async () => {
    for (const entity of connection.entityMetadatas) {
      const repository = getConnection().getRepository(entity.name)
      await repository.clear()
    }
  })

  describe('POST /notes', () => {
    test('when user sends a valid request body then it should create a note in database', async () => {
      const body: CreateNoteBodyDto = {
        description: 'Alter, clemens sensorems solite imperium de rusticus, audax cursus.'
      }

      const response = await request(nestApplication.getHttpServer()).post('/notes').send(body)

      expect(response.body).toStrictEqual({
        ...body,
        id: expect.any(String),
        create_date: expect.any(String),
        update_date: expect.any(String)
      })
      expect(response.statusCode).toStrictEqual(HttpStatus.CREATED)
    })

    test('when user sends an invalid request body then it should return bad request exception', async () => {
      const body = {
        foo: 'bar'
      }

      const response = await request(nestApplication.getHttpServer()).post('/notes').send(body)

      expect(response.statusCode).toStrictEqual(HttpStatus.BAD_REQUEST)
    })
  })

  describe('GET /notes', () => {
    test('when user sends a get request then it should return all notes from database', async () => {
      const response = await request(nestApplication.getHttpServer()).get('/notes').send()

      expect(response.statusCode).toStrictEqual(HttpStatus.OK)
      expect(response.body).toStrictEqual([
        {
          ...firstNote,
          id: expect.any(String),
          create_date: expect.any(String),
          update_date: expect.any(String)
        },
        {
          ...secondNote,
          id: expect.any(String),
          create_date: expect.any(String),
          update_date: expect.any(String)
        },
        {
          ...thirdNote,
          id: expect.any(String),
          create_date: expect.any(String),
          update_date: expect.any(String)
        }
      ])
    })
  })

  describe('DELETE /notes/:id', () => {
    test('when user sends a request to delete a note then it should delete the note from database', async () => {
      const noteToDelete = await notesRepository.findOneOrFail({ where: { description: firstNote.description } })

      const response = await request(nestApplication.getHttpServer()).delete(`/notes/${noteToDelete.id}`).send()

      const notesInDatabase = await notesRepository.find()
      const deletedNote = notesInDatabase.find((noteEntity) => noteEntity.id === noteToDelete.id)

      expect(response.statusCode).toStrictEqual(HttpStatus.NO_CONTENT)
      expect(notesInDatabase).toHaveLength(2)
      expect(deletedNote).toBeUndefined()
    })
  })
})
