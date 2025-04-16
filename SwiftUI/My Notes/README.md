# About [My Notes](https://apps.apple.com/us/app/my-notes-secure-organised/id1616417517?ign-itscg=30200&ign-itsct=apps_box_badge)

I have developed this application because I wanted to learn iOS development. While doing so, I learned about the ***MVVM Architecture*** in which the **UI component (view)** of the application is completely isolated from the **logic** of the application. I also learned how to save user data locally using ***Core Data***.

There are some modifiers that I have used in this application which are only supported in iOS versions 15 and above. Therefore, this application is only compatible with devices that run ***iOS 15 or later***. One such modifier is the <code>.searchable</code> modifier which makes it quite easy to implement the search functionality.

I have also implemented the slide to edit feature along with the ***Edit*** button in the top left, which, currently, only supports **deleting** a note. I am planning to add more functionalities, such as the ability to **lock** a note, in future in this edit menu.

Users can also add ***coloured tags*** to their notes. These tags can be used to ***filter*** notes, thereby helping the users organise their notes in an efficient manner.

I have also added ***context menu*** using the <code>.contextMenu</code> modifier to this application using which the users can change the tags associated with any note without going into the edit view.

In the latest update, I have added ***biometric authentication*** using <code>.deviceOwnerAuthentication</code>. The users can opt-in to use this feature from the newly added ***Settings*** sheet found on the bottom left of the application's home screen. This makes the data stored in this application more secured. On devices that do not have Touch ID or Face ID, the users can use their Passcode to unlock the application.

In addition to biometric authentication, I have also provided links to the [application's website](https://rishikdev.github.io/MyNotes), [privacy policies](https://rishikdev.github.io/MyNotes/PrivacyPolicy), and [support website](https://rishikdev.github.io/MyNotes/ContactUs) should the users have any trouble using the application.

This applications also supports both ***light*** as well as ***dark*** mode across all devices natively. Currently I have limited the compatibility to just the iPhones (iOS 15 and later) as I do not have an iPad to test this application on. However, support for iPads can be enabled without changing much of the program.

You can [download](https://apps.apple.com/us/app/my-notes-secure-organised/id1616417517?ign-itscg=30200&ign-itsct=apps_box_badge) the application from the App Store!

# Screenshots (iPhone 11 Pro Light Mode)
<p align = "center">
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Screenshots/iPhone%2011%20Pro/New%20Note%20Light.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Screenshots/iPhone%2011%20Pro/Homescreen%20Light.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Screenshots/iPhone%2011%20Pro/Context%20Menu%20Light.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Screenshots/iPhone%2011%20Pro/Filter%20Modal%20Light.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Screenshots/iPhone%2011%20Pro/Filtered%20Result%20Light.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Screenshots/iPhone%2011%20Pro/Search%20Light.png" width = 250/>
</p>

# Screenshots (iPhone 11 Pro Dark Mode)
<p align = "center">
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Screenshots/iPhone%2011%20Pro/New%20Note%20Dark.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Screenshots/iPhone%2011%20Pro/Homescreen%20Dark.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Screenshots/iPhone%2011%20Pro/Context%20Menu%20Dark.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Screenshots/iPhone%2011%20Pro/Filter%20Modal%20Dark.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Screenshots/iPhone%2011%20Pro/Filtered%20Result%20Dark.png" width = 250/>
  <img src="https://github.com/rishikdev/Images/blob/main/My%20Notes%20Screenshots/iPhone%2011%20Pro/Search%20Dark.png" width = 250/>
</p>
