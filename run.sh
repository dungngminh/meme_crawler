#!/bin/sh

# read the .env file and export it's content as environment variables
export $(egrep -v '^#' .env | xargs)

# put args to dart run


# Run the application
dart run --define=APPWRITE_PROJECT_ID=$APPWRITE_PROJECT_ID --define=APPWRITE_KEY=$APPWRITE_KEY bin/top_trending_meme_template_crawler.dart