module Encryptable
  extend ActiveSupport::Concern

  class_methods do
    # Helper to detect if ActiveRecord Encryption is configured for this app.
    # Runtime configuration includes the keys derived from SECRET_KEY_BASE for
    # self-hosted installations, as well as explicit env/credential keys.
    def encryption_ready?
      ActiveRecordEncryptionConfig.ready?
    end
  end
end
