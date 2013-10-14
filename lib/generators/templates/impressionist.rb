# Setup a different ORM
# default is active_record
# Impressionist::ORM.orm = :active_record

<%= ("Impressionist::ORM.orm = :#{options[:orm].to_s}") if options[:orm] %>

Impressionist::Minion::MinionCreator.banana_potato do
# Add minions to a controllers
# add(:posts, :index, :edit)

end
