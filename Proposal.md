# Project Proposal

## Team
- Rohit Pathak
- Angela Hu
- Samedh Gupta
- Hannah Weiss

## Project Idea

## API
We will be using the Github API for this project. Users will be able to login to the application using github, and then we will access the repositories of each user so that they can create voice channels associated with their repositories.

## Realtime Behavior

## Persistant State Stored in the DB

## Something Neat

## Experiment 1: Githup API
One of the experiments that we set up was testing the Github API to make sure we would be able to interact with it within our application. We did this entirely in a Phoenix project, so that we could ensure we would be able to use elixir to call the API without problems. There were a few other libraries that we needed to install in order to work with HTTP requests, HTTPoison for sending get/post requests, and Poison for parsing JSON responses. 

The first step was making sure users would be able to use our 'login via Github' feature. We were able to do this by looking at documention for the Github API, along with other examples of people creating similar features. We registered oru application and local endpoint as an authorized application with Github so that we could get a client id and client secret to use when connecting with the API for login requests. We got this feature mostly working when the app is running locally, so that users can click on a link to sign in that will redirect them to a Github page where they can log into their account. However, we did run into some issues with this where refershing the page throws an error. This error is most likely caused by authentication codes being renewed or exiring, but we were not able to pinpoint exactly what was going wrong during this experiment.

The next feature we tested with the Github API was being able to search for Github users by name. We were able to complete this part of the experiment, so that once you are logged in you can enter a user's name and will receive a list of github profiles with the associated photos. In our final application, this will be part of our friends feature, where a user can look up other people on Github and then send them a friend request. 

## Experiment 2: WebRTC Library

## Application Users
