# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # RecordRole - Which common field a value is, where many sources share it: a join date and a birth date are both dates, with the roles joined and born. A platform account's field and a breach row's column with the same meaning carry the same kind and role. A linked_account field is named by its network. Absent for a field only its source returns.
      class RecordRole
        include ::Crystalline::Enum
        enums do
          ACCOUNT_ID = new("account_id")
          ACCOUNT_STATUS = new("account_status")
          ACCOUNT_TYPE = new("account_type")
          ALTERNATE_PHONE = new("alternate_phone")
          BALANCE = new("balance")
          BANNED = new("banned")
          BIO = new("bio")
          BORN = new("born")
          BOT = new("bot")
          CALLER_CATEGORY = new("caller_category")
          COVER_PICTURE = new("cover_picture")
          DELETED = new("deleted")
          DELETED_ON = new("deleted_on")
          DEPARTMENT = new("department")
          DISPLAY_NAME = new("display_name")
          EMAIL_VERIFIED = new("email_verified")
          EXPIRES = new("expires")
          FIRST_NAME = new("first_name")
          FOLLOWERS = new("followers")
          FOLLOWING = new("following")
          FRIENDS = new("friends")
          FULL_ADDRESS = new("full_address")
          FULL_NAME = new("full_name")
          HANDLE = new("handle")
          HEADLINE = new("headline")
          INTERESTS = new("interests")
          JOB_TITLE = new("job_title")
          JOINED = new("joined")
          LAST_ACTIVE = new("last_active")
          LAST_IP = new("last_ip")
          LAST_NAME = new("last_name")
          LAST_POST = new("last_post")
          LAST_UPDATED = new("last_updated")
          LEVEL = new("level")
          LIKES_GIVEN = new("likes_given")
          LIKES_RECEIVED = new("likes_received")
          LINE_TYPE = new("line_type")
          LINKED_ACCOUNT = new("linked_account")
          LOCATION = new("location")
          MARKED_SPAM = new("marked_spam")
          MIDDLE_NAME = new("middle_name")
          NATIONALITY = new("nationality")
          ORGANISATION = new("organisation")
          OTHER_IP = new("other_ip")
          PAID = new("paid")
          PASSWORD_CHANGED = new("password_changed")
          PICTURE = new("picture")
          POINTS = new("points")
          POSTS = new("posts")
          PRIVATE = new("private")
          PROFILE_LINK = new("profile_link")
          PROFILE_VIEWS = new("profile_views")
          RATING = new("rating")
          REFERRALS = new("referrals")
          REFERRER = new("referrer")
          REPORT_COUNT = new("report_count")
          REPUTATION = new("reputation")
          REPUTATION_LABEL = new("reputation_label")
          RESIDENCE = new("residence")
          SALUTATION = new("salutation")
          SCHOOL = new("school")
          SIGNATURE = new("signature")
          SIGNUP_IP = new("signup_ip")
          SITE_ROLE = new("site_role")
          SPAM_SCORE = new("spam_score")
          STREET = new("street")
          VERIFIED = new("verified")
          WARNINGS = new("warnings")
          WEBSITE = new("website")
        end

        open!
      end
    end
  end
end
