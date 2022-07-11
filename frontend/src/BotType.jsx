import { TOKEN } from "./NavBar";
import React from "react";

export default function BotType(props) {
  function pokeBotUser() {
    props.configPoke({botToken: props.config.botToken,
                      selfBot: false,
                      channels: props.config.channels});
    props.setPage(TOKEN);
  }

  function pokeSelfBot() {
    props.configPoke({botToken: props.config.botToken,
                      selfBot: true,
                      channels: props.config.channels});
    props.setPage(TOKEN);
  }

  return <>
    <div className="px-3 py-3 pt-md-1 pb-md-1 mx-auto text-center">
      <h3>Bot Type</h3>
    </div>

    <div className="container">
      <div className="card-deck mb-3 text-center">
        <div className="card mb-4 box-shadow">
          <div className="card-header">
            <h4 className="my-0 font-weight-normal">Bot User{props.config.selfBot ? "" : " (Default)"}</h4>
          </div>
          <div className="card-body">
            <p>Create a new bot user and invite it to your group. This is the recommended way to use Faux.</p>
            <button type="button" className="btn btn-lg btn-block btn-primary"
                    onClick={pokeBotUser}>Continue</button>
          </div>
        </div>
        <div className="card mb-4 box-shadow">
          <div className="card-header">
            <h4 className="my-0 font-weight-normal">Self-Bot{props.config.selfBot ? " (Selected)" : ""}</h4>
          </div>
          <div className="card-body">
            <p>Connect to your personal discord account. This is against the discord terms of service, and could result in your account getting banned.</p>
            <button type="button" className="btn btn-lg btn-block btn-primary"
                    onClick={pokeSelfBot}>Continue</button>
          </div>
        </div>
      </div>
    </div>
  </>
}
