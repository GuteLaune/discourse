# frozen_string_literal: true

class ProblemCheck::S3BackupConfig < ProblemCheck
  self.priority = "low"

  def call
    return no_problem if GlobalSetting.use_s3?
    return no_problem if SiteSetting.backup_location != BackupLocationSiteSetting::S3
    return no_problem if !missing_keys? && SiteSetting.s3_backup_bucket.present?

    problem
  end

  private

  def missing_keys?
    return false if SiteSetting.s3_use_iam_profile

    SiteSetting.s3_access_key_id.blank? || SiteSetting.s3_secret_access_key.blank?
  end
end
