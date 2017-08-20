[![Build Status](https://travis-ci.com/elpassion/messenger-bot.svg?token=NWdyptbVPpAmiYqrQqZx&branch=master)](https://travis-ci.com/elpassion/messenger-bot)
# 🤖⭐️🤖 EL Passion Career Bot 🤖⭐️🤖

### ‼️ NEW FEATURE ALERT: Application proccess via Messenger ‼️
<p align="center">
<img src="https://thumbs.gfycat.com/JubilantEmotionalGnu-size_restricted.gif">
</p>
Now you can apply for selected job offer through Messenger. Bot uses question parsed from Workable offers, saves user responses and send them back to Workable. Paste your Workable token to ENV variables to make it work - and it's done!

### 👉 Developer Setup (without [wit.ai](https://wit.ai/)) 👈
1. After cloning the repo, go to [Messenger Platform Quick Start](https://developers.facebook.com/docs/messenger-platform/guides/quick-start) and follow the instructions. You will need to create Facebook Page & App and provide `ACCESS_TOKEN`, `APP_SECRET` variables to `.env.development` file (you can find all useful variable names in `.env.sample` - you can copy it to your .env file and then paste your variables). 

2. To setup Webhook you need to use ngrok and https URL: `https://<ngrok_address>/bot`. Then, with verify token matching the one from .env file and running server (`hanami s`), you should be able to Verify and Save the Webhook. 

3. Don't forget to subscribe the webhook for your Page! 😃 

4. Your application is now working and responding to postback requests. 🎉 You are still unable to fetch job offers until you provide `WORKABLE_API_KEY` variable.

### 👉 Add [wit.ai](https://wit.ai/) to your application 👈
1. Go to wit.ai home page and create new application to get `WIT_ACCESS_TOKEN`. For more information: [wit.ai quickstart](https://wit.ai/docs/quickstart) is here 😉.

2. Paste `WIT_ACCESS_TOKEN` to .env in career_bot application.

3. We use Sidekiq to handle Wit.ai requests and responses, so you need to start it locally (use the following command: `bundle exec sidekiq -e development -c 5 -r ./config/environment.rb`)

4. Voila! Now you can add stories to Wit.ai (see [quickstart](https://wit.ai/docs/quickstart) for details) and test them  by writing with messenger-bot. Enjoy! 😄

### 👉 Using existing Wit.ai project 👈
You can start your own project from the scratch but you can also use the one created by us. You will find it [here](https://wit.ai/klaszcze/elpassion-bot-live/entities). 

**Our Wit.ai stories use following methods implemented on backend:<br/><br/>**
→ **`check_sentiment`** - used to check user's input - if there are any insult words, bot sends message with link to conversation with real person:

<p align="center">
<a href="url"><img src="http://i.imgur.com/pl8hgDc.jpg" height="60%" width="60%" ></a>
</p>

→ **`clean_context`** - cleans conversation context after game. <br/>Also, when user didn't write anything by more than 15 minutes, context cleans by default when he starts conversation with bot again. 

→ **`play_game`**, **`start_game`** - methods used in simple 'guess my number' game:

<p align="center">
<a href="url"><img src="http://i.imgur.com/79AZggX.jpg" height="60%" width="60%" ></a>
</p>

→ **`get_job`** - matches user's input with job offers parsed from Workable. There are three cases - more info [here](https://github.com/elpassion/messenger-bot/issues/52):

<p align="center">
<a href="url"><img src="http://i.imgur.com/x65somC.jpg" height="60%" width="60%" ></a>
</p>

→ **`get_details`** - gets details (benefits or requirements) about selected job offer from database:

<p align="center">
<a href="url"><img src="http://i.imgur.com/AXqp8E7.jpg" height="60%" width="60%" ></a>
</p>

→ **`get_random_answer`** - sends random 'I don't know how to reply.' message. <br/>You can find random messages in `en.yml` file, under `unrecognized` key:

<p align="center">
<a href="url"><img src="http://i.imgur.com/dtfA99L.jpg" height="60%" width="60%" ></a>
</p>

→ **`get_social_network`** - gets link to company social network requested by user. <br/>Social networks with link are predefined in `social_networks.yml` file: 

<p align="center">
<a href="url"><img src="http://i.imgur.com/ZQ6UrzA.jpg" height="60%" width="60%" ></a>
</p>

→ **`get_user`** - gets user's name from his/her Messenger account:

<p align="center">
<a href="url"><img src="http://i.imgur.com/H6xWMZZ.jpg" height="60%" width="60%" ></a>
</p>

→ **`send_error_message`** - 'when something went wrong', e.g. with Wit.ai message:

<p align="center">
<a href="url"><img src="http://i.imgur.com/088xWeQ.jpg" height="60%" width="60%" ></a>
</p>

→ **`send_random_gif`** - sends random gif with animals from Giphy:

<p align="center">
<a href="url"><img src="http://i.imgur.com/VGCMZZC.jpg" height="60%" width="60%" ></a>
</p>

→ **`show_about_us`**, **`show_main_menu`** - allows user to acces main menu and 'about us' info without clicking on buttons:

<p align="center">
<img src="http://i.imgur.com/DXYyJ61.jpg" height="60%" width="60%" >
</p>

-> **`update_notifications`** - allows user to subscribe to notifications.

<p align="center">
<img src="http://i.imgur.com/KLt9jHt.jpg" height="60%" width="60%" >
</p>

**How to send a message to subscribed users?**

You need to execute rake task with message you want to send as an attribute.
To do that, type `bundle exec rake send_notifications['Message to send.']`. That's it.
