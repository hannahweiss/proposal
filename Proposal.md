# Project Proposal

## Team
- Rohit Pathak
- Angela Hu
- Samedh Gupta
- Hannah Weiss

## Project Idea

Voice calls for developers on GitHub.  

We plan to build a voice calling platform for developers 
collaborating in a GitHub repository. We plan to provide
moderation tools for collaborators to foster better, constructive
communication.  

Calls correspond to specific repositories and are managed by the
collaborators of that repo. Other users can join these calls but will
only get the ability to talk when their request is approved by a
collaborator. This will help keep the conversation on track. 

If possible we want to add other features like broadcasting a GitHub
issue, pull request, or file to the other participants for further
discussion on said item.


## API 

We will be using the GitHub API for this project. Users will be
able to login to the application using their GitHub account, and then
we will access the repositories of each user so that they can create
voice channels associated with their repositories. In addition, we
are also using the search endpoint of Github to search for other
users to send friend requests to as well as repositories to join
voice channels for. Once a user is friends with another user, we will
also use the API to fetch pertinent user information, such as
username, email, avatar picture, and repositories. 

## Realtime Behavior 

The realtime behavior we are planning is an ongoing, live, call that 
collaborators and users can participate in. 

## Persistent State Stored in the DB

Other than user information, we are planning to store the
relationship between users, which currently will be the friends
feature. A user will be able to invite other Github users to be their
friend, which will then send a friend request. A user can log on and
accept the friend request, in which case the two users are now
friends. This will be useful in the case where friends can now easily
check each other's repositories, user information, or meeting
activity/history. This will also allow a user check up on a friend's
friends, which will increase the collaborative nature of the
application.

To accomplish this, we will create a join table between users and
friends. The User table will have pertinent information about a user,
including a user ID. The Friend table will have a requester (user ID
of the user who send the friend request), the invitee (the user ID of
the user who received the friend request), an active flag (to signal
whether the friend request has been accepted or not), and additional
created and updated timestamps.

If we get time, we are also planning to implement a small user's
recent history feature. Based on a user's recent activity, which is
namely joining a call on Github repositories, the application should
populate the associated table and show a list of recent repositories
the user has participated in. This will be accomplished using a
History table, which will have a user_id (the user ID of the user who
this action is based on), repository (the name of the repository
which the user has interacted with), and the timestamp (when the user
interacted with the given repository, which will determine the order
shown in the front end).

## Something Neat 

P2P media connection between multiple clients with complex moderation and
access control rules. 

## Experiment 1: Github API 

One of the experiments that we set up was testing the GitHub API to
make sure we would be able to interact with it within our application.
We did this entirely in a Phoenix project so that we could ensure we
would be able to use Elixir to call the API without problems. There
were a few other libraries that we needed to install in order to work
with HTTP requests, HTTPoison for sending get/post requests, and
Poison for parsing JSON responses. 

The first step was making sure users would be able to use our 'login
via Github' feature. We were able to do this by looking at
documentation for the Github API, along with other examples of people
creating similar features. We registered our application and local
endpoint as an authorized application with GitHub so that we could get
a client id and client secret to use when connecting with the API for
login requests. We got this feature mostly working when the app is
running locally, so that users can click on a link to sign in that
will redirect them to a GitHub page where they can log into their
account. However, we did run into some issues with this where
refreshing the page throws an error. This error is most likely caused
by authentication codes being renewed or expiring, but we were not
able to pinpoint exactly what was going wrong during this experiment.

The next feature we tested with the GitHub API was being able to
search for GitHub users by username. We were able to complete this part of
the experiment, so that once you are logged in you can enter a user's
name and will receive a list of GitHub profiles with the associated
profile photos. In our final application, this will be part of our "friends"
feature, where a user can look up other people on GitHub and then send
them a friend request. 

There are still a few use cases of the API that we need to make sure
are working for our project. Another idea that we had for the final
application was to list each repository of a user on their page, and
their friends' repositories when they go to a friend's page. This will
be part of the feature that allows users to create voice channels that
are associated with a specific GitHub repo. Overall, we feel that
this is at a stage where we have not implemented everything that we
need, and still have a few issues to deal with, but we will be able to
work with it to get everything working for the final project.

While working on this experiment, we learned about the advantages of
doing Github authorization versus storing our own user passwords. The
use of Github means that we do not need to worry about encrypting
passwords and storing them in a database, and removes some of the
difficulties of authentication from our app. However, dealing with
the tokens and authorization through Github provides some of its own
complications, and we will need to spend some time figuring out how to
make sure users stay logged in even if they refresh the page or
navigate away.

## Experiment 2: WebRTC Library 

The second experiment we decided to run was to test how to utilize the
WebRTC and PeerJS libraries to make an audio connection and the
getMediaDevice function to access the user's microphone. We tested
setting up the peer to peer connections and streamed microphone audio
between multiple clients. We found that the WebRTC API makes the
process relatively simple. However we also found that some things like
negotiating the connection needed to be manually handled by us. While
we could have done it ourselves, we found the PeerJS library. PeerJS
is a thin wrapper around the WebRTC API and allows us to abstract out
a ton of the details that need to be manually managed by us. 

We setup 2 tiny programs to demonstrate how the project will work. 

First: A client React app, whose job is to send its local audio stream
and play the audio stream of all the other people in the call. This
app contacts the server described below to obtain a list of `id`s to
connect to and uses the `ExpressPeerServer` to establish the
connection.

Second: An `Express` server whose job is to facilitate connections
between clients. Currently this server also keeps track of users in
the room and provides new users with the `id`s of the current users.
We believe that in the future, this responsibility will be delegated
to the Elixir server which will manage access control and rooms.
Note: Currently the test server doesn't maintain multiple rooms but
implementing it should be trivial so we decided against doing it in
this experiment.

We realized some challenges with our approach. Firstly some computers
are behind a symmetric NAT which blocks us from creating such a peer
to peer connection directly. This nessesitates the need for an ICE
server that facilitates this connection. The server only acts to
establish the connection, all data sent after is sent directly between
the peers.

We also found that we needed to use the `ref` attribute for media
playback. The audio component needed the `refs` to set the `srcObject`
to be set to the media stream (which we didnt realize was causing errors
in the beginning). After reading the documentation we were able to get
the audio playback to work correctly.

With these programs we were able to successfully connect multiple
users to one call and demonstrate the feasibility of the project. The
tooling is well documented. We did not run into many problems in
setting up the "something neat" for this project. 

## Application Users and Workflows

 - Collaborators:
    - Can start calls on a repository 
    - Can join calls without requiring permissions
    - Can admit users into calls and remove people from the talking
      queue

 - Contributors:
    - Can request to join the talk queue
    - Get priority in the talk queue compared to non-collaborators.
 
 - Other users:
    - Can request to join the talk queue

### User Stories

#### User Story 1: Joining an existing call as a collaborator
 - Alice signs in with her Github account.
 - She is redirected to a list of her repositories (owned and
   starred).
 - She is a collaborator on `project-a` which has an ongoing call.
 - She clicks the project and gets connected to all the people on the
   call.
 - They discuss bug fixes on the call
 - The call ends when everyone has left the room.

#### User Story 2: Joining a call as a non-collaborator
 - Bob signs in with his Github account.
 - He is a user of `project-a` and sees the ongoing call.
 - Bob has a question about the usage of the library and puts himself
   on the talk queue
 - Alice approves Bob to talk and his mic gets connected to all the
   users.
 - Bob discusses his question with the current users on the call.
 - Once his question is answered he leaves the call.

#### User Story 3: Starting a call as a collaborator
 - Charlie signs in with his GitHub account.
 - He is a collaborator on `project-b`.
 - He has planned to have a meeting regarding recent security bugs in
   `project-b`.
 - Seeing as no one has started a meeting yet, he clicks on the "Start
   Call" button and waits for him teammates to join.
 - The call ends when no one is in the room anymore.

#### User Story 4: Rejected user
 - Danielle signs in with her GitHub account.
 - She sees that there is a meeting going on in a repository that she
   has starred.
 - She requests to join the call and is put on the talk queue.
 - When it is her turn the admins realize that she is a well-known
   troll and remove her from the talk queue. 

#### User Story 5: Joining a call as a contributer
  - Evan signs in with his GitHub account.
  - He is a contributer of `project-c` and sees an ongoing call.
  - He has a question about the new feature being added and adds 
    himself to the talk queue.
  - His position in the queue is automatically placed before
    non-collaborating users but behind any contributers already in
    the queue.

#### User Story 6: Accepting a talk request as a collaborator
  - Fiona signs in with her GitHub account.
  - She is a collaborator of `project-c` and sees an ongoing call.
  - She joins the call.
  - She views the queue and sees Evan, a known contributer, at the
    front of the queue. 
  - She clicks the "Allow" button to let Evan into the call.
  - Evan now has the ability to talk in the call. 

