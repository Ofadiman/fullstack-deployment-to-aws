import { render, screen, waitFor } from '@testing-library/react'
import { App } from './App'
import { NotesApi } from './index'
import { NoteDto } from './openapi'

const notesApiMockFactory = () => {
  return {
    createNote: jest.fn(),
    deleteNote: jest.fn(),
    getAllNotes: jest.fn()
  }
}

const firstNote: NoteDto = {
  id: 'bd6447b7-a046-40ee-a94e-aa3e79a734a8',
  description: 'Fluctuis favere in tectum!',
  update_date: '2022-01-22T17:00:00.000Z',
  create_date: '2022-01-22T17:00:00.000Z'
}
const secondNote: NoteDto = {
  id: '6e10d7c6-b420-4980-9b49-b9a20e4a6be9',
  description: 'Est noster fides, cesaris.',
  update_date: '2022-01-22T17:00:00.000Z',
  create_date: '2022-01-22T17:00:00.000Z'
}
const thirdNote: NoteDto = {
  id: '739a61f8-d847-441f-8f38-5a979338c782',
  description: 'Monss sunt nuptias de germanus xiphias.',
  update_date: '2022-01-22T17:00:00.000Z',
  create_date: '2022-01-22T17:00:00.000Z'
}

const mockNotes = [firstNote, secondNote, thirdNote]

describe('App component', () => {
  let notesApi: Record<keyof NotesApi, jest.Mock>

  beforeEach(() => {
    notesApi = notesApiMockFactory()
  })

  it('when backend returns empty notes then it renders no notes information', async () => {
    notesApi.getAllNotes.mockResolvedValueOnce([])

    render(<App notesApi={notesApi} />)

    await waitFor(async () => {
      const element = await screen.findByText('No notes')

      expect(element).toBeInTheDocument()
    })
  })

  it('when backend returns notes then it renders all notes', async () => {
    notesApi.getAllNotes.mockResolvedValueOnce(mockNotes)

    render(<App notesApi={notesApi} />)

    await waitFor(async () => {
      const rows = await screen.findAllByTestId('table-row')

      rows.forEach((row) => {
        const note = mockNotes.find((mockNote) => mockNote.id === row.id)
        if (note === undefined) {
          throw new Error(`Mock note with id ${row.id} not found!`)
        }
        expect(row.children[0].textContent).toStrictEqual(note.id)
        expect(row.children[1].textContent).toStrictEqual(note.description)
        expect(row.children[2].textContent).toStrictEqual(note.create_date)
        expect(row.children[3].textContent).toStrictEqual(note.update_date)
      })

      expect(rows.length).toStrictEqual(3)
    })
  })
})
