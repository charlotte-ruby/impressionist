# Setup a different ORM
<%= ("Impressionist::ORM.orm = :" + options[:orm]) if options[:orm] %>

Impressionist::Minion::MinionCreator.banana_potato do
# Add minions to a controllers
# add(:posts, :index, :edit)

end
