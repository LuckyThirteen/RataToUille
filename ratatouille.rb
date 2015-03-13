require './environment'

Cuba.define do
  on get do
    on 'ohai' do
      res.write 'O HAI'
    end

    on root do
      res.redirect '/ohai'
    end

    on 'callback' do
      challenge = Koala::Facebook::RealtimeUpdates.meet_challenge req.params, ENV['VERIFY_TOKEN']
      res.write challenge
    end

    on 'subscribe' do
      updates = Koala::Facebook::RealtimeUpdates.new app_id: ENV['FACEBOOK_APP_ID'],
                                                     secret: ENV['FACEBOOK_APP_SECRET']
      updates.subscribe 'user',
                        ENV['FACEBOOK_PERMISSIONS'],
                        ENV['CALLBACK_URL'],
                        ENV['VERIFY_TOKEN']
      res.write 'ok'
    end

    on 'log' do
      res.write File.open('log.txt', 'r').read
    end
  end

  on post do
    on 'callback' do
      File.open('log.txt', 'a') do |f|
        f.write "--------------------#{Time.now}--------------------<br />"
          f.write JSON.parse(req.body.read).inspect
        f.write "----------------------------------------<br />"
      end

      res.write 'ok'
    end
  end
end
