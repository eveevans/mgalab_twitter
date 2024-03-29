import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import java.util.*;

import codeanticode.syphon.*;
SyphonServer server;

Twitter twitter;
String searchString = "Nicaragua";
List<Status> tweets;

int count;
double loopLength;

void setup() {
  size(1920,1080, P3D);
  
  server = new SyphonServer(this, "MGATwitter");

  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("");
  cb.setOAuthConsumerSecret("");
  cb.setOAuthAccessToken("");
  cb.setOAuthAccessTokenSecret("");

  TwitterFactory tf = new TwitterFactory(cb.build());
  twitter = tf.getInstance();

  getNewTweets();
  count = 0;

  thread("refreshTweets");
}

void draw() {
  background(0,0,0,255);
  
  if(count > loopLength - 1 ) {
    count = 0;
  }

  fill(200);
  textSize(40);
  textAlign(CENTER, CENTER);
  for(int i = 0 ; i < 3; i++) {
    int current = (count * 3) + i;
    if(current <  tweets.size()) {
      Status status = tweets.get(current);
      //text( str(current + 1), (640 * i) + 40, 0, 640 - 40 * (i+1) , 980);
      text(status.getText(), (640 * i) + 40, 0, 640 - 40 * (i+1) , 980);
    }
  } 

  count += 1;
  server.sendScreen();
  delay(5 * 1000);
}

void getNewTweets(){
  try {
    Query query = new Query(searchString);

    QueryResult result = twitter.search(query);
    tweets = result.getTweets();
    loopLength = ceil( tweets.size() / 3.0);
  }
  catch (TwitterException te) {
    System.out.println("Failed to search tweets: " + te.getMessage());
    System.exit(-1);
  }
}

void refreshTweets() {
  while (true) {
    getNewTweets();
    println("List refreshed");
    for(int i = 0 ; i < tweets.size(); i++) {
      Status status = tweets.get(i);
      println( i+1 + ": ===========================");
      println(status.getText());
    }
    delay(30 * 1000);
  }
}
