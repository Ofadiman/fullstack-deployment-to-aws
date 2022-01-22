import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn, UpdateDateColumn } from 'typeorm'

@Entity({ name: 'notes' })
export class NoteEntity {
  @PrimaryGeneratedColumn('uuid')
  public id: string

  @CreateDateColumn()
  create_date: Date

  @UpdateDateColumn()
  update_date: Date

  @Column({ type: 'varchar', length: 500 })
  public description: string
}
