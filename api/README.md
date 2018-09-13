# README
## Environment
- Ruby 2.5.1
- Rails 5.2.1

## Setup
### Set environmental variables
| key | type | description |
|:--:|:--:|--:|
| SECRET_KEY_BASE | String | see the description below to generate |
| FACEBOOK_APP_ID | String | Facebook App ID for OAuth Login |
| FACEBOOK_APP_SECRET | String | Facebook App Secret for OAuth Login |
| GOOGLE_PROJECT_ID | String | Google Project ID for OAuth Login |
| GOOGLE_CLIENT_ID | String | Google Client ID for OAuth Login |
| GOOGLE_CLIENT_SECRET | String | Google Client Secret for OAuth Login |
| SLACK_TOKEN | String | Slack API Token |
| TWITTER_CONSUMER_KEY | String | Twitter Consumer Key |
| TWITTER_CONSUMER_SECRET | String | Twitter Consumer Secret |
| TWITTER_ACCESS_TOKEN | String | Twitter Access Token |
| TWITTER_ACCESS_TOKEN_SECRET | String | Twitter Access Token Secret |


### install dependencies
```bash
$ bundle install --path vendor/bundle
```

### generate SECRET_KEY_BASE
```bash
$ echo SECRET_KEY_BASE=`bundle exec rails secret` >> .env
```

## Facebook OAuth Login
1. Create Facebook App on [Facebook App Console](https://developers.facebook.com/apps/)
2. Add the product `Facebook Login`
3. Set `https://localhost:9292/v1/auth/facebook/callback` as OAuth redirect URI on Facebook App Console

## Google OAuth Login
1. Create Google Project on [Google API Console](https://console.developers.google.com/)
2. Create OAuth Information
3. Set `https://localhost:9292/v1/auth/google/callback` as OAuth redirect URI on Credentials Settings
4. Get Client ID and Client Secret

## Twitter OAuth Login
1. Create Twitter App on [Twitter Application Management](https://apps.twitter.com)
2. Set `https://localhost:9292/v1/auth/twitter/callback` as OAuth callback URL on Twitter Application Management

## Slack Notification
1. Publish Slack OAuth token
2. Create #notification channel in Slack Team
