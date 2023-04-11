# About SocialifyMe

**SocialifyMe** is a _social media_ application similar to [Instagram](https://www.instagram.com) and [Facebook](https://www.facebook.com) in which users can create an account, see other users' posts, and post pictures of their own. The application is using [Firebase](https://www.firebase.com) for _Authentication_, _Database Management_, and _Storage_.

Following is a list of functionalities of **SocialifyMe**[^1]:
- [x] Sign up:
  - Users can sign up either using their email address and password or with **Google** or **Facebook**.
  -	If the users are signing up with an email address and password, they have to create their profile at the time of signing up.
  -	If the users are signing up with **Google** or **Facebook**, a partial profile is created using the details obtained from the respective provider. Once the account is created, they are asked if they would like to complete their profile.
  -	The users can also upload a profile photo regardless of how they are signing up.
  -	The application keeps track of how the users are signing up, i.e. with **Google**, **Facebook** or email address and password.
-	[x] Sign in:
	-	Users can sign in using the same method they used to sign up.
	-	The application keeps track of which method the users used to sign up. So, if they used Google for signing up, and, later, at the the of signing in they are not using the Sign in with **Google** option, but are using the same email address instead, the application will prompt them they they should try signing in with **Google**.
-	[x] Sign out:
	-	The users can also sign out of the application.
	-	The sign out function also signs users out of their provider accounts, if applicable.
-	[x] Posts (requires the users to be logged in):
	-	The users can post photos and, optionally, include some description to go along with the post.
	-	The users can see all the posts created by other users.
	-	The posts are sorted by their upload time. Hence, the newer the post, the higher will it be on the users’ feed tab.
	-	The post shows the user’ profile photo, their name, and the date, time the post was created, the photo, and the description, if included.
-	[x] Localisation:
	-	The application also supports localisation.
	-	The supported languages are: **English**, **Hindi** and **Arabic**.
	-	Every UI element is localised. This includes ViewController titles, Tab Bar titles, Labels, Textfield placeholders, Buttons, and Alerts.
- [ ] Explore:
  -	Users can see who is _following_ them, whom they are _following_, and they can also search for other users in the database.
  -	Users can send a _follow request_ too.
- [ ] Messages:
  -	Users can send messages to other users.
- [x] Profile:
  - Users can update their profile including their name, gender, age, phone number, address, and profile photo.

## Firebase

The table below maps the features of **Firebase** to the features of **SocialifyMe**.

<table>
  <thead>
    <tr>
      <th>Firebase Feature</th>
      <th> SocialifyMe Feature</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan=3>Authentication</td>
      <td>Sign up</td>
    </tr>
    <tr>
      <td>Sign in</td>
    </tr>
    <tr>
      <td>Sign out</td>
    </tr>
    <tr>
      <td rowspan=2>Realtime Database</td>
      <td>User profile</td>
    </tr>
    <tr>
      <td>Post data</td>
    </tr>
    <tr>
      <td rowspan=2>Storage</td>
      <td>Profile photo</td>
    </tr>
    <tr>
      <td>Post photo</td>
    </tr>
  </tbody>
</table>

# Screenshots
### iPhone 14 Pro Light Mode
<p align="center">
  <img src="https://github.com/rishikdev/Images/blob/main/SocialifyMe/Light/OnboardingView.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/SocialifyMe/Light/HomeView.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/SocialifyMe/Light/ExploreView.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/SocialifyMe/Light/MessagesView.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/SocialifyMe/Light/SettingsView.png" width = 250/>
</p>

### iPhone 14 Pro Dark Mode
<p align="center">
  <img src="https://github.com/rishikdev/Images/blob/main/SocialifyMe/Dark/OnboardingView.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/SocialifyMe/Dark/HomeView.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/SocialifyMe/Dark/ExploreView.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/SocialifyMe/Dark/MessagesView.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/SocialifyMe/Dark/SettingsView.png" width = 250/>
</p>

[^1]: The list includes the features that are either implemented completely or are currently being developed. The features that have been implemented are marked by a _check mark_, otherwise they are unmarked.
