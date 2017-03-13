unless Hanami.env == 'test'
  Facebook::Messenger::Subscriptions.subscribe(access_token: ENV['ACCESS_TOKEN'])

  Facebook::Messenger::Thread.set({
                                    setting_type: 'call_to_actions',
                                    thread_state: 'new_thread',
                                    call_to_actions: [{
                                      payload: 'WELCOME_PAYLOAD'
                                    }]
                                  }, access_token: ENV['ACCESS_TOKEN'])

  Facebook::Messenger::Thread.set({
                                    setting_type: 'call_to_actions',
                                    thread_state: 'existing_thread',
                                    call_to_actions: [{
                                      type: 'postback',
                                      title: 'About EL Passion',
                                      payload: 'ABOUT_US'
                                    },
                                    {
                                      type:'postback',
                                      title: 'I want to find a job!',
                                      payload: 'JOB_OFFERS'
                                    },
                                    {
                                      type: 'postback',
                                      title: 'Help me, please!',
                                      payload: 'HELP'
                                    }]
                                  }, access_token: ENV['ACCESS_TOKEN'])
end
