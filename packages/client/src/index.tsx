import React from 'react'
import ReactDOM from 'react-dom'
import { App } from './App'
import reportWebVitals from './reportWebVitals'
import CssBaseline from '@mui/material/CssBaseline'
import { NotesService, OpenAPI } from './openapi'

OpenAPI.BASE = process.env.REACT_APP_BACKEND_URL ?? ''

const notesApi = {
  createNote: NotesService.notesControllerCreateNote,
  getAllNotes: NotesService.notesControllerGetAllNotes,
  deleteNote: NotesService.notesControllerDeleteNote
} as const

export type NotesApi = typeof notesApi

ReactDOM.render(
  <React.StrictMode>
    <CssBaseline />
    <App notesApi={notesApi} />
  </React.StrictMode>,
  document.getElementById('root')
)

reportWebVitals()
