import {MigrationInterface, QueryRunner} from "typeorm";

export class createNotes1642842488330 implements MigrationInterface {
    name = 'createNotes1642842488330'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            CREATE TABLE "notes" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "create_date" TIMESTAMP NOT NULL DEFAULT now(),
                "update_date" TIMESTAMP NOT NULL DEFAULT now(),
                "description" character varying(500) NOT NULL,
                CONSTRAINT "PK_af6206538ea96c4e77e9f400c3d" PRIMARY KEY ("id")
            )
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            DROP TABLE "notes"
        `);
    }

}
