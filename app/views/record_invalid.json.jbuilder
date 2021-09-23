json.errors do
  json.merge! @error.record.errors.full_messages
end