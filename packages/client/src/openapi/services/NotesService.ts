/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { CreateNoteBodyDto } from '../models/CreateNoteBodyDto';
import type { NoteDto } from '../models/NoteDto';
import type { CancelablePromise } from '../core/CancelablePromise';
import { request as __request } from '../core/request';

export class NotesService {

    /**
     * @param requestBody
     * @returns NoteDto The note was successfully created.
     * @throws ApiError
     */
    public static notesControllerCreateNote(
        requestBody: CreateNoteBodyDto,
    ): CancelablePromise<NoteDto> {
        return __request({
            method: 'POST',
            path: `/notes`,
            body: requestBody,
            mediaType: 'application/json',
        });
    }

    /**
     * @returns NoteDto The list of notes has been successfully fetched.
     * @throws ApiError
     */
    public static notesControllerGetAllNotes(): CancelablePromise<Array<NoteDto>> {
        return __request({
            method: 'GET',
            path: `/notes`,
        });
    }

    /**
     * @param id Unique identifier of a note.
     * @returns void
     * @throws ApiError
     */
    public static notesControllerDeleteNote(
        id: string,
    ): CancelablePromise<void> {
        return __request({
            method: 'DELETE',
            path: `/notes/${id}`,
        });
    }

}