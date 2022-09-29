import React from "react";

export default function TokenTutorial(props) {
  if (props.selfBot) {
    return <SelfBotTutorial />;
  } else {
    return <BotUserTutorial />;
  }
}

function SelfBotTutorial() {
  return <>
    <p>Press F12 (on most browsers) to open developer tools.</p><br/>
    <p>Visit <a href="https://discord.com/app">the discord app</a></p><br/>
    <p>Go the the Network tab, find a <code>library</code> request, and copy the <code>authorization</code> parameter</p><br/>
    <img src="/apps/faux/img/self-bot-token.png" width="60%" />
  </>;
}

function BotUserTutorial() {
  return <>
    <img src="/apps/faux/img/new-application.png" width="80%" />
    <p>Visit <a href="https://discord.com/developers/applications">the discord developers page</a> and create a new application. Name it whatever you like</p><br/>
    <img src="/apps/faux/img/create-bot.png" width="80%" />
    <p>Go to the Bot tab and add a bot</p><br/>
    <img src="/apps/faux/img/bot-token.png" width="80%" />
    <p>Reset the token, copy it and save it. This is the token you&apos;ll paste in the field above.</p><br/>
    <img src="/apps/faux/img/bot-link.png" width="80%" />
    <p>Create an invite url with these permissions and save it. This is how you&apos;ll invite your bot to the groups you want to bridge</p><br/>
    <img src="/apps/faux/img/message-content-intent.png" width="80%" />
    <p>Enable the &quot;message content&quot; privileged intent for your bot</p><br/>
  </>;
}
