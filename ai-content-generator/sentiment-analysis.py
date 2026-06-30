import json
import time

from run_prompt import execute_gemini

with open("extracted_tweets.json") as extracted_tweets_file:
    extracted_tweets = json.load(extracted_tweets_file)

    analyzed_tweets = [] # <--- list of analyzed tweets

    for tweet in extracted_tweets:
        time.sleep(5)
        sentiment_analysis_prompt = f"""
            Tweet: {tweet["text"]}
            like_count: {tweet["public_metrics"]["like_count"]}
            retweet_count: {tweet["public_metrics"]["retweet_count"]}
            reply_count: {tweet["public_metrics"]["reply_count"]}
            impression_count: {tweet["public_metrics"]["impression_count"]}
            Read the tweet with regard to its public reception and provide keywords and sentiment analysis score
        """
        out = execute_gemini(sentiment_analysis_prompt)
        out_dict = json.loads(out) # <-------- converting json string to python dict
        print(out)
        out_dict["tweet"] = tweet["text"] # <----- adding a new key to the dict
        analyzed_tweets.append(out_dict)

    with open("analyzed_tweets.json", "w") as analyzed_tweets_file:
        json.dump(analyzed_tweets, analyzed_tweets_file) # <--- dumping whole list into a json file (phase 1 output)

