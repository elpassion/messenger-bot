Facebook::Messenger::Subscriptions.subscribe(access_token: ENV['ACCESS_TOKEN'])

Facebook::Messenger::Thread.set({
                                  setting_type: 'call_to_actions',
                                  thread_state: 'new_thread',
                                  call_to_actions: [{
                                    payload: 'WELCOME_PAYLOAD'
                                  }]
                                }, access_token: ENV['ACCESS_TOKEN'])
