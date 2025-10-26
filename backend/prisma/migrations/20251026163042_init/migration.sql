-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "is_verified" BOOLEAN NOT NULL DEFAULT false,
    "otp_code" TEXT,
    "otp_expires_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "profiles" (
    "id" TEXT NOT NULL,
    "profile_code" TEXT NOT NULL,
    "parent_user_id" TEXT,
    "child_user_id" TEXT,
    "parent_name" TEXT,
    "relation" TEXT,
    "parent_contact" TEXT,
    "child_full_name" TEXT,
    "child_gender" TEXT,
    "date_of_birth" TIMESTAMP(3),
    "city" TEXT,
    "basic_education" TEXT,
    "life_goals" TEXT,
    "travelled_places" TEXT[],
    "education" TEXT,
    "profession" TEXT,
    "current_city" TEXT,
    "religious_practice" TEXT,
    "food_habits" TEXT,
    "family_details" TEXT,
    "status" TEXT NOT NULL DEFAULT 'draft',
    "shareable_link" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "completed_at" TIMESTAMP(3),

    CONSTRAINT "profiles_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_number_key" ON "users"("phone_number");

-- CreateIndex
CREATE UNIQUE INDEX "profiles_profile_code_key" ON "profiles"("profile_code");

-- CreateIndex
CREATE INDEX "profiles_profile_code_idx" ON "profiles"("profile_code");

-- CreateIndex
CREATE INDEX "profiles_parent_user_id_idx" ON "profiles"("parent_user_id");

-- CreateIndex
CREATE INDEX "profiles_child_user_id_idx" ON "profiles"("child_user_id");

-- CreateIndex
CREATE INDEX "profiles_status_idx" ON "profiles"("status");

-- AddForeignKey
ALTER TABLE "profiles" ADD CONSTRAINT "profiles_parent_user_id_fkey" FOREIGN KEY ("parent_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profiles" ADD CONSTRAINT "profiles_child_user_id_fkey" FOREIGN KEY ("child_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
