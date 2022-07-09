import { CHANNELS } from "./NavBar";
import React, { useState } from "react";

export default function Token(props) {
  const [botToken, setBotToken] = useState("");

  function pokeBotToken() {
    props.configPoke({botToken: botToken, channels: props.config.channels});
    props.setPage(CHANNELS);
  }

  return <div className="container">
    <div className="row">
      <div className="px-3 py-3 pt-md-5 pb-md-4 mx-auto text-center">
        <h1 className="display-4">Token</h1>
        {props.config.botToken ? <p className="lead">Your current token is <code>{props.config.botToken}</code></p> : ""}
        <div className="input-group">
          <input type="text" id="botToken" className="form-control" placeholder="New Token"
                 onChange={(e) => setBotToken(e.target.value)} />
          <div className="input-group-append">
            <button className="btn btn-primary" onClick={pokeBotToken}>Continue</button>
          </div>
        </div>
      </div>
    </div>
  </div>
}
