import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

// key for session cache in localstorage
var storageKey = "solved";

let app = Elm.Main.init({
  node: document.getElementById('root'), 
  flags: localStorage.getItem(storageKey)
});

// when the cache msg is sent, store the session data into local storage
app.ports.cache.subscribe(function (data) {
  localStorage.setItem(storageKey, JSON.stringify(data))
})

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();

