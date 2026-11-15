# SourceId

A NoResponse source: github (GitHub accounts), phone (the phone lookup), breach (breach exposure), rdap (the email domain's registration), mx (the email domain's mail servers), ipintel (IP intelligence) or an email account source that searches one platform for an account by email address (adobe, nvidia, wix, life360, zapier, x_email, snapchat_email, amazon, spotify_email, google, duolingo_email). x_email, snapchat_email, amazon and spotify_email only say whether the email has an account on X, Snapchat, Amazon or Spotify. google runs only for Gmail addresses. scratch, dailymotion, substack, duolingo, dockerhub, wikipedia, internetarchive, telegram, spotify, patreon, wordpress, okru and flickr each search that platform for an account by username; telegram also searches by phone number, through a logged-in Telegram lookup account. whatsapp searches WhatsApp for an account by phone number, and life360_phone searches Life360 for one. opplysningen (1881, Norway), ratsit (Sweden) and reverseaustralia (Australia) each look up a phone number of their own country on that site. youtube searches YouTube for a channel by username.

## Example Usage

```ruby
require "noresponse"

value = SourceId::GITHUB

# Open enum: use .deserialize() to create instances from custom string values
custom = SourceId.deserialize("custom_value")
```


## Values

| Name               | Value              |
| ------------------ | ------------------ |
| `GITHUB`           | github             |
| `PHONE`            | phone              |
| `BREACH`           | breach             |
| `RDAP`             | rdap               |
| `MX`               | mx                 |
| `IPINTEL`          | ipintel            |
| `ADOBE`            | adobe              |
| `NVIDIA`           | nvidia             |
| `WIX`              | wix                |
| `LIFE360`          | life360            |
| `LIFE360_PHONE`    | life360_phone      |
| `ZAPIER`           | zapier             |
| `X_EMAIL`          | x_email            |
| `SNAPCHAT_EMAIL`   | snapchat_email     |
| `AMAZON`           | amazon             |
| `SPOTIFY_EMAIL`    | spotify_email      |
| `GOOGLE`           | google             |
| `SCRATCH`          | scratch            |
| `DAILYMOTION`      | dailymotion        |
| `SUBSTACK`         | substack           |
| `DUOLINGO`         | duolingo           |
| `DUOLINGO_EMAIL`   | duolingo_email     |
| `DOCKERHUB`        | dockerhub          |
| `WIKIPEDIA`        | wikipedia          |
| `INTERNETARCHIVE`  | internetarchive    |
| `TELEGRAM`         | telegram           |
| `YOUTUBE`          | youtube            |
| `SPOTIFY`          | spotify            |
| `PATREON`          | patreon            |
| `WORDPRESS`        | wordpress          |
| `OKRU`             | okru               |
| `FLICKR`           | flickr             |
| `WHATSAPP`         | whatsapp           |
| `OPPLYSNINGEN`     | opplysningen       |
| `RATSIT`           | ratsit             |
| `REVERSEAUSTRALIA` | reverseaustralia   |