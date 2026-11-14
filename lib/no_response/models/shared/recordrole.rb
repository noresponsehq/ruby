# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # RecordRole - Which common field a value is, where many sources share it: a join date and a birth date are both dates, with the roles joined and born. A platform account's field and a breach row's column with the same meaning carry the same kind and role. A linked_account field is named by its network. Absent for a field only its source returns. Each role's description names the kinds its values have.
      class RecordRole
        include ::Crystalline::Enum
        enums do
          # The platform's own id for the account (`account_id`).
          ACCOUNT_ID = new("account_id")
          # The state of the account, such as active or suspended (`label`).
          ACCOUNT_STATUS = new("account_status")
          # The sort of account, such as personal or business (`label`).
          ACCOUNT_TYPE = new("account_type")
          # A mobile, alternate or fax number beside the main one (`phone`).
          ALTERNATE_PHONE = new("alternate_phone")
          # Money held on the account (`amount`).
          BALANCE = new("balance")
          # Whether the site banned the account (`flag`).
          BANNED = new("banned")
          # What the person wrote about themselves (`long_text`).
          BIO = new("bio")
          # The date of birth (`date` or `date_time`).
          BORN = new("born")
          # Whether the site marks the account as a bot (`flag`).
          BOT = new("bot")
          # The category callers give a phone number, such as telemarketer (`label`).
          CALLER_CATEGORY = new("caller_category")
          # How many chargebacks a shop recorded against the account, or whether it has one (`count` or `flag`).
          CHARGEBACKS = new("chargebacks")
          # The banner picture of the profile (`image`).
          COVER_PICTURE = new("cover_picture")
          # How many of the account's payments a shop declined (`count`).
          DECLINES = new("declines")
          # Whether the account is deleted or inactive (`flag`).
          DELETED = new("deleted")
          # When the account was deleted (`date` or `date_time`).
          DELETED_ON = new("deleted_on")
          # A department the source names (`text`).
          DEPARTMENT = new("department")
          # The name the account shows (`person_name`).
          DISPLAY_NAME = new("display_name")
          # Whether the site verified the email (`flag`).
          EMAIL_VERIFIED = new("email_verified")
          # When the account or its subscription expires (`date` or `date_time`).
          EXPIRES = new("expires")
          # A first name (`person_name`).
          FIRST_NAME = new("first_name")
          # How many accounts follow the account (`count`).
          FOLLOWERS = new("followers")
          # How many accounts the account follows (`count`).
          FOLLOWING = new("following")
          # How many friends the account has (`count`).
          FRIENDS = new("friends")
          # A whole postal address on one line (`address`).
          FULL_ADDRESS = new("full_address")
          # A whole name (`person_name`).
          FULL_NAME = new("full_name")
          # The handle of the account (`username`).
          HANDLE = new("handle")
          # A headline or user title shown with the name (`text`).
          HEADLINE = new("headline")
          # Interests the person lists (`text`).
          INTERESTS = new("interests")
          # A job title the source states (`job_title`).
          JOB_TITLE = new("job_title")
          # When the account was made (`date` or `date_time`).
          JOINED = new("joined")
          # When the account was last active (`date` or `date_time`).
          LAST_ACTIVE = new("last_active")
          # The IP the account last used (`ip`).
          LAST_IP = new("last_ip")
          # A last name (`person_name`).
          LAST_NAME = new("last_name")
          # When the account last posted (`date` or `date_time`).
          LAST_POST = new("last_post")
          # When the account or its profile last changed (`date` or `date_time`).
          LAST_UPDATED = new("last_updated")
          # A level or rank on the site (`label`).
          LEVEL = new("level")
          # How many likes the account gave (`count`).
          LIKES_GIVEN = new("likes_given")
          # How many likes the account received (`count`).
          LIKES_RECEIVED = new("likes_received")
          # The line type of a phone number, such as mobile or VoIP (`label`).
          LINE_TYPE = new("line_type")
          # An account on another network. The field's name names the network (`username`, `account_id` or `url`).
          LINKED_ACCOUNT = new("linked_account")
          # A place as the person wrote it (`text`).
          LOCATION = new("location")
          # Whether callers mark a phone number as spam (`flag`).
          MARKED_SPAM = new("marked_spam")
          # A middle name (`person_name`).
          MIDDLE_NAME = new("middle_name")
          # A nationality (`country`).
          NATIONALITY = new("nationality")
          # An organisation the source names, such as a company (`organisation`).
          ORGANISATION = new("organisation")
          # An IP whose use the source does not say (`ip`).
          OTHER_IP = new("other_ip")
          # Whether the account is paid or premium (`flag`).
          PAID = new("paid")
          # When the password last changed (`date` or `date_time`).
          PASSWORD_CHANGED = new("password_changed")
          # The payment method or card brand the account paid with (`label`).
          PAYMENT_METHOD = new("payment_method")
          # The profile picture (`image`).
          PICTURE = new("picture")
          # Points on the site (`score`).
          POINTS = new("points")
          # How many posts the account made (`count`).
          POSTS = new("posts")
          # Whether the account is private (`flag`).
          PRIVATE = new("private")
          # The link to the profile (`url`).
          PROFILE_LINK = new("profile_link")
          # How many times people viewed the profile (`count`).
          PROFILE_VIEWS = new("profile_views")
          # A rating of the account (`score`).
          RATING = new("rating")
          # How many people the account referred (`count`).
          REFERRALS = new("referrals")
          # Who or what referred the account (`text`).
          REFERRER = new("referrer")
          # How many reports callers made on a phone number (`count`).
          REPORT_COUNT = new("report_count")
          # Reputation on the site (`score`).
          REPUTATION = new("reputation")
          # A reputation label for a phone number (`label`).
          REPUTATION_LABEL = new("reputation_label")
          # The country the person lives in (`country`).
          RESIDENCE = new("residence")
          # A salutation or suffix, such as Dr or Jr (`text`).
          SALUTATION = new("salutation")
          # A school the source names (`organisation`).
          SCHOOL = new("school")
          # A signature the person posts under (`long_text`).
          SIGNATURE = new("signature")
          # The IP the account was made from (`ip`).
          SIGNUP_IP = new("signup_ip")
          # A role on the site, such as admin or moderator (`label`).
          SITE_ROLE = new("site_role")
          # How likely a phone number is spam, as the source scores it (`score`).
          SPAM_SCORE = new("spam_score")
          # A street line of an address (`address`).
          STREET = new("street")
          # How many trades a forum account completed (`count`).
          TRADES = new("trades")
          # Whether the site verified the account (`flag`).
          VERIFIED = new("verified")
          # Warnings and infractions on the account (`count`).
          WARNINGS = new("warnings")
          # A website the person lists (`url`).
          WEBSITE = new("website")
        end

        open!
      end
    end
  end
end
