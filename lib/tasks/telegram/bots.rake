namespace :telegram do
  namespace :bot do
    desc "Run only given bot"
    task :start_bot , :bot do |t, arg|
      ENV['BOT'] = arg[:bot]
      Rake::Task['telegram:bot:poller'].invoke
    end

    desc "Start masters bot"
    task :masters do
      ENV['BOT'] = 'masters'
      Rake::Task['telegram:bot:poller'].invoke
    end

    desc "Start organizers bot"
    task :organizers do
      ENV['BOT'] = 'organizers'
      Rake::Task['telegram:bot:poller'].invoke
    end

    desc "Start group bot"
    task :group do
      ENV['BOT'] = 'group'
      Rake::Task['telegram:bot:poller'].invoke
    end
  end
end