# typed: true
# frozen_string_literal: true

class NoResponse::Models::Shared::OperationalAggregateQueue
  extend ::Crystalline::MetadataFields::ClassMethods
end

class NoResponse::Models::Shared::OperationalAggregateQueue
  def pending
  end

  def pending=(str_)
  end

  def leased
  end

  def leased=(str_)
  end

  def dead_retained
  end

  def dead_retained=(str_)
  end

  def oldest_pending_at
  end

  def oldest_pending_at=(str_)
  end
end
