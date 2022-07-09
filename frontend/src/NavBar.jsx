import React from "react";

// pages
export const BOT_TYPE = "botType"
export const TOKEN = "token"
export const CHANNELS = "channels"

export default function NavBar(props) {
  function pageClicker(page) {
    return function (e) {
      e.preventDefault();
      props.setPage(page);
    }
  }

  return <>
    <div className="d-flex flex-column flex-md-row align-items-center p-3 px-md-4 mb-3 bg-white border-bottom box-shadow">
      <h5 className="my-0 mr-md-auto font-weight-normal">Faux</h5>
      <nav className="my-2 my-md-0 mr-md-3">
        <a className="p-2 text-dark" href="#"
           onClick={pageClicker(BOT_TYPE)}>
          {props.page == BOT_TYPE ? <b>Bot Type</b> : "Bot Type" }
        </a>
        <a className="p-2 text-dark" href="#"
           onClick={pageClicker(TOKEN)}>
          {props.page == TOKEN ? <b>Token</b> : "Token" }
        </a>
        <a className="p-2 text-dark" href="#"
           onClick={pageClicker(CHANNELS)}>
          {props.page == CHANNELS ? <b>Channels</b> : "Channels" }
        </a>
      </nav>
    </div>
  </>
}
