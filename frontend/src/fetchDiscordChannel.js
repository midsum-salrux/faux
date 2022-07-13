export default async function fetchDiscordChannel(channelId, token, selfBot) {
  const url = "https://discord.com/api/v9/channels/" + channelId
  const botUserHeaders = {
    "Authorization": "Bot " + token,
    "Content-Type": "application/json",
    "User-Agent": "Faux (https://github.com/midsum-salrux/faux, 0.1)"
  };
  const selfBotHeaders = {}; // TODO

  const response = await fetch(url, {
    headers: selfBot ? selfBotHeaders : botUserHeaders
  });

  return response.json;
}
