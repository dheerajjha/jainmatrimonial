-- AlterTable
ALTER TABLE "profiles" ADD COLUMN "photos" TEXT[] DEFAULT ARRAY[]::TEXT[];
