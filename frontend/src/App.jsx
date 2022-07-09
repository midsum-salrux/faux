import BotType from "./BotType";
import Channels from "./Channels";
import NavBar, { BOT_TYPE, TOKEN, CHANNELS } from "./NavBar";
import React, { useState } from "react";
import Token from "./Token"
import Urbit from "@urbit/http-api";

function componentForPage(page) {
  if (page == BOT_TYPE) {
    return <BotType />;
  } else if (page == TOKEN) {
    return <Token />;
  } else if (page == CHANNELS) {
    return <Channels />;
  } else {
    return <p>Something went wrong</p>;
  }
}

export default function App() {
  const [page, setPage] = useState(BOT_TYPE);

  window.urbit = new Urbit("");
  window.urbit.ship = window.ship;

  return <>
    <NavBar page={page} setPage={setPage} />
    {componentForPage(page)}
  </>;
}
