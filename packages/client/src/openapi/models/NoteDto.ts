/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */

export type NoteDto = {
    /**
     * Unique identifier of a note.
     */
    id: string;
    /**
     * Description of the note.
     */
    description: string;
    /**
     * The date on which the note was created.
     */
    create_date: string;
    /**
     * The date on which the note was last edited.
     */
    update_date: string;
}
