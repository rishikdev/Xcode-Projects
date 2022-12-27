# About [My Notes Plus](https://apps.apple.com/us/app/my-notes-plus/id1636570752?itsct=apps_box_badge&itscg=30200)

My Notes Plus uses ***Core Data with CloudKit*** to persist user data both locally, and on iCloud. This provides synchronisation of data between multiple devices which makes it easier for the users to start work on one device and continue their work on other devices.

There are some modifiers that I have used in this application which are only supported in iOS versions 15 and above. Therefore, this application is only compatible with devices that run ***iOS 15 or later***. One such modifier is the <code>.searchable</code> modifier which makes it quite easy to implement the search functionality.

I have also implemented ***swipe to pin/unpin notes*** along with ***swipe to delete*** using the <code>.swipeActions</code> modifier.

There are ***two views*** the users can choose between: first is the traditional ***list view*** in which the notes are presented as a list, while the second is the ***card view*** in which the notes are displayed as cards just like *post-it* notes.

Users can also add ***coloured tags*** to their notes. These tags can be used to ***filter*** notes, thereby helping the users organise their notes in an efficient manner.

I have added ***context menu*** using the <code>.contextMenu</code> modifier to this application using which the users can change the tags associated with any note without going into the edit view, delete the note, and, if they are in the ***card view mode***, they can also change the colour of the card.

In the latest update, I have added the ability to ***sort notes*** either by ***Date*** or by ***Title*** in ***ascending*** as well as ***descending*** order.

I have also integrated ***biometric authentication*** using <code>.deviceOwnerAuthentication</code>. The users can opt-in to use this feature from the newly added ***Settings*** sheet found on the bottom left of the application's home screen. This makes the data stored in this application more secured. On devices that do not have Touch ID or Face ID, the users can use their Passcode to unlock the application.

## Widgets
I have also implemented ***widgets*** using <code>WidgetBundle</code>. Widgets are available in three sizes, and they are ***customisable***. The users can select the note they want to see on their home screen. In the medium size widget, the users can select upto two widgets that wil be displayed side-by-side. In the large size widget, the users are shown a list of their notes by default, but they also have the option of choosing a note that they want to see instead.

## Apple Watch Application
In addition to implementing widgets, I have also developed a ***companion Apple Watch application***. With the watch application, users can add, pin/unpin or delete a note, and they can also view a note which they created on their iPhone or iPad. Since My Notes Plus uses CloudKit to persist data on iCloud, the notes created on any device will be available on other devices signed-in with the same Apple ID.

# Screenshots
### iPhone 11 Pro Light Mode
<p align = "center">
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPhone%2011%20Pro/Light/List.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPhone%2011%20Pro/Light/Card.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPhone%2011%20Pro/Light/Context%20Menu.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPhone%2011%20Pro/Light/Filter.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPhone%2011%20Pro/Light/Settings.png" width = 250/>
</p>

### iPhone 11 Pro Dark Mode
<p align = "center">
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPhone%2011%20Pro/Dark/List.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPhone%2011%20Pro/Dark/Card.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPhone%2011%20Pro/Dark/Context%20Menu.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPhone%2011%20Pro/Dark/Filter.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPhone%2011%20Pro/Dark/Settings.png" width = 250/>
</p>

### iPad Pro Light Mode
<p align = "center">
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPad%20Pro/Light/List.png" width = 500/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPad%20Pro/Light/Card.png" width = 500/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPad%20Pro/Light/Context%20Menu.png" width = 500/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPad%20Pro/Light/Filter.png" width = 500/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPad%20Pro/Light/Settings.png" width = 500/>
</p>

### iPad Pro Dark Mode
<p align = "center">
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPad%20Pro/Dark/List.png" width = 500/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPad%20Pro/Dark/Card.png" width = 500/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPad%20Pro/Dark/Context%20Menu.png" width = 500/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPad%20Pro/Dark/Filter.png" width = 500/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/iPad%20Pro/Dark/Settings.png" width = 500/>
</p>

### Widgets
<p align = "center">
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/Widgets/Small.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/Widgets/Medium%20Separate.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/Widgets/Medium%20Combined.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/Widgets/Large%20List.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/Widgets/Large%20Note.png" width = 250/>
</p>

### Apple Watch Series 7 (45mm)

<p align = "center">
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/Apple%20Watch/Buttons.png" width = 200/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/Apple%20Watch/New%20Note.png" width = 200/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/Apple%20Watch/Detail%20View.png" width = 200/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Plus/Apple%20Watch/Filter.png" width = 200/>
</p>

# Where to find My Notes Plus
You can [download](https://apps.apple.com/us/app/my-notes-plus/id1636570752?itsct=apps_box_badge&itscg=30200) the application from the App Store!
