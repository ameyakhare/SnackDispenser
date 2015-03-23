# SnackDispenser
SnackDispenser is a simple app that emulates a random snack dispenser.


Potentially useful custom implementations to use in your own app:
    Infinite Picker View in DispenserViewController
    
    Picker View with image and label in DispenserViewController



Dispenser View

The app opens to the Dispenser View which contains a custom made infinite scroll wheel that also displays an image. You can spin the wheel by clicking the spin button and then choose whether you would like to dispense the item or cancel. If the item is not in stock, you will not be able to dispense the item.

Stock Table View

The stock tab shows the list of items that are currently in the dispenser including the amount of each item. You can select any of the table cells and swipe to the left to delete it from the dispenser completely. You can also hit the + button on the top right to add your own dispenser item!

Add Snack View

Hitting the + button opens an Add Snack View where you can create a dispenser item by creating a name, selecting a picture, and declaring the number in stock! This will be added to the Stock Table View and the Dispenser View.

History Table View

Opening the history tab displays the recent items that you have dispensed and the date that you dispensed them. Don't want someone nosy looking at what you're eating? Just slide left on an individual cell to delete it, or hit the clear button on the top left.

All of the data is stored when you quit the app, including history and stock. If you open the app with an empty stock (such as on the first launch) the app will automatically generate a stock full of default snacks.



DispenserSnack - a single dispenser snack with stock, image, and name

SnacksManager - manages each dispenser snack throughout the app, including save and reload

HistoryItem - a single item that shows up in the history view, contains a DispenserSnack and NSDate

HistoryManager - manages each history item throughout the app, including save and reload



Created by Ameya Khare, March 2015
