import tweepy
import json

API_KEY = "4uVOD6ewnumaiFhJKfriL0D9j"
API_SECRET_KEY = "kzF6bXAAIq4d1NmgChmh1Wa3rJNDqFQd9tZXXtsE9TO87O0htg"
BEARER_TOKEN = "AAAAAAAAAAAAAAAAAAAAAFKM3gEAAAAA7ycPRfAI5oCsFCwYKK1ut2U0%2Bgs%3DpdlEFu4YsGjibEOjbjx0CNI0UrOfpC1oIBoVDzM7ZiwxHyqjfz"
ACCESS_TOKEN = "1957415390625292288-Ies0v7ZThcgYsvTXFEeG1xhzbYnVHE"
ACCESS_TOKEN_SECRET = "HWCeOENdWlgS1xsdAEq2DYNs93MCzVkEs8rMld5GK1XUz"

if __name__ == "__main__":
    try:
        # http object used for interacting with twitter API
        twitterClient = tweepy.Client(
            bearer_token=BEARER_TOKEN,
            access_token_secret=ACCESS_TOKEN_SECRET,
            consumer_key=API_KEY,
            consumer_secret=API_SECRET_KEY,
            access_token=ACCESS_TOKEN,
            wait_on_rate_limit=True,
        )

        # USER ID Extraction (user handle -> user id)
        user = twitterClient.get_user(username="sundarpichai")
        user_id = user.data.id

        # using the user id we get the tweets
        tweets  = twitterClient.get_users_tweets(
            user_id,
            max_results=5, # for people who got the output -> 50
            tweet_fields=['created_at', 'public_metrics', 'text']
        )

        # save the tweets to json file
        with open("extracted_tweets.json", "w") as json_file: #<--------- output for analysis of tweets
            # [].map(e=>e.toString())
            json.dump([tweet.data for tweet in tweets.data], json_file, indent=4)
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
