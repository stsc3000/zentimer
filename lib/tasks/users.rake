namespace :users do
  desc "creates a new user"
  task :new => :environment do
    TAGS = %w(Development Integration Team-Meeting Customer-Meeting)
    PROJECTS = %w(CoffeeInc TeaInc BigCorp SmallCorp)
    user = User.create(tags: TAGS, projects: PROJECTS)
    10.times do 
      user.entries.create tag_list: TAGS.sample(2),
                          project: PROJECTS.sample,
                          elapsed: (rand * 10000).to_i,
                          lastTick: Time.now - (rand * 1000).seconds
    end

    (1..10).each do |i|
      10.times do 
         last_update = Time.now - i.days - (rand * 1000).seconds
         e = user.entries.create tag_list: TAGS.sample(2),
                            project: PROJECTS.sample,
                            elapsed: (rand * 10000).to_i,
                            lastTick: last_update
         e.update_column "updated_at", last_update
      end
    end

    puts user.token
  end
end
