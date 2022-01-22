import React, { FormEvent, Fragment, MouseEventHandler, useEffect, useState } from 'react'
import { NotesApi } from './index'
import { NoteDto } from './openapi'
import {
  Button,
  Grid,
  IconButton,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TextField
} from '@mui/material'
import { CloseRounded } from '@mui/icons-material'

type AppProps = {
  notesApi: NotesApi
}

const hasNotes = (notes: NoteDto[]): boolean => {
  return notes.length !== 0
}

export function App(props: AppProps) {
  const [description, setDescription] = useState('')
  const [notes, setNotes] = useState<NoteDto[]>([])

  const handleSubmit = async (event: FormEvent) => {
    event.preventDefault()

    const createdNote = await props.notesApi.createNote({ description })
    setDescription('')
    setNotes((prevNotes) => [...prevNotes, createdNote])
  }

  const handleChange: React.ChangeEventHandler<HTMLTextAreaElement | HTMLInputElement> = (event) => {
    setDescription(event.target.value)
  }

  const handleNoteDelete: MouseEventHandler = async (event) => {
    const id = event.currentTarget.id

    await props.notesApi.deleteNote(id)
    setNotes((prevNotes) => prevNotes.filter((note) => note.id !== id))
  }

  useEffect(() => {
    void (async () => {
      try {
        const result = await props.notesApi.getAllNotes()

        setNotes(result)
      } catch (error) {
        console.debug(`[DEBUG] error`)
        console.debug(`[DEBUG] ${JSON.stringify(error)}`)
      }
    })()
  }, [])

  return (
    <Paper
      sx={{
        margin: '2rem',
        padding: '1rem'
      }}
    >
      <form onSubmit={handleSubmit} noValidate autoComplete="off">
        <Grid container spacing={2}>
          <Grid item xs={12}>
            <TextField
              fullWidth={true}
              id="description"
              name={'description'}
              label="Description"
              variant="outlined"
              value={description}
              onChange={handleChange}
            />
          </Grid>
          <Grid item xs={12}>
            <Button fullWidth={true} type={'submit'}>
              Submit
            </Button>
          </Grid>
        </Grid>
      </form>
      {hasNotes(notes) ? (
        <TableContainer
          component={Paper}
          sx={{
            marginTop: '1rem'
          }}
        >
          <Table aria-label="Notes table">
            <TableHead>
              <TableRow>
                <TableCell>Id</TableCell>
                <TableCell align="right">Description</TableCell>
                <TableCell align="right">Create date</TableCell>
                <TableCell align="right">Update date</TableCell>
                <TableCell align="right">Action</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {notes.map((note) => {
                return (
                  <TableRow key={note.id} sx={{ '&:last-child td, &:last-child th': { border: 0 } }}>
                    <TableCell component="th" scope="row">
                      {note.id}
                    </TableCell>
                    <TableCell align="right">{note.description}</TableCell>
                    <TableCell align="right">{note.create_date}</TableCell>
                    <TableCell align="right">{note.update_date}</TableCell>
                    <TableCell align="right">
                      <IconButton id={note.id} onClick={handleNoteDelete}>
                        <CloseRounded />
                      </IconButton>
                    </TableCell>
                  </TableRow>
                )
              })}
            </TableBody>
          </Table>
        </TableContainer>
      ) : (
        <Fragment>No notes</Fragment>
      )}
    </Paper>
  )
}
