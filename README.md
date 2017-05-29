[![Build Status](https://travis-ci.com/elpassion/messenger-bot.svg?token=NWdyptbVPpAmiYqrQqZx&branch=master)](https://travis-ci.com/elpassion/messenger-bot)
# 🤖⭐️🤖 EL Passion Career Bot 🤖⭐️🤖
### 👉 Developer Setup (without [wit.ai](https://wit.ai/)) 👈
1. After cloning the repo, go to [Messenger Platform Quick Start](https://developers.facebook.com/docs/messenger-platform/guides/quick-start) and follow the instructions. You will need to create Facebook Page & App and provide `ACCESS_TOKEN`, `APP_SECRET` variables to `.env.development` file (you can find all useful variable names in `.env.sample` - you can copy it to your .env file and then paste your variables). 

2. To setup Webhook you need to use ngrok and https URL: `https://<ngrok_address>/bot`. Then, with verify token matching the one from .env file and running server (`hanami s`), you should be able to Verify and Save the Webhook. 

3. Don't forget to subscribe the webhook for your Page! 😃 

4. Your application is now working and responding to postback requests. 🎉 You are still unable to fetch job offers until you provide `WORKABLE_API_KEY` variable.

### 👉 Add [wit.ai](https://wit.ai/) to your application 👈
1. Go to wit.ai home page and create new application to get `WIT_ACCESS_TOKEN`. For more information: [wit.ai quickstart](https://wit.ai/docs/quickstart) is here 😉.

2. Paste `WIT_ACCESS_TOKEN` to .env in career_bot application.

3. We use Sidekiq to handle Wit.ai requests and responses, so you need to start it locally (you can use following command: `bundle exec sidekiq -e development -c 5 -r ./config/environment.rb`)

4. Voila! Now you can add stories to wit.ai (see [quickstart](https://wit.ai/docs/quickstart) for details) and test them  writing with Bot. Enjoy! 😄
